Login-AzureRmAccount
Set-AzureRmContext -Subscription "df17c9fe-de76-4143-bbae-77b75fa0705b"
Connect-AzureRmAccount
#------------------------------------------------------------------------------

$rgname = "wppres1rg1"
$loc = "West Europe"
$kvname1 = "wppres1kv1"
$kvname2 = "wppres1kv2"

#------------------------------------------------------------------------------
# Select KeyVault
#------------------------------------------------------------------------------

$kvname = $kvname2

#------------------------------------------------------------------------------
# Enable Soft Delete
#------------------------------------------------------------------------------

# get the key vault properties
Get-AzureRmKeyVault -VaultName $kvname

# enable soft delete on a key vault
($resource = Get-AzureRmResource -ResourceId (Get-AzureRmKeyVault -VaultName $kvname).ResourceId).Properties `
| Add-Member -MemberType "NoteProperty" -Name "enableSoftDelete" -Value "true"

Set-AzureRmResource -resourceid $resource.ResourceId -Properties $resource.Properties

#------------------------------------------------------------------------------
# Enable Do Not Purge
#------------------------------------------------------------------------------

#enable "Do Not Purge" on a key vault
($resource = Get-AzureRmResource -ResourceId (Get-AzureRmKeyVault -VaultName $kvname).ResourceId).Properties `
| Add-Member -MemberType NoteProperty -Name enablePurgeProtection  -Value "true"

Set-AzureRmResource -ResourceId $resource.ResourceId -Properties $resource.Properties

#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Test Removal & Recovery
#------------------------------------------------------------------------------
# remove a key vault
Remove-AzureRmKeyVault -VaultName "someKeyVaultName" -ResourceGroupName $rgname

# recover a "soft deleted vault"
Undo-AzureRmKeyVaultRemoval -VaultName "someKeyVaultName" -ResourceGroupName $rgname -Location $loc

# permanantly delete a "soft deleted" key vault - does not work if "Do Not Purge" is enabled
Remove-AzureRmKeyVault -VaultName "someKeyVaultName" -InRemovedState -Location $loc
#------------------------------------------------------------------------------