$creds = @{}
Get-Content 'C:\temp\credentials.txt' | ForEach-Object {
    if ($_ -match '^(.+?)=(.+)$') { $creds[$matches[1].Trim()] = $matches[2].Trim() }
}

$spSecure = ConvertTo-SecureString $creds['AppSecret'] -AsPlainText -Force
$spCred = New-Object System.Management.Automation.PSCredential($creds['AppID'], $spSecure)
Connect-AzAccount -ServicePrincipal -Credential $spCred -TenantId $creds['TenantID'] | Out-Null
Set-AzContext -SubscriptionId $creds['SubscriptionID'] | Out-Null

$metadata = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' -Headers @{Metadata='true'}
$rg = $metadata.compute.resourceGroupName
$location = $metadata.compute.location

$storageName = ('labstorage' + $creds['SubscriptionID'].Substring(0,8)).ToLower() -replace '[^a-z0-9]',''
New-AzStorageAccount -ResourceGroupName $rg -Name $storageName -Location $location -SkuName Standard_LRS -Kind StorageV2 | Out-Null

$ctx = (Get-AzStorageAccount -ResourceGroupName $rg -Name $storageName).Context
New-AzStorageContainer -Name 'labcontainer' -Context $ctx -Permission Off | Out-Null

Set-AzStorageBlobContent -File 'C:\temp\hello.txt' -Container 'labcontainer' -Blob 'hello.txt' -Context $ctx -Force | Out-Null
Write-Output 'Done'


# $creds = @{}
# Get-Content 'C:\temp\credentials.txt' | ForEach-Object {
#     if ($_ -match '^(.+?)=(.+)$') { $creds[$matches[1].Trim()] = $matches[2].Trim() }
# }

# $spSecure = ConvertTo-SecureString $creds['AppSecret'] -AsPlainText -Force
# $spCred = New-Object System.Management.Automation.PSCredential($creds['AppID'], $spSecure)
# Connect-AzAccount -ServicePrincipal -Credential $spCred -TenantId $creds['TenantID'] | Out-Null
# Set-AzContext -SubscriptionId $creds['SubscriptionID'] | Out-Null

# $metadata = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' -Headers @{Metadata='true'}
# $rg = $metadata.compute.resourceGroupName
# $location = $metadata.compute.location

# $storageName = ('labstorage' + $creds['SubscriptionID'].Substring(0,8)).ToLower() -replace '[^a-z0-9]',''
# New-AzStorageAccount -ResourceGroupName $rg -Name $storageName -Location $location -SkuName Standard_LRS -Kind StorageV2 | Out-Null

# $ctx = (Get-AzStorageAccount -ResourceGroupName $rg -Name $storageName).Context
# New-AzStorageContainer -Name 'labcontainer' -Context $ctx -Permission Off | Out-Null

# Set-AzStorageBlobContent -File 'C:\temp\hello.txt' -Container 'labcontainer' -Blob 'hello.txt' -Context $ctx -Force | Out-Null
# Write-Output 'Done'
