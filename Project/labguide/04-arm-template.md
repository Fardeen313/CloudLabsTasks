# Exercise 4 — ARM Template Setup

## Key Parameters — CloudLabs Token Injection

| Parameter | Default / Token Value | Purpose |
|---|---|---|
| CloudLabsDeploymentID | `GET-DEPLOYMENT-ID` | Unique ID — used for resource naming |
| AppID | `GET-SERVICEPRINCIPAL-APPLICATION-ID` | SPN Client ID — CloudLabs auto-replaces |
| AppSecret | `GET-SERVICEPRINCIPAL-SECRET` | SPN Secret — CloudLabs auto-replaces |
| adminUsername | `labuser` | VM local admin |
| adminPassword | `Password.1!!` | VM local admin password |

> **Auto-Injection:** CloudLabs replaces `GET-SERVICEPRINCIPAL-APPLICATION-ID` and `GET-SERVICEPRINCIPAL-SECRET` at deploy time with real SPN values. No manual entry needed.

---

## Public IP — Standard + Static Required

> **RDP over HTTPS will not work with Basic + Dynamic.** Must use Standard SKU and Static allocation.

```json
{
  "name": "[variables('pipName')]",
  "type": "Microsoft.Network/publicIPAddresses",
  "sku": { "name": "Standard" },
  "properties": {
    "publicIPAllocationMethod": "Static",
    "dnsSettings": {
      "domainNameLabel": "[variables('pipDNSLabel')]"
    }
  }
}
```

---

## ARM Outputs

> **Use `subscription().tenantId` — NOT `{Tenant-Id}` token.** The CloudLabs `{Tenant-Id}` token returns the CloudLabs platform tenant ID, not your Azure subscription tenant.

```json
"outputs": {
  "VMDNSName":       { "type": "string", "value": "[reference(resourceId('Microsoft.Network/publicIPAddresses', variables('pipName'))).dnsSettings.fqdn]" },
  "VMAdminUsername": { "type": "string", "value": "[parameters('adminUsername')]" },
  "VMAdminPassword": { "type": "string", "value": "[parameters('adminPassword')]" },
  "VMName":          { "type": "string", "value": "[variables('vmName')]" },
  "TenantID":        { "type": "string", "value": "[subscription().tenantId]" }
}
```
