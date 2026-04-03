Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

$credFilePath = "C:\temp\credentials.txt"
$maxWait      = 600
$waited       = 0

Write-Output "Waiting for credentials.txt from deployment script..."

while (-not (Test-Path $credFilePath) -and $waited -lt $maxWait) {
    Write-Output "Waiting... ($waited seconds elapsed)"
    Start-Sleep -Seconds 30
    $waited += 30
}

if (-not (Test-Path $credFilePath)) {
    Write-Error "credentials.txt not found after $maxWait seconds. Exiting."
    exit 1
}

Write-Output "credentials.txt found. Reading values..."

$creds = @{}
Get-Content $credFilePath | ForEach-Object {
    if ($_ -match "^(.+?)=(.+)$") {
        $creds[$matches[1].Trim()] = $matches[2].Trim()
    }
}

$TenantID       = $creds["TenantID"]
$SubscriptionID = $creds["SubscriptionID"]
$AppID          = $creds["AppID"]
$AppSecret      = $creds["AppSecret"]

Write-Output "TenantID       : $TenantID"
Write-Output "SubscriptionID : $SubscriptionID"
Write-Output "AppID          : $AppID"

if (-not $TenantID -or -not $SubscriptionID -or -not $AppID -or -not $AppSecret) {
    Write-Error "One or more credentials are missing in credentials.txt. Exiting."
    exit 1
}

Write-Output "Installing Az module if not present..."

if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers | Out-Null
    Install-Module -Name Az -AllowClobber -Force -Scope AllUsers -Repository PSGallery | Out-Null
    Write-Output "Az module installed."
} else {
    Write-Output "Az module already present."
}

Import-Module Az.Accounts -Force
Import-Module Az.Storage  -Force

Write-Output "Authenticating via Service Principal..."

$SecureAppSecret = ConvertTo-SecureString $AppSecret -AsPlainText -Force
$SPNCredential   = New-Object System.Management.Automation.PSCredential($AppID, $SecureAppSecret)

Connect-AzAccount `
    -ServicePrincipal `
    -Tenant $TenantID `
    -Credential $SPNCredential | Out-Null

Set-AzContext -SubscriptionId $SubscriptionID | Out-Null

Write-Output "Authentication successful."

Write-Output "Fetching VM metadata..."

try {
    $metadata      = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01" -Headers @{Metadata = "true"} -Method GET
    $location      = $metadata.compute.location
    $resourceGroup = $metadata.compute.resourceGroupName
} catch {
    Write-Output "Metadata fetch failed. Using defaults."
    $location      = "eastus"
    $resourceGroup = (Get-AzResourceGroup | Select-Object -First 1).ResourceGroupName
}

Write-Output "Location       : $location"
Write-Output "Resource Group : $resourceGroup"

Write-Output "Creating Storage Account..."

$randomSuffix       = -join ((48..57) + (97..122) | Get-Random -Count 6 | ForEach-Object { [char]$_ })
$storageAccountName = "labstorage$randomSuffix"

New-AzStorageAccount `
    -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -Location $location `
    -SkuName "Standard_LRS" `
    -Kind "StorageV2" | Out-Null

Write-Output "Storage Account created: $storageAccountName"

Write-Output "Creating Blob Container..."

$containerName  = "labcontainer"
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
$ctx            = $storageAccount.Context

New-AzStorageContainer `
    -Name $containerName `
    -Context $ctx `
    -Permission Off | Out-Null

Write-Output "Blob Container created: $containerName"

Write-Output "Creating and uploading hello.txt..."

$helloPath    = "C:\temp\hello.txt"
$helloContent = @"
Hello from CloudLabs Lab!
--------------------------
Uploaded By  : $AppID
Tenant ID    : $TenantID
Subscription : $SubscriptionID
Timestamp    : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

$helloContent | Out-File -FilePath $helloPath -Encoding UTF8 -Force

Set-AzStorageBlobContent `
    -File $helloPath `
    -Container $containerName `
    -Blob "hello.txt" `
    -Context $ctx `
    -Force | Out-Null

Write-Output "hello.txt uploaded successfully."

Write-Output ""
Write-Output "============================================"
Write-Output " CSE Completed Successfully!"
Write-Output "============================================"
Write-Output " Storage Account : $storageAccountName"
Write-Output " Container       : $containerName"
Write-Output " Blob            : hello.txt"
Write-Output " Resource Group  : $resourceGroup"
Write-Output " Location        : $location"
Write-Output "============================================"





# # ============================================================
# # deploy.ps1 - Custom Script Extension
# # Runs INSIDE the VM
# # 1. Reads credentials from C:\temp\credentials.txt
# # 2. Authenticates to Azure via SPN
# # 3. Creates Storage Account
# # 4. Creates Blob Container
# # 5. Uploads hello.txt
# # ============================================================

# param(
#     [string]$TenantID,
#     [string]$SubscriptionID,
#     [string]$AppID,
#     [string]$AppSecret
# )

# # ============================================================
# # Step 1 - Write credentials.txt from parameters
# # (CSE receives these from ARM template protectedSettings)
# # ============================================================

# Write-Output "Creating C:\temp directory..."
# if (-not (Test-Path "C:\temp")) {
#     New-Item -ItemType Directory -Path "C:\temp" -Force | Out-Null
# }

# Write-Output "Writing credentials.txt..."
# $credContent = "TenantID=$TenantID`nSubscriptionID=$SubscriptionID`nAppID=$AppID`nAppSecret=$AppSecret"
# $credContent | Out-File -FilePath "C:\temp\credentials.txt" -Encoding UTF8 -Force

# Write-Output "credentials.txt written at C:\temp\credentials.txt"

# # ============================================================
# # Step 2 - Read credentials back from file
# # (simulates what would happen if deployment script wrote it)
# # ============================================================

# Write-Output "Reading credentials from C:\temp\credentials.txt..."

# $creds = @{}
# Get-Content "C:\temp\credentials.txt" | ForEach-Object {
#     if ($_ -match "^(.+)=(.+)$") {
#         $creds[$matches[1].Trim()] = $matches[2].Trim()
#     }
# }

# $TenantID       = $creds["TenantID"]
# $SubscriptionID = $creds["SubscriptionID"]
# $AppID          = $creds["AppID"]
# $AppSecret      = $creds["AppSecret"]

# Write-Output "Credentials loaded:"
# Write-Output "  TenantID       : $TenantID"
# Write-Output "  SubscriptionID : $SubscriptionID"
# Write-Output "  AppID          : $AppID"

# # ============================================================
# # Step 3 - Install Az PowerShell Module
# # ============================================================

# Write-Output "Setting up PowerShell execution policy..."
# Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Write-Output "Checking Az module..."
# if (-not (Get-Module -ListAvailable -Name Az.Accounts)) {
#     Write-Output "Installing Az module (this may take a few minutes)..."
#     Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers | Out-Null
#     Install-Module -Name Az -AllowClobber -Force -Scope AllUsers -Repository PSGallery | Out-Null
#     Write-Output "Az module installed."
# } else {
#     Write-Output "Az module already present."
# }

# Import-Module Az.Accounts -Force
# Import-Module Az.Storage  -Force

# # ============================================================
# # Step 4 - Authenticate via Service Principal
# # ============================================================

# Write-Output "Authenticating to Azure via Service Principal..."

# $SecureAppSecret = ConvertTo-SecureString $AppSecret -AsPlainText -Force
# $SPNCredential   = New-Object System.Management.Automation.PSCredential($AppID, $SecureAppSecret)

# Connect-AzAccount `
#     -ServicePrincipal `
#     -Tenant $TenantID `
#     -Credential $SPNCredential | Out-Null

# Set-AzContext -SubscriptionId $SubscriptionID | Out-Null

# Write-Output "Authentication successful."

# # ============================================================
# # Step 5 - Get Resource Group and Location from metadata
# # ============================================================

# Write-Output "Fetching VM metadata..."

# try {
#     $metadata      = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01" -Headers @{Metadata = "true"} -Method GET
#     $location      = $metadata.compute.location
#     $resourceGroup = $metadata.compute.resourceGroupName
# } catch {
#     Write-Output "Metadata fetch failed. Using defaults."
#     $location      = "eastus"
#     $resourceGroup = (Get-AzResourceGroup | Select-Object -First 1).ResourceGroupName
# }

# Write-Output "Location       : $location"
# Write-Output "Resource Group : $resourceGroup"

# # ============================================================
# # Step 6 - Create Storage Account
# # ============================================================

# Write-Output "Creating Storage Account..."

# $storageAccountName = "labstorage" + (Get-Random -Minimum 10000 -Maximum 99999)

# New-AzStorageAccount `
#     -ResourceGroupName $resourceGroup `
#     -Name $storageAccountName `
#     -Location $location `
#     -SkuName "Standard_LRS" `
#     -Kind "StorageV2" | Out-Null

# Write-Output "Storage Account created: $storageAccountName"

# # ============================================================
# # Step 7 - Create Blob Container
# # ============================================================

# Write-Output "Creating Blob Container..."

# $containerName  = "labcontainer"
# $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
# $ctx            = $storageAccount.Context

# New-AzStorageContainer `
#     -Name $containerName `
#     -Context $ctx `
#     -Permission Off | Out-Null

# Write-Output "Blob Container created: $containerName"

# # ============================================================
# # Step 8 - Create and Upload hello.txt
# # ============================================================

# Write-Output "Creating hello.txt..."

# $helloPath    = "C:\temp\hello.txt"
# $helloContent = @"
# Hello from CloudLabs Lab!
# --------------------------
# Uploaded By  : $AppID
# Tenant ID    : $TenantID
# Subscription : $SubscriptionID
# Timestamp    : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
# "@

# $helloContent | Out-File -FilePath $helloPath -Encoding UTF8 -Force

# Write-Output "Uploading hello.txt to container..."

# Set-AzStorageBlobContent `
#     -File $helloPath `
#     -Container $containerName `
#     -Blob "hello.txt" `
#     -Context $ctx `
#     -Force | Out-Null

# Write-Output "hello.txt uploaded successfully."

# # ============================================================
# # Summary
# # ============================================================

# Write-Output ""
# Write-Output "============================================"
# Write-Output " Deployment Completed Successfully!"
# Write-Output "============================================"
# Write-Output " Storage Account : $storageAccountName"
# Write-Output " Container       : $containerName"
# Write-Output " Blob            : hello.txt"
# Write-Output " Resource Group  : $resourceGroup"
# Write-Output " Location        : $location"
# Write-Output " credentials.txt : C:\temp\credentials.txt"
# Write-Output "============================================"
