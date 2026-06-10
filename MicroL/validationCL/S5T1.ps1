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

            'SCRIPT="/home/Labuser/scripts/file_check.sh"',

            '# Check if script exists',
            'if [ ! -f "$SCRIPT" ]; then',
            '    echo "Validation Failed: file_check.sh was not found."',
            '    exit 1',
            'fi',

            '# Check for success exit code',
            'if ! grep -q "exit 0" "$SCRIPT"; then',
            '    echo "Validation Failed: Success exit code (exit 0) was not found."',
            '    exit 1',
            'fi',

            '# Check for failure exit code',
            'if ! grep -q "exit 1" "$SCRIPT"; then',
            '    echo "Validation Failed: Failure exit code (exit 1) was not found."',
            '    exit 1',
            'fi',

            '# Check if script references the required file',
            'if ! grep -q "/opt/data/testfile.txt" "$SCRIPT"; then',
            '    echo "Validation Failed: Script does not reference /opt/data/testfile.txt."',
            '    exit 1',
            'fi',

            '# Execute script and verify success exit code',
            'bash "$SCRIPT" >/dev/null 2>&1',

            'if [ $? -ne 0 ]; then',
            '    echo "Validation Failed: Script did not return exit code 0 when the file exists."',
            '    exit 1',
            'fi',

            'echo "Validation Passed: Exit codes are implemented correctly."',
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