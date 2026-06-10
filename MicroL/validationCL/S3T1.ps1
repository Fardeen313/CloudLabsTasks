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
        $commands = @(

            'SCRIPT="/home/Labuser/scripts/system_report.sh"',
            'LOG_FILE="/tmp/system_report.log"',

            'if [ ! -f "$SCRIPT" ]; then',
            '    echo "Validation Failed: system_report.sh was not found."',
            '    exit 1',
            'fi',

            'if [ ! -x "$SCRIPT" ]; then',
            '    echo "Validation Failed: system_report.sh is not executable."',
            '    exit 1',
            'fi',

            '# Execute script',
            'bash "$SCRIPT" >/dev/null 2>&1',

            'sleep 2',

            'if [ ! -f "$LOG_FILE" ]; then',
            '    echo "Validation Failed: /tmp/system_report.log was not created."',
            '    exit 1',
            'fi',

            'if [ ! -s "$LOG_FILE" ]; then',
            '    echo "Validation Failed: /tmp/system_report.log is empty."',
            '    exit 1',
            'fi',

            'echo "Validation Passed: system_report.sh executed successfully and generated report output."',
            'exit 0'

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
                Message = "TASK-1 validation passed."
            } | ConvertTo-Json
 
        }
        else {
 
            $message = @{
                Status  = "Failed"
                Message = "TASK-1 validation failed."
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