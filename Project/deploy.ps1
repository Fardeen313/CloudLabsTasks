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

$spSecret = ConvertTo-SecureString $AppSecret -AsPlainText -Force
$spCred = New-Object System.Management.Automation.PSCredential($AppID, $spSecret)
Connect-AzAccount -ServicePrincipal -Credential $spCred -TenantId $AzureTenantID | Out-Null
Set-AzContext -SubscriptionId $AzureSubscriptionID | Out-Null

$vmName = "labvm-$DeploymentID"
$resourceGroup = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like "*$DeploymentID*" }).ResourceGroupName

Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -VMName $vmName -CommandId "RunPowerShellScript" -ScriptString "
Set-Content 'C:\temp\credentials.txt' -Encoding UTF8 -Value @(
    'TenantID=$AzureTenantID',
    'SubscriptionID=$AzureSubscriptionID',
    'AppID=$AppID',
    'AppSecret=$AppSecret'
)
& 'C:\temp\run.ps1'
"