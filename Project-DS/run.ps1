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
    if ($_ -match '^(.+?)=(.+)$') { $creds[$matches[1].Trim()] = $matches[2].Trim() }
}

$TenantID  = $creds['TenantID']
$AppID     = $creds['AppID']
$AppSecret = $creds['AppSecret']

Write-Log "TenantID : $TenantID"
Write-Log "AppID    : $AppID"

if (-not $TenantID -or -not $AppID -or -not $AppSecret) {
    Write-Log "ERROR: Missing values in credentials.txt"
    Get-Content 'C:\temp\credentials.txt' | ForEach-Object { Write-Log "  >> $_" }
    exit 1
}

Write-Log "Logging in as SPN..."
try {
    $spSecure = ConvertTo-SecureString $AppSecret -AsPlainText -Force
    $spCred   = New-Object System.Management.Automation.PSCredential($AppID, $spSecure)
    Connect-AzAccount -ServicePrincipal -Credential $spCred -TenantId $TenantID -ErrorAction Stop | Out-Null
    $SubscriptionID = (Get-AzContext).Subscription.Id
    Write-Log "SPN login OK. SubscriptionID: $SubscriptionID"
} catch {
    Write-Log "ERROR SPN login failed: $_"
    exit 1
}

Write-Log "Fetching IMDS..."
$metadata = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' -Headers @{Metadata='true'}
$rg       = $metadata.compute.resourceGroupName
$location = $metadata.compute.location
Write-Log "RG: $rg | Location: $location"

$storageName = "labstorage" + (Get-Random -Minimum 10000 -Maximum 99999)
Write-Log "Creating storage account: $storageName"
New-AzStorageAccount -ResourceGroupName $rg -Name $storageName -Location $location -SkuName Standard_LRS -Kind StorageV2 -ErrorAction Stop | Out-Null
Write-Log "Storage account created"

$ctx = (Get-AzStorageAccount -ResourceGroupName $rg -Name $storageName).Context
New-AzStorageContainer -Name 'labcontainer' -Context $ctx -Permission Off -ErrorAction Stop | Out-Null
Write-Log "Container created"

if (-not (Test-Path 'C:\temp\hello.txt')) {
    Set-Content 'C:\temp\hello.txt' -Value "Hello from CloudLabs!" -Encoding UTF8
}
Set-AzStorageBlobContent -File 'C:\temp\hello.txt' -Container 'labcontainer' -Blob 'hello.txt' -Context $ctx -Force -ErrorAction Stop | Out-Null
Write-Log "hello.txt uploaded"

Write-Log "===== DONE: $storageName | labcontainer | hello.txt ====="