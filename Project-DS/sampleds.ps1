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





$resourceGroupName = "GET-RG-customsuffix-NAME"
$vmName = "labvm"

$tenantId = "tenant-id-placeholder"

$script = @"
New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null

`$creds = "TenantID=$tenantId`nSubscriptionID=GET-SUBSCRIPTION`nAppID=GET-SERVICEPRINCIPAL-APPLICATION-ID`nAppSecret=GET-SERVICEPRINCIPAL-SECRET"

Set-Content -Path "C:\temp\credentials.txt" -Value `$creds -Force

& "C:\temp\run.ps1"
"@

Invoke-AzVMRunCommand `
  -ResourceGroupName $resourceGroupName `
  -VMName $vmName `
  -CommandId 'RunPowerShellScript' `
  -ScriptString $script