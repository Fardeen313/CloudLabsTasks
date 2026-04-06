# Exercise 7 — CloudLabs VM Configuration

## VM Configuration — Edit VM Configuration Panel

| Field | Value to Enter |
|---|---|
| Platform Friendly Name | Microsoft Azure |
| Name | `labvm` ← Actual VM name from ARM variables |
| Type | RDP |
| Server DNS Name | `VMDNSName` |
| Server Username | `VMAdminUsername` |
| Server Password | `VMAdminPassword` |
| Is Default VM | ✅ Check this |

> **Name field = actual VM name, NOT output key.** Enter `labvm` (the exact string from `variables('vmName')` in ARM). If you enter `VMName`, CloudLabs cannot locate the VM for RDP proxy setup and browser RDP will not work.
