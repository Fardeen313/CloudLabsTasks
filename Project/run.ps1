$creds = @{}
Get-Content 'C:\temp\credentials.txt' | ForEach-Object {
    if ($_ -match '^(.+?)=(.+)$') { $creds[$matches[1].Trim()] = $matches[2].Trim() }
}

$securePassword = ConvertTo-SecureString $creds['AzurePassword'] -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($creds['AzureUserName'], $securePassword)
Connect-AzAccount -Credential $credential -TenantId $creds['TenantID'] | Out-Null

$SubscriptionID = (Get-AzContext).Subscription.Id

$sp = New-AzADApplication -DisplayName "LabSPN-$(Get-Random -Minimum 1000 -Maximum 9999)"
New-AzADServicePrincipal -ApplicationId $sp.AppId | Out-Null
$spSecret = New-AzADAppCredential -ApplicationId $sp.AppId
$NewSPNAppID = $sp.AppId
$NewSPNSecret = $spSecret.SecretText

$metadata = Invoke-RestMethod -Uri 'http://169.254.169.254/metadata/instance?api-version=2021-02-01' -Headers @{Metadata='true'}
$rg = $metadata.compute.resourceGroupName

New-AzRoleAssignment -ApplicationId $NewSPNAppID -RoleDefinitionName "Owner" -ResourceGroupName $rg | Out-Null

Add-Content 'C:\temp\credentials.txt' -Value "AppID=$NewSPNAppID"
Add-Content 'C:\temp\credentials.txt' -Value "AppSecret=$NewSPNSecret"

Start-Sleep -Seconds 30

$spSecure = ConvertTo-SecureString $NewSPNSecret -AsPlainText -Force
$spCred = New-Object System.Management.Automation.PSCredential($NewSPNAppID, $spSecure)
Connect-AzAccount -ServicePrincipal -Credential $spCred -TenantId $creds['TenantID'] | Out-Null
Set-AzContext -SubscriptionId $SubscriptionID | Out-Null

$location = $metadata.compute.location
$storageName = "labstorage" + (Get-Random -Minimum 10000 -Maximum 99999)
New-AzStorageAccount -ResourceGroupName $rg -Name $storageName -Location $location -SkuName Standard_LRS -Kind StorageV2 | Out-Null

$ctx = (Get-AzStorageAccount -ResourceGroupName $rg -Name $storageName).Context
New-AzStorageContainer -Name 'labcontainer' -Context $ctx -Permission Off | Out-Null

Set-AzStorageBlobContent -File 'C:\temp\hello.txt' -Container 'labcontainer' -Blob 'hello.txt' -Context $ctx -Force | Out-Null
Write-Output "Done: $storageName | labcontainer | hello.txt uploaded"