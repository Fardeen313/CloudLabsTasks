# ============================================================
# CloudLabs Deployment Script
# Runs on CloudLabs backend BEFORE CSE
# Writes credentials.txt into the VM at C:\temp\
# ============================================================

# CloudLabs injects these values automatically at runtime
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
    [string]$vmAdminPassword = "Password.1!!"
)

# ============================================================
# Authenticate to Azure using CloudLabs injected credentials
# ============================================================

$securePassword = ConvertTo-SecureString $AzurePassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($AzureUserName, $securePassword)

Connect-AzAccount `
    -Credential $credential `
    -TenantId $AzureTenantID `
    -SubscriptionId $AzureSubscriptionID | Out-Null

Set-AzContext -SubscriptionId $AzureSubscriptionID | Out-Null

Write-Output "Connected to Azure successfully."

# ============================================================
# Find the VM and Resource Group
# ============================================================

$vmName        = "labvm-$DeploymentID"
$resourceGroup = (Get-AzResourceGroup | Where-Object { $_.ResourceGroupName -like "*$DeploymentID*" }).ResourceGroupName

Write-Output "Target VM      : $vmName"
Write-Output "Resource Group : $resourceGroup"

# ============================================================
# Write credentials.txt into VM using Run Command
# ============================================================

$scriptContent = "
if (-not (Test-Path 'C:\temp')) { New-Item -ItemType Directory -Path 'C:\temp' -Force | Out-Null }
`$content = 'TenantID=$AzureTenantID' + [Environment]::NewLine +
            'SubscriptionID=$AzureSubscriptionID' + [Environment]::NewLine +
            'AppID=$AppID' + [Environment]::NewLine +
            'AppSecret=$AppSecret'
`$content | Out-File -FilePath 'C:\temp\credentials.txt' -Encoding UTF8 -Force
Write-Output 'credentials.txt written successfully at C:\temp\credentials.txt'
"

Invoke-AzVMRunCommand `
    -ResourceGroupName $resourceGroup `
    -VMName $vmName `
    -CommandId "RunPowerShellScript" `
    -ScriptString $scriptContent

Write-Output "Deployment script completed. credentials.txt is ready inside VM."
