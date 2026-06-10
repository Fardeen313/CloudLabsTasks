$region = "us-east-1"
$deployment_id     = $deployment_id
 
Set-DefaultAWSRegion -Region $region
 
$stopRetry = $false
[int]$retryCount = 0
$maxRetries = 3
 
do {
    try {
 
        # Authentication check
        $identity = Get-STSCallerIdentity
        $identity.Arn | Out-Null
 
        # VM Name from deployment id
        $vmName = "lab-vm-$deployment_id"
 
        # Find instance
        $reservation = Get-EC2Instance `
            -Region $region `
            -Filter @(
                @{ Name = "tag:Name"; Values = @($vmName) },
                @{ Name = "instance-state-name"; Values = @("running") }
            )
 
        $instance = $reservation |
            Select-Object -ExpandProperty Instances |
            Select-Object -First 1
 
        if (-not $instance) {
            throw "Instance '$vmName' not found."
        }
 
        $instanceId = $instance.InstanceId
 
        # Validation script
        $Commands = @(
            'SCRIPT="/home/Labuser/scripts/parse_logs.sh"',

            '[ -f "$SCRIPT" ] || { echo FAIL; exit 1; }',

            '[ -x "$SCRIPT" ] || { echo FAIL; exit 1; }',

            'grep -q "/opt/logs/application.log" "$SCRIPT" || { echo FAIL; exit 1; }',

            'OUTPUT=$($SCRIPT 2>/dev/null)',

            'ERROR_LINES=$(echo "$OUTPUT" | grep -i "error" | wc -l)',

            'if [ "$ERROR_LINES" -lt 1 ]; then',
            'echo FAIL',
            'exit 1',
            'fi',

            'TOTAL_ERRORS=$(echo "$OUTPUT" | grep -oE "Total Errors:[[:space:]]*[0-9]+" | grep -oE "[0-9]+")',

            'if [ -z "$TOTAL_ERRORS" ]; then',
            'echo FAIL',
            'exit 1',
            'fi',

            'if [ "$TOTAL_ERRORS" -lt 3 ]; then',
            'echo FAIL',
            'exit 1',
            'fi',

            'echo PASS'
        )
 
        $response = Send-SSMCommand `
            -Region $region `
            -DocumentName "AWS-RunShellScript" `
            -InstanceId $instanceId `
            -Parameter @{
                commands = $commands
            }
 
        $commandId = $response.CommandId
 
        # Wait for completion
        do {
            Start-Sleep -Seconds 5
 
            $invocation = Get-SSMCommandInvocation `
                -Region $region `
                -CommandId $commandId `
                -InstanceId $instanceId
 
            $status = $invocation.Status.ToString()
 
        } while ($status -in @("Pending","InProgress","Delayed"))
 
        if ($status -eq "Success") {
 
            $message = @{
                Status  = "Succeeded"
                Message = "TASK-2 validation passed."
            } | ConvertTo-Json
 
        }
        else {
 
            $message = @{
                Status  = "Failed"
                Message = "TASK-2 validation failed."
            } | ConvertTo-Json
 
        }
 
        Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [System.Net.HttpStatusCode]::OK
            Body       = $message
        })
 
        $stopRetry = $true
    }
    catch {
 
        if ($retryCount -ge $maxRetries) {
 
            $message = @{
                Status  = "Failed"
                Message = "Retry exhausted: $($_.Exception.Message)"
            } | ConvertTo-Json
 
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [System.Net.HttpStatusCode]::OK
                Body       = $message
            })
 
            $stopRetry = $true
        }
        else {
 
            Start-Sleep -Seconds 60
            $retryCount++
        }
    }
 
} while ($stopRetry -eq $false)