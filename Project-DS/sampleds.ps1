$resourceGroupName = "ProjectAutomationDeployment-2172106"
$vmName = "labvm"

$script = @'
New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null

$creds = "TenantID=`nSubscriptionID=`nAppID=`nAppSecret="

Set-Content -Path "C:\temp\credentials.txt" -Value $creds -Force

& "C:\temp\run.ps1"
'@

Invoke-AzVMRunCommand `
  -ResourceGroupName $resourceGroupName `
  -VMName $vmName `
  -CommandId 'RunPowerShellScript' `
  -ScriptString $script