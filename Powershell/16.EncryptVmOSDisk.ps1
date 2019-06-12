Login-AzureRmAccount
Set-AzureRmContext -Subscription "df17c9fe-de76-4143-bbae-77b75fa0705b"
Connect-AzureRmAccount
#------------------------------------------------------------------------------
#Azure Active Directory PowerShell module.
Install-Module AzureAD

#Verify the installed versions of the modules.
Get-Module AzureRM -ListAvailable | Select-Object -Property Name,Version,Path
Get-Module AzureAD -ListAvailable | Select-Object -Property Name,Version,Path

#-----------------------------------------------------------------------------

# --------------------------------------------------------------------------------
# Enable Azure Disk Encryption on the VM
# --------------------------------------------------------------------------------

# First you need a KeyVault that is enabled for Disk Encryption
# Must check whether it is already otherwise must enable DE by 
# setting the corresponding property on it.

$resourceGroupName = "wppres1rg1"
$rgName = $resourceGroupName 
$location = "West Europe"
$kvName = 'wppres1kv1'
$rgName = "wppres1rg1"

#-----------------------------------------------
# Enable Disk Encryption on a Key Vault
# This is a special policy
Set-AzureRmKeyVaultAccessPolicy -VaultName $kvName `
-ResourceGroupName $resourceGroupName `
-EnabledForDiskEncryption
#-----------------------------------------------

#-----------------------------------------------
# You need an app registered with Azure AD to 
$appDisplayName = "summy-app-to-encrypt-myvm1-disk"
$aadClientSecret = "secretToEncrytMyVm1"

$aadApp = New-AzureRmADApplication -DisplayName $appDisplayName `
-HomePage 'http://wppres1vm1encryptapp' `
-IdentifierUris 'http://uriwppres1vm1encryptapp' `
-Password ($aadClientSecret | ConvertTo-SecureString -AsPlainText -Force) 

$aadApp = Get-AzureRmADApplication -DisplayName $appDisplayName
$appID = $aadApp.ApplicationId #794b5d71-f670-422c-928c-56a669f1a682
#-----------------------------------------------

#-----------------------------------------------
# You need Azure AD to provide a Service Principal for the dummy app
# so that you can then use this ID to set up the key vault in order 
# to let this app access the encryption key for the vm

$aadServicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $appID
# Id : f72735a1-4681-4bb0-bfe2-1da085f4c502

#-----------------------------------------------

#-----------------------------------------------
# You can now set up the access policy of the key vault that holds the 
# encryption key for the vm for the dummy app that is going to be used ]
# by Azure to read the key from teh key vault when the encryption is 
# performed. 

# Here we give the principla all permissions on Keys and Secrets only for demo
# in reality it needs only to be able to read and list and wrap and unwrap 
# must test the minimum required subset

# Once done you can trim it down from the portal on teh key vault access policies

Set-AzureRmKeyVaultAccessPolicy -VaultName $kvName `
-ServicePrincipalName $appID `
-PermissionsToKeys decrypt,encrypt, unwrapKey,wrapKey,verify,sign,get,list,update,create,import,delete,backup, restore,recover,purge `
-PermissionsToSecrets get,list,set,delete,backup,restore,recover,purge

#-----------------------------------------------
$vmName = "MyVM1"
#-----------------------------------------------
$kv = (Get-AzureRmKeyVault -VaultName $kvName -ResourceGroupName $rgName)
$kv.EnabledForDiskEncryption
$kvUri = $kv.VaultUri
$kvRID = $kv.ResourceId


# Now you can ask to encrypt the OS Disk

# ---------------------------------
# ! Important
# For all of this to work a back up of teh OS disk must have been already taken
# otherwise the Set-AzureRmVMDiskEncryptionExtension fails!
# ---------------------------------

Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgName `
-VMName $vmName `
-AadClientID $appID `
-AadClientSecret $aadClientSecret `
-DiskEncryptionKeyVaultUrl $kvUri `
-DiskEncryptionKeyVaultId $kvRID

Get-AzureRmVMDiskEncryptionStatus -VMName $vmName -ResourceGroupName $rgName

#-----------------------------------------------

# Now you can ask to encrypt the Data Disk

# ---------------------------------
# ! Important
# This might be redundant as with the new VMs the Data Disk is encrypted 
# automatically if it exists at the time the OS Disk is encrypted. If this
# is not the case the encryption of the Data Disk can be done seperately.
# A data disk can be attached from the portal or from the VM itself. 
# ---------------------------------

Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgName `
-VMName $vmName `
-AadClientID $appID `
-AadClientSecret $aadClientSecret `
-DiskEncryptionKeyVaultUrl $kvUri `
-DiskEncryptionKeyVaultId $kvRID `
-VolumeType Data

Get-AzureRmVMDiskEncryptionStatus -VMName $vmName -ResourceGroupName $rgName

#-----------------------------------------------