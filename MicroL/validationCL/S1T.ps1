using namespace System.Net

param($Request, $TriggerMetadata)

# ==================================================
# AWS CONFIGURATION
# ==================================================

$AccessKey = ""
$SecretKey = ""

$Region = "us-east-1"
$VMName = "lab-vm-143"

try {

    Write-Host "Initializing AWS credentials..."

    Set-AWSCredential `
        -AccessKey $AccessKey `
        -SecretKey $SecretKey

    Initialize-AWSDefaultConfiguration `
        -Region $Region

    Write-Host "Searching for VM: $VMName"

    $Reservation = Get-EC2Instance `
        -Region $Region `
        -Filter @(
            @{ Name = "tag:Name"; Values = @($VMName) },
            @{ Name = "instance-state-name"; Values = @("running") }
        )

    $Instance = $Reservation |
        Select-Object -ExpandProperty Instances |
        Select-Object -First 1

    if (-not $Instance) {

        Push-OutputBinding -Name Response -Value (
            [HttpResponseContext]@{
                StatusCode = 200
                Body = "FAIL: Instance not found"
            }
        )

        return
    }

    $InstanceId = $Instance.InstanceId

    Write-Host "Instance Found: $InstanceId"

    # ==============================================
    # VALIDATION COMMANDS
    # ==============================================

    $Commands = @(
        'SCRIPT="/home/Labuser/scripts/parse_logs.sh"',
        '[ -f "$SCRIPT" ] || { echo FAIL; exit 1; }',
        '[ -x "$SCRIPT" ] || { echo FAIL; exit 1; }',
        'grep -q "/opt/logs/application.log" "$SCRIPT" || { echo FAIL; exit 1; }',
        'OUTPUT=$($SCRIPT 2>/dev/null)',
        'ERROR_LINES=$(echo "$OUTPUT" | grep -i "error" | wc -l)',
        '[ "$ERROR_LINES" -ge 1 ] || { echo FAIL; exit 1; }',
        'TOTAL_ERRORS=$(echo "$OUTPUT" | grep -oE "Total Errors:[[:space:]]*[0-9]+" | grep -oE "[0-9]+")',
        '[ -n "$TOTAL_ERRORS" ] || { echo FAIL; exit 1; }',
        '[ "$TOTAL_ERRORS" -ge 3 ] || { echo FAIL; exit 1; }',
        'echo PASS'
    )

    Write-Host "Sending SSM command..."

    $Response = Send-SSMCommand `
        -Region $Region `
        -DocumentName "AWS-RunShellScript" `
        -InstanceId $InstanceId `
        -Parameter @{
            commands = $Commands
        }

    $CommandId = $Response.CommandId

    if (-not $CommandId) {

        Push-OutputBinding -Name Response -Value (
            [HttpResponseContext]@{
                StatusCode = 200
                Body = "FAIL: Command submission failed"
            }
        )

        return
    }

    Write-Host "Command ID: $CommandId"

    do {

        Start-Sleep -Seconds 5

        $Invocation = Get-SSMCommandInvocation `
            -Region $Region `
            -CommandId $CommandId `
            -InstanceId $InstanceId

        $Status = $Invocation.Status

        Write-Host "Current Status: $Status"

    } while ($Status -in @("Pending","InProgress","Delayed"))

    $Output = $Invocation.StandardOutputContent
    $ErrorOutput = $Invocation.StandardErrorContent

    Write-Host "===== STDOUT ====="
    Write-Host $Output

    if ($ErrorOutput) {
        Write-Host "===== STDERR ====="
        Write-Host $ErrorOutput
    }

    if (($Status -eq "Success") -and ($Output -match "PASS")) {

        Push-OutputBinding -Name Response -Value (
            [HttpResponseContext]@{
                StatusCode = 200
                Body = "PASS"
            }
        )
    }
    else {

        Push-OutputBinding -Name Response -Value (
            [HttpResponseContext]@{
                StatusCode = 200
                Body = "FAIL"
            }
        )
    }

}
catch {

    Write-Host "ERROR OCCURRED"
    Write-Host $_.Exception.Message

    Push-OutputBinding -Name Response -Value (
        [HttpResponseContext]@{
            StatusCode = 500
            Body = $_.Exception.Message
        }
    )
}
