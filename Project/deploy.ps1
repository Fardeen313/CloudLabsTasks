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

Connect-AzAccount `
    -Credential $credential `
    -TenantId $AzureTenantID `
    -SubscriptionId $AzureSubscriptionID | Out-Null

Set-AzContext -SubscriptionId $AzureSubscriptionID | Out-Null

$vmName = "labvm-$DeploymentID"
$resourceGroup = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like "*$DeploymentID*" }).ResourceGroupName

$scriptContent = "
if (-not (Test-Path 'C:\temp')) { New-Item -ItemType Directory -Path 'C:\temp' -Force | Out-Null }
`$content = 'TenantID=$AzureTenantID' + [Environment]::NewLine +
            'SubscriptionID=$AzureSubscriptionID' + [Environment]::NewLine +
            'AppID=$AppID' + [Environment]::NewLine +
            'AppSecret=$AppSecret'
`$content | Out-File -FilePath 'C:\temp\credentials.txt' -Encoding UTF8 -Force
'Hello from CloudLabs' | Out-File -FilePath 'C:\temp\hello.txt' -Encoding UTF8 -Force
"

Invoke-AzVMRunCommand `
    -ResourceGroupName $resourceGroup `
    -VMName $vmName `
    -CommandId "RunPowerShellScript" `
    -ScriptString $scriptContent

$spSecret = ConvertTo-SecureString $AppSecret -AsPlainText -Force
$spCredential = New-Object System.Management.Automation.PSCredential($AppID, $spSecret)

Connect-AzAccount `
    -ServicePrincipal `
    -Credential $spCredential `
    -TenantId $AzureTenantID | Out-Null

Set-AzContext -SubscriptionId $AzureSubscriptionID | Out-Null

$location = (Get-AzResourceGroup -Name $resourceGroup).Location
$storageName = ("labstorage" + $DeploymentID).ToLower()

New-AzStorageAccount `
    -ResourceGroupName $resourceGroup `
    -Name $storageName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2

$storage = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageName
$ctx = $storage.Context

New-AzStorageContainer -Name "labcontainer" -Context $ctx -Permission Off

$tempFile = "$env:TEMP\hello.txt"
"Hello from CloudLabs Blob" | Out-File $tempFile -Encoding UTF8

Set-AzStorageBlobContent `
    -File $tempFile `
    -Container "labcontainer" `
    -Blob "hello.txt" `
    -Context $ctx

Write-Output "Storage account created and hello.txt uploaded to blob."









# # ============================================================
# # CloudLabs Deployment Script
# # Runs on CloudLabs backend BEFORE CSE
# # Writes credentials.txt into the VM at C:\temp\
# # ============================================================

# # CloudLabs injects these values automatically at runtime
# param(
#     [string]$AzureUserName,
#     [string]$AzurePassword,
#     [string]$AzureTenantID,
#     [string]$AzureSubscriptionID,
#     [string]$AppID,
#     [string]$AppSecret,
#     [string]$DeploymentID,
#     [string]$InstallCloudLabsShadow,
#     [string]$vmAdminUsername = "labuser",
#     [string]$vmAdminPassword = "Password.1!!"
# )

# # ============================================================
# # Authenticate to Azure using CloudLabs injected credentials
# # ============================================================

# $securePassword = ConvertTo-SecureString $AzurePassword -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential($AzureUserName, $securePassword)

# Connect-AzAccount `
#     -Credential $credential `
#     -TenantId $AzureTenantID `
#     -SubscriptionId $AzureSubscriptionID | Out-Null

# Set-AzContext -SubscriptionId $AzureSubscriptionID | Out-Null

# Write-Output "Connected to Azure successfully."

# # ============================================================
# # Find the VM and Resource Group
# # ============================================================

# $vmName        = "labvm-$DeploymentID"
# $resourceGroup = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like "*$DeploymentID*" }).ResourceGroupName

# Write-Output "Target VM      : $vmName"
# Write-Output "Resource Group : $resourceGroup"

# # ============================================================
# # Write credentials.txt into VM using Run Command
# # ============================================================

# $scriptContent = "
# if (-not (Test-Path 'C:\temp')) { New-Item -ItemType Directory -Path 'C:\temp' -Force | Out-Null }
# `$content = 'TenantID=$AzureTenantID' + [Environment]::NewLine +
#             'SubscriptionID=$AzureSubscriptionID' + [Environment]::NewLine +
#             'AppID=$AppID' + [Environment]::NewLine +
#             'AppSecret=$AppSecret'
# `$content | Out-File -FilePath 'C:\temp\credentials.txt' -Encoding UTF8 -Force
# Write-Output 'credentials.txt written successfully at C:\temp\credentials.txt'
# "

# Invoke-AzVMRunCommand `
#     -ResourceGroupName $resourceGroup `
#     -VMName $vmName `
#     -CommandId "RunPowerShellScript" `
#     -ScriptString $scriptContent

# Write-Output "Deployment script completed. credentials.txt is ready inside VM."
