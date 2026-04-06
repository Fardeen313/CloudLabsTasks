# Exercise 6 — Method 2: CloudLabs Deployment Script + run.ps1

> **Known Issue Encountered During This Lab:** The CloudLabs Deployment Script runner failed with "One or more errors occurred" even for a single-line `Write-Output "hello"`. This was a platform-level Azure Function runner issue. Method 1 (CSE) is strongly recommended.

---

## How This Method Works

### Step 1 — CSE (ARM Template) — Uploads run.ps1 Only

```json
"commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command \"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; New-Item -ItemType Directory -Path 'C:\\temp' -Force | Out-Null; 'Hello from CloudLabs' | Out-File 'C:\\temp\\hello.txt'; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/Project/run.ps1' -OutFile 'C:\\temp\\run.ps1'; Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers | Out-Null; Install-Module -Name Az -AllowClobber -Force -Scope AllUsers -Repository PSGallery | Out-Null\""
```

### Step 2 — CloudLabs Deployment Script — deploy.ps1

[View deploy.ps1 on GitHub](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/refs/heads/main/Project/deploy.ps1)

```powershell
param(
    [string]$AzureUserName,
    [string]$AzurePassword,
    [string]$AzureTenantID,
    [string]$AzureSubscriptionID,
    [string]$AppID,
    [string]$AppSecret,
    [string]$DeploymentID,
    [string]$InstallCloudLabsShadow
)

$securePassword = ConvertTo-SecureString $AzurePassword -AsPlainText -Force
$credential     = New-Object System.Management.Automation.PSCredential($AzureUserName, $securePassword)
Connect-AzAccount -Credential $credential -ErrorAction Stop | Out-Null

$AzureTenantID       = (Get-AzContext).Tenant.Id
$AzureSubscriptionID = (Get-AzContext).Subscription.Id

$resourceGroup = (Get-AzResourceGroup | Where-Object {
    $_.ResourceGroupName -like "*$DeploymentID*"
}).ResourceGroupName

$vmName = (Get-AzVM -ResourceGroupName $resourceGroup | Select-Object -First 1).Name

$inlineScript = @"
New-Item -ItemType Directory -Path 'C:\temp' -Force | Out-Null
Set-Content 'C:\temp\credentials.txt' -Encoding UTF8 -Value @(
    'TenantID=$AzureTenantID',
    'SubscriptionID=$AzureSubscriptionID',
    'AppID=$AppID',
    'AppSecret=$AppSecret'
)
& powershell.exe -ExecutionPolicy Bypass -File 'C:\temp\run.ps1'
"@

Invoke-AzVMRunCommand -ResourceGroupName $resourceGroup -VMName $vmName `
    -CommandId "RunPowerShellScript" -ScriptString $inlineScript -ErrorAction Stop
```

### Step 3 — CloudLabs Deployment Script Configuration

| Field | Value | Notes |
|---|---|---|
| Type | PowerShellV2 | Must be V2 |
| Run As | System | Not AAD Service Principal |
| Run On | Deployment Success | After ARM completes |
| Parameters | None | CloudLabs auto-injects all standard params |
