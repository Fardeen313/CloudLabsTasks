# Exercise 3 — Prerequisites & CloudLabs Permissions

## Required Access

- Active CloudLabs ODL account with a Shared Subscription assigned
- AAD Service Principal enabled for your ODL with Owner role on resource group
- Public GitHub repository hosting `run.ps1` — CSE must be able to download it anonymously
- Azure Portal access for post-deployment verification
- RDP access to the VM (browser-based via CloudLabs or direct RDP client)

---

## CloudLabs Template Permissions

| # | User Type | Scope | Role |
|---|---|---|---|
| 22360 | AADUser | .../resourceGroups/rg-ProjectAutomation | Owner |
| 22361 | AADServicePrincipal | .../resourceGroups/rg-ProjectAutomation | Owner |

> **Shared Subscription Constraint:** ODL users have Owner on the Resource Group ONLY — not Azure AD. This means `New-AzADApplication` will fail. Always use the CloudLabs-provisioned SPN via `GET-SERVICEPRINCIPAL-APPLICATION-ID`.
