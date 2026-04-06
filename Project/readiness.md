# CloudLabs VM Automation Lab — Readiness Document

**Author:** Fardeen  
**Date:** April 2026  
**Template:** CloudLabs Windows VM Automation Lab  
**Subscription Type:** Shared  

---

## Table of Contents

1. [Objective](#objective)
2. [Architecture Overview](#architecture-overview)
3. [Final Working Flow](#final-working-flow)
4. [ARM Template — Final Version](#arm-template--final-version)
5. [run.ps1 — Final Version](#runps1--final-version)
6. [CloudLabs Configuration](#cloudlabs-configuration)
7. [Problems Faced & Resolutions](#problems-faced--resolutions)
8. [Key Learnings](#key-learnings)

---

## Objective

Deploy a fully functional Windows Virtual Machine on Azure via CloudLabs ODL (On Demand Labs) that:

- Provisions all required networking resources via ARM template
- Integrates with CloudLabs ODL platform
- Writes `C:\temp\credentials.txt` inside the VM containing TenantID, SPN AppID, SPN AppSecret
- Uses those credentials to authenticate via PowerShell as a Service Principal
- Creates a Storage Account, Blob Container, and uploads `hello.txt`

---

## Architecture Overview

```
CloudLabs ODL (Shared Subscription)
│
├── ARM Template Deployment
│   ├── Resource Group: rg-ProjectAutomation-{DeploymentID}
│   ├── VNet + Subnet
│   ├── NSG (RDP 3389 + HTTPS 443 allowed)
│   ├── Public IP (Standard SKU, Static)
│   ├── NIC
│   └── Windows VM (Server 2019 Datacenter)
│       └── Custom Script Extension (CSE)
│           ├── Writes C:\temp\credentials.txt  ← TenantID, AppID, AppSecret
│           ├── Downloads run.ps1 from GitHub
│           ├── Installs Az PowerShell module
│           └── Executes run.ps1
│
└── run.ps1 (runs inside VM)
    ├── Reads credentials.txt
    ├── Authenticates as SPN (Connect-AzAccount -ServicePrincipal)
    ├── Gets RG + Location from IMDS
    ├── Creates Storage Account
    ├── Creates Blob Container
    └── Uploads hello.txt
```

---

## Final Working Flow

```
Step 1: CloudLabs deploys ARM template
        → Replaces GET-SERVICEPRINCIPAL-APPLICATION-ID with real AppID
        → Replaces GET-SERVICEPRINCIPAL-SECRET with real AppSecret
        → subscription().tenantId resolves real Tenant ID

Step 2: CSE runs on VM boot
        → Creates C:\temp\
        → Writes credentials.txt with TenantID, AppID, AppSecret
        → Downloads run.ps1 from GitHub
        → Installs Az PowerShell module (~5-10 mins)
        → Executes run.ps1

Step 3: run.ps1 executes inside VM
        → Reads credentials.txt
        → SPN login — fully non-interactive, no WAM popup
        → IMDS fetch → gets ResourceGroup + Location
        → Creates Storage Account (labstorage + random suffix)
        → Creates Container (labcontainer)
        → Uploads hello.txt
        → Logs everything to C:\temp\run_log.txt
```

---

## ARM Template — Final Version

### Key Parameters

| Parameter | Default Value | Purpose |
|---|---|---|
| `CloudLabsDeploymentID` | `GET-DEPLOYMENT-ID` | CloudLabs injects unique deployment ID |
| `AppID` | `GET-SERVICEPRINCIPAL-APPLICATION-ID` | CloudLabs injects SPN App ID |
| `AppSecret` | `GET-SERVICEPRINCIPAL-SECRET` | CloudLabs injects SPN Secret |
| `adminUsername` | `labuser` | VM local admin username |
| `adminPassword` | `Password.1!!` | VM local admin password |
| `vmSize` | `Standard_D2s_v3` | VM size |

### Key Variables

```json
"vmName": "labvm",
"pipName": "[concat('labPIP-', parameters('CloudLabsDeploymentID'))]",
"pipDNSLabel": "[concat('labvm-', parameters('CloudLabsDeploymentID'))]"
```

### Public IP — Must Be Standard + Static

```json
"sku": { "name": "Standard" },
"properties": {
    "publicIPAllocationMethod": "Static",
    "dnsSettings": {
        "domainNameLabel": "[variables('pipDNSLabel')]"
    }
}
```

> ⚠️ **Critical:** RDP over HTTPS requires Standard SKU + Static allocation.  
> Basic + Dynamic = RDP over HTTPS will NOT work.

### CSE commandToExecute — Final Working Version

```json
"protectedSettings": {
    "commandToExecute": "[concat('powershell -ExecutionPolicy Unrestricted -Command \"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; New-Item -ItemType Directory -Path C:\\temp -Force | Out-Null; Set-Content -Path C:\\temp\\credentials.txt -Encoding UTF8 -Value @(''TenantID=', subscription().tenantId, ''',''AppID=', parameters('AppID'), ''',''AppSecret=', parameters('AppSecret'), '''); Invoke-WebRequest -Uri https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/Project/run.ps1 -OutFile C:\\temp\\run.ps1; Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers | Out-Null; Install-Module -Name Az -AllowClobber -Force -Scope AllUsers -Repository PSGallery | Out-Null; powershell -ExecutionPolicy Bypass -File C:\\temp\\run.ps1\"')]"
}
```

**What this does in order:**
1. Sets TLS 1.2 (required for PSGallery downloads)
2. Creates `C:\temp\` directory
3. Writes `credentials.txt` with real values from ARM functions + parameters
4. Downloads `run.ps1` from GitHub
5. Installs NuGet + Az module
6. Executes `run.ps1`

### Outputs

```json
"outputs": {
    "VMDNSName":       { "value": "[reference(pip).dnsSettings.fqdn]" },
    "VMAdminUsername": { "value": "[parameters('adminUsername')]" },
    "VMAdminPassword": { "value": "[parameters('adminPassword')]" },
    "VMName":          { "value": "[variables('vmName')]" },
    "TenantID":        { "value": "[subscription().tenantId]" }
}
```

---

## run.ps1 — Final Version

```powershell
Update-AzConfig -EnableLoginByWam $false -ErrorAction SilentlyContinue | Out-Null

$LogFile = 'C:\temp\run_log.txt'
function Write-Log {
    param([string]$Msg)
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Msg"
    Write-Output $line
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

Write-Log "===== run.ps1 started ====="

# Read credentials.txt
$creds = @{}
Get-Content 'C:\temp\credentials.txt' | ForEach-Object {
    if ($_ -match '^(.+?)=(.+)$') { $creds[$matches[1].Trim()] = $matches[2].Trim() }
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

# SPN Login
$spSecure = ConvertTo-SecureString $AppSecret -AsPlainText -Force
$spCred   = New-Object System.Management.Automation.PSCredential($AppID, $spSecure)
Connect-AzAccount -ServicePrincipal -Credential $spCred -TenantId $TenantID -ErrorAction Stop | Out-Null
Write-Log "SPN login OK. Sub: $((Get-AzContext).Subscription.Id)"

# IMDS - Get RG and Location
$metadata = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' -Headers @{Metadata='true'}
$rg       = $metadata.compute.resourceGroupName
$location = $metadata.compute.location
Write-Log "RG: $rg | Location: $location"

# Create Storage Account
$storageName = "labstorage" + (Get-Random -Minimum 10000 -Maximum 99999)
New-AzStorageAccount -ResourceGroupName $rg -Name $storageName -Location $location -SkuName Standard_LRS -Kind StorageV2 -ErrorAction Stop | Out-Null
Write-Log "Storage account created: $storageName"

# Create Container
$ctx = (Get-AzStorageAccount -ResourceGroupName $rg -Name $storageName).Context
New-AzStorageContainer -Name 'labcontainer' -Context $ctx -Permission Off -ErrorAction Stop | Out-Null
Write-Log "Container created: labcontainer"

# Upload hello.txt
if (-not (Test-Path 'C:\temp\hello.txt')) {
    Set-Content 'C:\temp\hello.txt' -Value "Hello from CloudLabs!" -Encoding UTF8
}
Set-AzStorageBlobContent -File 'C:\temp\hello.txt' -Container 'labcontainer' -Blob 'hello.txt' -Context $ctx -Force -ErrorAction Stop | Out-Null
Write-Log "hello.txt uploaded"

Write-Log "===== DONE: $storageName | labcontainer | hello.txt ====="
```

---

## CloudLabs Configuration

### Template Permissions

| # | Platform | User Type | Scope | Role |
|---|---|---|---|---|
| 22360 | Microsoft Azure | AADUser | `/subscriptions/{id}/resourceGroups/rg-ProjectAutomation` | Owner |
| 22361 | Microsoft Azure | AADServicePrincipal | `/subscriptions/{id}/resourceGroups/rg-ProjectAutomation` | Owner |

### VM Configuration (RDP over HTTPS)

| Field | Value |
|---|---|
| Name | `labvm` |
| Type | `RDP` |
| Server DNS Name | `VMDNSName` |
| Server Username | `VMAdminUsername` |
| Server Password | `VMAdminPassword` |
| Is Default VM | ✅ Checked |

> ⚠️ **Name field must be the actual VM name** (`labvm`), not an output key name.

### Deployment Script Configuration

| Field | Value |
|---|---|
| Type | PowerShellV2 |
| Run As | System |
| Run On | Deployment Success |
| Parameters | None — CloudLabs auto-injects all standard params |

---

## Problems Faced & Resolutions

---

### Problem 1 — ARM Template Validation Failed: `sqlServerName` not found

**Error:**
```
InvalidTemplate: The template parameter 'sqlServerName' is not found.
at outputs.serverDomainName (line 236)
```

**Root Cause:**  
The `outputs` section had a `serverDomainName` output referencing `parameters('sqlServerName')` and a SQL Server resource — neither of which existed in the template. Also `publicIpAddress` output was using `parameters('publicIpName')` instead of `variables('pipName')`.

**Resolution:**  
- Deleted `serverDomainName` output (no SQL server in this lab)
- Fixed `publicIpAddress` output to use `variables('pipName')`
- Added `serverDomainName` back pointing to VM's FQDN (same as `VMDNSName`) for CloudLabs environment page display

---

### Problem 2 — Deployment Script Failing with "One or more errors occurred" — No Logs

**Error:**
```
The script Deployment Script for cloudDID 2165710 failed with message: 
One or more errors occurred.
```

**What was tried:**
- Full `deploy.ps1` → FAILED
- Diagnostic script with `Write-Output` only → FAILED  
- Single line `Write-Output "hello"` → FAILED
- Both `Run As: System` and `Run As: AAD Service Principal` → FAILED

**Root Cause:**  
This was a **CloudLabs platform-level issue** — the Azure Function runner backend was failing before executing any script content. Even a single `Write-Output "hello"` produced no output and failed instantly.

**Resolution:**  
Abandoned the CloudLabs Deployment Script entirely. Moved all logic into the **Custom Script Extension (CSE)** inside the ARM template itself, which runs directly on the VM and is independent of the CloudLabs deployment script runner.

---

### Problem 3 — Wrong Tenant ID Being Fetched

**Problem:**  
Earlier approach was passing `{Tenant-Id}` CloudLabs token in the CSE command, but it was returning the **CloudLabs platform's own tenant ID** (`336...`) instead of the actual Azure lab tenant ID.

**Resolution:**  
Used ARM's built-in function `subscription().tenantId` directly in the `commandToExecute` via `concat()`:

```json
"commandToExecute": "[concat('...TenantID=', subscription().tenantId, '...')]"
```

This resolves at ARM deployment time and gives the **correct Azure subscription tenant ID**, not the CloudLabs platform tenant.

---

### Problem 4 — Interactive WAM Popup on `Connect-AzAccount`

**Problem:**  
When testing manually in the VM, `Connect-AzAccount -Credential` kept showing an interactive prompt:
```
WARNING: Starting September 1, 2025, MFA will be gradually enforced...
Select a tenant and subscription:
```

**Root Cause:**  
Windows Authentication Manager (WAM) was intercepting the login even when credentials were passed programmatically. `Update-AzConfig -EnableLoginByWam $false` in the same session didn't take effect immediately.

**Resolution:**  
Two things:
1. Added `Update-AzConfig -EnableLoginByWam $false` at the very top of `run.ps1` before any Az commands
2. Switched final approach to **SPN login** (`Connect-AzAccount -ServicePrincipal`) instead of AAD user login — SPN login is always fully non-interactive, no WAM involvement at all

---

### Problem 5 — SPN Creation Failing in Shared Subscription

**Problem:**  
`New-AzADApplication` and `New-AzADServicePrincipal` were failing silently when called from inside the VM or via CloudLabs deployment script.

**Root Cause:**  
The ODL user on a shared subscription has **Owner on the Resource Group** only — not Azure AD permissions. Creating App Registrations requires **Application Administrator** or **Cloud Application Administrator** role in Azure AD — which ODL users don't have.

**Resolution:**  
Instead of creating a new SPN at runtime, used the **pre-existing SPN that CloudLabs already provisions** for each ODL user. This SPN's credentials are injected via ARM parameter placeholders:

```json
"AppID":     { "value": "GET-SERVICEPRINCIPAL-APPLICATION-ID" },
"AppSecret": { "value": "GET-SERVICEPRINCIPAL-SECRET" }
```

CloudLabs replaces these at deployment time with real values.

---

### Problem 6 — Double Nested `protectedSettings` in CSE

**Problem:**  
ARM template validation error — CSE extension wasn't executing.

**Root Cause:**  
```json
"protectedSettings": {
    "protectedSettings": {       ← nested twice by mistake
        "commandToExecute": "..."
    }
}
```

**Resolution:**  
```json
"protectedSettings": {
    "commandToExecute": "..."    ← directly at first level
}
```

---

### Problem 7 — RDP over HTTPS Not Working

**Problem:**  
VM was deploying and showing in environment page but the browser-based RDP (over HTTPS) wasn't connecting.

**Root Causes Found:**
1. **VM Configuration `Name` field** was set to `VMName` (the output key) instead of `labvm` (actual VM name) — CloudLabs couldn't locate the VM
2. **Public IP was `Basic` SKU + `Dynamic`** — CloudLabs RDP over HTTPS requires `Standard` SKU + `Static`

**Resolution:**
- Set VM Configuration Name field to `labvm` (exact VM name from ARM variables)
- Changed Public IP to Standard SKU + Static allocation in ARM template

---

### Problem 8 — `run.ps1` Reading Wrong Keys from credentials.txt

**Problem:**  
`run.ps1` was crashing immediately after credentials.txt was written.

**Root Cause:**  
Old `run.ps1` logic was reading `AzureUserName` and `AzurePassword` from `credentials.txt` — keys that didn't exist in the new credentials file which only had `TenantID`, `AppID`, `AppSecret`.

**Resolution:**  
Rewrote `run.ps1` to only read and use `TenantID`, `AppID`, `AppSecret` — matching exactly what CSE writes into `credentials.txt`.

---

## Key Learnings

| # | Learning |
|---|---|
| 1 | **CloudLabs Deployment Script can fail silently at platform level** — always have a CSE fallback |
| 2 | **`subscription().tenantId` in ARM gives correct tenant** — CloudLabs `{Tenant-Id}` token gives CloudLabs platform tenant |
| 3 | **SPN login is always non-interactive** — prefer `-ServicePrincipal` over AAD user credentials to avoid WAM/MFA issues |
| 4 | **ODL users on shared subscriptions cannot create App Registrations** — use CloudLabs-provisioned SPN via `GET-SERVICEPRINCIPAL-*` placeholders |
| 5 | **RDP over HTTPS requires Standard SKU + Static Public IP** — Basic + Dynamic silently fails |
| 6 | **VM Configuration Name must be actual VM name** — not an output key reference |
| 7 | **CSE `protectedSettings` must be at first level** — double nesting breaks silently |
| 8 | **Az module install takes 5-10 minutes** — this naturally gives SPN propagation time, no `Start-Sleep` needed |
| 9 | **Always add logging to scripts** — `C:\temp\run_log.txt` saved hours of debugging |
| 10 | **IMDS endpoint `169.254.169.254`** is the most reliable way to get RG name and location from inside a VM |

---

## File Structure

```
Project/
├── azuredeploy.json          ← ARM template
├── azuredeploy.parameters.json ← Parameter file  
└── run.ps1                   ← PowerShell script (GitHub hosted, CSE downloads)
```

## Verification After Deployment

RDP into VM and check:

```powershell
# Verify credentials were written
Get-Content 'C:\temp\credentials.txt'

# Check run.ps1 execution log
Get-Content 'C:\temp\run_log.txt'

# Verify storage account exists
# Azure Portal → Resource Group → Storage Accounts → labstorage*****
# → Containers → labcontainer → hello.txt
```

