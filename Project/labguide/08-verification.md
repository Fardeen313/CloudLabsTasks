# Exercise 8 — Verification

## Step 1 — Verify Inside the VM

RDP into the VM. Open PowerShell as Administrator and run:

```powershell
# Verify credentials.txt was written with real values
Get-Content 'C:\temp\credentials.txt'
# Expected:
# TenantID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# AppID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
# AppSecret=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Check run.ps1 execution log
Get-Content 'C:\temp\run_log.txt'
# Expected: timestamped entries ending with:
# ===== DONE: labstorage##### | labcontainer | hello.txt =====

# Check CSE status
Get-Content "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.*\Status\0.status"
```

---

## Step 2 — Verify in Azure Portal

1. Navigate to **Resource Groups** → `rg-ProjectAutomation-{DeploymentID}`
2. Find the Storage Account — look for `labstorage#####` (5-digit random suffix)
3. Go to **Storage Account** → **Containers** → `labcontainer` → confirm `hello.txt` exists

---

## Verification Checklist

| Item | Location | Status |
|---|---|---|
| credentials.txt | `C:\temp\credentials.txt` | Written by CSE |
| run_log.txt | `C:\temp\run_log.txt` | All steps logged |
| Storage Account | Resource Group | labstorage##### |
| Blob Container | Storage Account | labcontainer |
| Blob File | labcontainer | hello.txt |
