param(
    [string]$AzureUserName,
    [string]$AzurePassword,
    [string]$AzureSubscriptionID,
    [string]$AzureTenantID,
    [string]$ApplicationID,
    [string]$SecretKey,
    [string]$DeploymentID
)

Write-Host "Starting CloudLabs deployment script..."
Write-Host "TenantID      : $AzureTenantID"
Write-Host "ApplicationID : $ApplicationID"
Write-Host "SubscriptionID: $AzureSubscriptionID"
Write-Host "DeploymentID  : $DeploymentID"

# Find VM and RG dynamically — no hardcoded names
$vmName = "labvm"
$rg = (Get-AzVM | Where-Object { $_.Name -eq $vmName }).ResourceGroupName

Write-Host "VM Name        : $vmName"
Write-Host "Resource Group : $rg"

# Pre-resolve ALL values outside here-string — prevents parsing errors
$credLine1 = "TenantID=" + $AzureTenantID
$credLine2 = "AppID=" + $ApplicationID
$credLine3 = "AppSecret=" + $SecretKey

# Build vmScript using simple string concatenation — NO nested here-strings
$vmScript  = "New-Item -ItemType Directory -Path C:\temp -Force | Out-Null`n"
$vmScript += "Set-Content -Path C:\temp\credentials.txt -Encoding UTF8 -Value @('" + $credLine1 + "','" + $credLine2 + "','" + $credLine3 + "')`n"
$vmScript += "Write-Host 'credentials.txt written'`n"
$vmScript += "if (-not (Test-Path 'C:\temp\run.ps1')) { Write-Host 'ERROR: run.ps1 not found'; exit 1 }`n"
$vmScript += "Write-Host 'Triggering run.ps1...'`n"
$vmScript += "powershell -ExecutionPolicy Bypass -File C:\temp\run.ps1`n"

Invoke-AzVMRunCommand `
    -ResourceGroupName $rg `
    -Name $vmName `
    -CommandId "RunPowerShellScript" `
    -ScriptString $vmScript

Write-Host "Deployment script completed successfully"