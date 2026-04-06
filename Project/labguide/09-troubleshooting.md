# Exercise 9 — Troubleshooting Guide

## Issue 1 — Deployment Script: "One or more errors occurred" (No Logs)

Even `Write-Output "hello"` failed with no output. Tested with full deploy.ps1, diagnostic scripts, and single-line echo — all failed identically.

| Root Cause | Resolution |
|---|---|
| CloudLabs Azure Function runner platform-level failure | Moved all logic to CSE inside ARM template (Method 1). No deployment script needed. |

---

## Issue 2 — Wrong Tenant ID from CloudLabs Token

`{Tenant-Id}` token returns CloudLabs platform tenant (~336...), not your Azure tenant.

```json
// Wrong — CloudLabs token returns wrong tenant
"TenantID={Tenant-Id}"

// Correct — ARM built-in resolves at deploy time
"[concat('TenantID=', subscription().tenantId)]"
```

---

## Issue 3 — WAM Interactive Popup

Windows Authentication Manager intercepted `Connect-AzAccount -Credential` even with credentials passed.

```powershell
# Fix 1: Disable WAM at top of script
Update-AzConfig -EnableLoginByWam $false -ErrorAction SilentlyContinue | Out-Null

# Fix 2: Use SPN login instead — always non-interactive
Connect-AzAccount -ServicePrincipal -Credential $spCred -TenantId $TenantID
```

---

## Issue 4 — RDP over HTTPS Not Working

| Root Cause | Fix |
|---|---|
| VM Configuration Name set to `VMName` (output key) instead of `labvm` | Enter `labvm` — exact value from ARM `variables('vmName')` |
| Public IP was Basic SKU + Dynamic | Change to Standard SKU + Static |

---

## Issue 5 — SPN Creation Failed

`New-AzADApplication` fails on shared subscriptions. ODL users have Owner on Resource Group only — not Azure AD permissions needed to create App Registrations.

**Resolution:** Use CloudLabs-provisioned SPN via ARM parameter tokens `GET-SERVICEPRINCIPAL-APPLICATION-ID` and `GET-SERVICEPRINCIPAL-SECRET`. Never create a new SPN from scripts.

---

## Key Learnings Summary

| # | Learning |
|---|---|
| 1 | Use `subscription().tenantId` in ARM — not `{Tenant-Id}` CloudLabs token |
| 2 | SPN login is always non-interactive — prefer over AAD user login inside VM |
| 3 | ODL users on shared subscriptions CANNOT create App Registrations |
| 4 | RDP over HTTPS requires Standard SKU + Static Public IP |
| 5 | VM Configuration Name = actual VM name, not output key name |
| 6 | CSE `commandToExecute` must be directly in `protectedSettings` — no double nesting |
| 7 | Az module install (~5-10 min) naturally provides SPN propagation time — no sleep needed |
| 8 | IMDS `169.254.169.254` is most reliable way to get RG + location inside VM |
| 9 | Always log to `C:\temp\run_log.txt` — saves hours of debugging |
