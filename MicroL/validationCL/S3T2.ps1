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

            'if [ ! -f "$SCRIPT" ]; then',
            '    echo "Validation Failed: system_report.sh was not found."',
            '    exit 1',
            'fi',

            'CRON_ENTRIES=$(crontab -u Labuser -l 2>/dev/null)',

            'if [ -z "$CRON_ENTRIES" ]; then',
            '    echo "Validation Failed: No cron jobs found."',
            '    exit 1',
            'fi',

            'if ! echo "$CRON_ENTRIES" | grep -q "system_report.sh"; then',
            '    echo "Validation Failed: Cron job for system_report.sh was not found."',
            '    exit 1',
            'fi',

            'if ! echo "$CRON_ENTRIES" | grep -qE "^\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*[[:space:]]+\*"; then',
            '    echo "Validation Failed: Cron schedule is not configured for every 1 minute."',
            '    exit 1',
            'fi',

            'echo "Validation Passed: Cron job is configured to execute system_report.sh every 1 minutes."',
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