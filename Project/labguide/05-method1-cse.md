# Exercise 5 — Method 1: CSE + run.ps1 (Recommended)

> **Verified Working End-to-End.** This approach was tested and confirmed working. CSE runs directly on the VM at boot, credentials are injected via ARM parameters, and SPN login is fully non-interactive.

---

## Step 1 — CSE in ARM Template

Add this to your ARM template CSE extension. It writes `credentials.txt`, downloads `run.ps1` from GitHub, installs Az module, then executes the script.

> **Never double-nest protectedSettings.** `commandToExecute` must be directly inside `protectedSettings` — not inside another nested object.

```json
{
  "name": "[concat(variables('vmName'), '/CustomScriptExtension')]",
  "type": "Microsoft.Compute/virtualMachines/extensions",
  "apiVersion": "2021-03-01",
  "location": "[variables('location')]",
  "dependsOn": [
    "[resourceId('Microsoft.Compute/virtualMachines', variables('vmName'))]"
  ],
  "properties": {
    "publisher": "Microsoft.Compute",
    "type": "CustomScriptExtension",
    "typeHandlerVersion": "1.10",
    "autoUpgradeMinorVersion": true,
    "settings": {},
    "protectedSettings": {
      "commandToExecute": "[concat('powershell -ExecutionPolicy Unrestricted -Command \"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; New-Item -ItemType Directory -Path C:\\temp -Force | Out-Null; Set-Content -Path C:\\temp\\credentials.txt -Encoding UTF8 -Value @(''TenantID=', subscription().tenantId, ''',''AppID=', parameters('AppID'), ''',''AppSecret=', parameters('AppSecret'), '''); Invoke-WebRequest -Uri https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/Project/run.ps1 -OutFile C:\\temp\\run.ps1; Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers | Out-Null; Install-Module -Name Az -AllowClobber -Force -Scope AllUsers -Repository PSGallery | Out-Null; powershell -ExecutionPolicy Bypass -File C:\\temp\\run.ps1\"')]"
    }
  }
}
```

---

## Step 2 — run.ps1 (hosted on GitHub)

[View run.ps1 on GitHub](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/Project/run.ps1)

```powershell
# Disable WAM interactive popup — must be first
Update-AzConfig -EnableLoginByWam $false -ErrorAction SilentlyContinue | Out-Null

$LogFile = 'C:\temp\run_log.txt'
function Write-Log {
    param([string]$Msg)
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Msg"
    Write-Output $line
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

Write-Log "===== run.ps1 started ====="

$creds = @{}
Get-Content 'C:\temp\credentials.txt' | ForEach-Object {
    if ($_ -match '^(.+?)=(.+)$') {
        $creds[$matches[1].Trim()] = $matches[2].Trim()
    }
}

$TenantID  = $creds['TenantID']
$AppID     = $creds['AppID']
$AppSecret = $creds['AppSecret']

Write-Log "TenantID : $TenantID"
Write-Log "AppID    : $AppID"

if (-not $TenantID -or -not $AppID -or -not $AppSecret) {
    Write-Log "ERROR: Missing values in credentials.txt"
    exit 1
}

$spSecure = ConvertTo-SecureString $AppSecret -AsPlainText -Force
$spCred   = New-Object System.Management.Automation.PSCredential($AppID, $spSecure)
Connect-AzAccount -ServicePrincipal -Credential $spCred -TenantId $TenantID -ErrorAction Stop | Out-Null
Write-Log "SPN login OK. Sub: $((Get-AzContext).Subscription.Id)"

$metadata = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' -Headers @{Metadata='true'}
$rg       = $metadata.compute.resourceGroupName
$location = $metadata.compute.location
Write-Log "RG: $rg | Location: $location"

$storageName = "labstorage" + (Get-Random -Minimum 10000 -Maximum 99999)
New-AzStorageAccount -ResourceGroupName $rg -Name $storageName -Location $location -SkuName Standard_LRS -Kind StorageV2 -ErrorAction Stop | Out-Null
Write-Log "Storage account created: $storageName"

$ctx = (Get-AzStorageAccount -ResourceGroupName $rg -Name $storageName).Context
New-AzStorageContainer -Name 'labcontainer' -Context $ctx -Permission Off -ErrorAction Stop | Out-Null
Write-Log "Container created: labcontainer"

if (-not (Test-Path 'C:\temp\hello.txt')) {
    Set-Content 'C:\temp\hello.txt' -Value "Hello from CloudLabs!" -Encoding UTF8
}
Set-AzStorageBlobContent -File 'C:\temp\hello.txt' -Container 'labcontainer' -Blob 'hello.txt' -Context $ctx -Force -ErrorAction Stop | Out-Null
Write-Log "hello.txt uploaded"

Write-Log "===== DONE: $storageName | labcontainer | hello.txt ====="
```
