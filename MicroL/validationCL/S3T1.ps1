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
    'SCRIPT="/home/Labuser/scripts/system_report.sh"',
    'LOG_FILE="/tmp/system_report.log"',

    'if [ ! -f "$SCRIPT" ]; then',
    '    echo FAIL',
    '    exit 1',
    'fi',

    'if [ ! -x "$SCRIPT" ]; then',
    '    echo FAIL',
    '    exit 1',
    'fi',

    'bash "$SCRIPT" >/dev/null 2>&1',

    'sleep 2',

    'if [ ! -f "$LOG_FILE" ]; then',
    '    echo FAIL',
    '    exit 1',
    'fi',

    'if [ ! -s "$LOG_FILE" ]; then',
    '    echo FAIL',
    '    exit 1',
    'fi',

    'echo PASS',
    'exit 0'
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
