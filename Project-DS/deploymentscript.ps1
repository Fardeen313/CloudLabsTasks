param(
    [string]$SubscriptionId,
    [string]$rg,
    [string]$deploymentId,
    [string]$AppId,
    [string]$AppSecret,
    [string]$TenantId
)

Write-Host "Starting CloudLabs deployment script..."

Set-AzContext -Subscription $SubscriptionId

$vmName = "labvm"

Write-Host "VM Name  : $vmName"
Write-Host "RG       : $rg"
Write-Host "TenantId : $TenantId"
Write-Host "AppId    : $AppId"

# Build credential lines as a simple array — no nested here-strings
$line1 = "TenantID=$TenantId"
$line2 = "AppID=$AppId"
$line3 = "AppSecret=$AppSecret"

$vmScript = @"
New-Item -ItemType Directory -Path C:\temp -Force | Out-Null

Set-Content -Path C:\temp\credentials.txt -Encoding UTF8 -Value @(
    '$line1',
    '$line2',
    '$line3'
)

Write-Host "credentials.txt written"

if (-not (Test-Path 'C:\temp\run.ps1')) {
    Write-Host "ERROR: run.ps1 not found"
    exit 1
}

Write-Host "Triggering run.ps1..."
powershell -ExecutionPolicy Bypass -File C:\temp\run.ps1
"@

Invoke-AzVMRunCommand `
    -ResourceGroupName $rg `
    -Name $vmName `
    -CommandId "RunPowerShellScript" `
    -ScriptString $vmScript

Write-Host "Deployment script completed successfully"