#----------------------------------------------------------------------------------------------------------------------------
# Setting up
Login-AzureRmAccount
Get-AzureRmSubscription
Set-AzureRmContext -Subscription "df17c9fe-de76-4143-bbae-77b75fa0705b"
Connect-AzureRmAccount

# alternatively
Get-AzureRmContext
(Get-AzureRmContext).Subscription
Set-AzureRmContext -SubscriptionId "df17c9fe-de76-4143-bbae-77b75fa0705b"

# Refs
# https://stackoverflow.com/questions/34928451/how-to-find-the-current-azure-rm-subscription
# https://blogs.msdn.microsoft.com/benjaminperkins/2017/08/02/how-to-set-azure-powershell-to-a-specific-azure-subscription/

#----------------------------------------------------------------------------------------------------------------------------
# Create a Resource Group

# Refs
# https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/new-azurermresourcegroup?view=azurermps-6.13.0
# https://app.pluralsight.com/player?course=microsoft-azure-resource-groups-using&author=gary-grudzinskas&name=a02863bf-68fa-4377-ba2f-7ae560f0cd22&clip=3&mode=live

$rgname = "wppres1rg1"
$loc = "West Europe"
New-AzureRmResourceGroup -Name $rgname -Location $loc
#----------------------------------------------------------------------------------------------------------------------------
# creating a new Azure Key Vault

# Refs
# https://app.pluralsight.com/player?course=microsoft-azure-data-securing&author=reza-salehi&name=83d87507-3bef-4754-a046-46980dbdfc55&clip=3&mode=live
$kvname = "wppres1kv1"
New-AzureRmKeyVault -VaultName 'wppres1kv1' -ResourceGroupName $rgname -Location $loc

# VaultUri   : https://wppres1kv1.vault.azure.net
# ResourceId : /subscriptions/df17c9fe-de76-4143-bbae-77b75fa0705b/resourceGroups/wppres1rg1/providers/Microsoft.KeyVault/vaults/wppres1kv1
# VaultName  : wppres1kv1

#----------------------------------------------------------------------------------------------------------------------------

# Add a secret to the VAULT

# convert our secret value to a "secure string"
$vaultName = '$vaultName'
$secretValue = "some-secret-value"
$secretvalueString = ConvertTo-SecureString –String $secretValue -AsPlainText -Force
$secretvalueName = 'secretvalueName'

# add the secure string to our new Key Vault
$secret = Set-AzureKeyVaultSecret -VaultName $vaultName `
-Name $secretvalueName `
-SecretValue $secretvalueString

$secret.Id

# ----------------------------------------------------------------------------
# Refs
# https://docs.microsoft.com/en-us/powershell/module/azurerm.keyvault/set-azurermkeyvaultaccesspolicy?view=azurermps-6.13.0

# set access policy on the vault for a particular principal
# ServicePrincipalName Specifies the user principal name of the user to whom 
# to grant permissions. This user principal name must exist in the directory 
# associated with the current subscription.
Set-AzureRmKeyVaultAccessPolicy -VaultName $vaultName `
-ServicePrincipalName 386424df-c14a-4436-b872-f186ea2ddc98 `
-PermissionsToSecrets Get
# ----------------------------------------------------------------------------

