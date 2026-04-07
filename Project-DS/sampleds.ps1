param()

$resourceGroupName = "ProjectAutomationDeployment-2170319"
$vmName = "labvm"

$script = @'
$filePath = "C:\temp\credentials.txt"

if (!(Test-Path "C:\temp")) {
    New-Item -ItemType Directory -Path "C:\temp"
}

$content = @"
TenantID=hardcodedvalue
SubscriptionID=subId
AppID=AppId
AppSecret=secret
"@

Set-Content -Path $filePath -Value $content -Force

Write-Output "credentials.txt updated successfully"

Write-Output "Starting run.ps1..."
powershell.exe -ExecutionPolicy Bypass -File "C:\temp\run.ps1"
Write-Output "run.ps1 execution completed"
'@

Invoke-AzVMRunCommand `
    -ResourceGroupName $resourceGroupName `
    -VMName $vmName `
    -CommandId 'RunPowerShellScript' `
    -ScriptString $script

Write-Output "Command executed on VM"