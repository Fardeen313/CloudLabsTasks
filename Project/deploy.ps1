$ cat deploy.ps1 
param(
    [string]$AzureUserName,
    [string]$AzurePassword,
    [string]$AzureTenantID,
    [string]$AzureSubscriptionID,
    [string]$AppID,
    [string]$AppSecret,
    [string]$DeploymentID,
    [string]$InstallCloudLabsShadow,
    [string]$vmAdminUsername = "labuser",
    [string]$vmAdminPassword = "Password123456789"
)

$securePassword = ConvertTo-SecureString $AzurePassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($AzureUserName, $securePassword)
Connect-AzAccount -Credential $credential | Out-Null
Set-AzContext -SubscriptionId $AzureSubscriptionID | Out-Null

$AzureTenantID = (Get-AzContext).Tenant.Id
$AzureSubscriptionID = (Get-AzContext).Subscription.Id

$resourceGroup = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like "*$DeploymentID*" }).ResourceGroupName
$vmName = "labvm-$DeploymentID"

$sp = New-AzADApplication -DisplayName "LabSPN-$DeploymentID"
New-AzADServicePrincipal -ApplicationId $sp.AppId | Out-Null
$spSecret = New-AzADAppCredential -ApplicationId $sp.AppId
$NewSPNAppID = $sp.AppId
$NewSPNSecret = $spSecret.SecretText

New-AzRoleAssignment -ApplicationId $NewSPNAppID -RoleDefinitionName "Owner" -ResourceGroupName $resourceGroup | Out-Null

Start-Sleep -Seconds 30

Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -VMName $vmName -CommandId "RunPowerShellScript" -ScriptString "
Set-Content 'C:\temp\credentials.txt' -Encoding UTF8 -Value @(
    'TenantID=$AzureTenantID',
    'SubscriptionID=$AzureSubscriptionID',
    'AppID=$NewSPNAppID',
    'AppSecret=$NewSPNSecret'
)
& 'C:\temp\run.ps1'
"
