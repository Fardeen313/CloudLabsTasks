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
Connect-AzAccount -Credential $credential -TenantId $AzureTenantID -SubscriptionId $AzureSubscriptionID | Out-Null
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

`$creds = @{}
Get-Content 'C:\temp\credentials.txt' | ForEach-Object {
    if (`$_ -match '^(.+?)=(.+)$') { `$creds[`$matches[1].Trim()] = `$matches[2].Trim() }
}

`$spSecret = ConvertTo-SecureString `$creds['AppSecret'] -AsPlainText -Force
`$spCred = New-Object System.Management.Automation.PSCredential(`$creds['AppID'], `$spSecret)
Connect-AzAccount -ServicePrincipal -Credential `$spCred -TenantId `$creds['TenantID'] | Out-Null
Set-AzContext -SubscriptionId `$creds['SubscriptionID'] | Out-Null

`$metadata = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' -Headers @{Metadata='true'}
`$rg = `$metadata.compute.resourceGroupName
`$location = `$metadata.compute.location

`$storageName = ('labstorage$DeploymentID').ToLower()
New-AzStorageAccount -ResourceGroupName `$rg -Name `$storageName -Location `$location -SkuName Standard_LRS -Kind StorageV2 | Out-Null

`$ctx = (Get-AzStorageAccount -ResourceGroupName `$rg -Name `$storageName).Context
New-AzStorageContainer -Name 'labcontainer' -Context `$ctx -Permission Off | Out-Null

Set-AzStorageBlobContent -File 'C:\temp\hello.txt' -Container 'labcontainer' -Blob 'hello.txt' -Context `$ctx -Force | Out-Null
Write-Output 'Done'
"