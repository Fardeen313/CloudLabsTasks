# Exercise 2 — Architecture Overview

## Azure Resources Deployed

| Resource | Name Pattern |
|---|---|
| Virtual Network | labVNet-{DID} |
| Network Security Group | labNSG-{DID} |
| Public IP | Standard · Static |
| Network Interface | labNIC-{DID} |
| Windows VM | labvm-{DID} |
| Storage Account | labstorage{rand} |

---

## End-to-End Automation Flow

```
CloudLabs → ARM Deploy → CSE Runs → SPN Login → Done!
```

1. **CloudLabs** injects SPN credentials into ARM parameters
2. **ARM Deploy** creates all Azure resources
3. **CSE Runs** writes `credentials.txt` and downloads `run.ps1`
4. **SPN Login** — non-interactive `Connect-AzAccount`
5. **Done!** Storage Account + Container + `hello.txt` uploaded

> **Key Design Decision:** Credentials are written to `C:\temp\credentials.txt` by the CSE using `subscription().tenantId` (ARM function) and CloudLabs tokens. This eliminates any interactive login inside the VM.
