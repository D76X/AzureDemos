# ----------------------------------------------------------------------------------------------------------------------------
# The basics 
Login-AzureRmAccount
Connect-AzureRmAccount
Connect-AzureAD -TenantId "981b07d1-b261-4c3e-a400-b86f7809d9bc"
Set-AzureRmContext -SubscriptionId "df17c9fe-de76-4143-bbae-77b75fa0705b"
# Verify
Get-AzureRmContext
# ----------------------------------------------------------------------------------------------------------------------------
<#
Name             : [davide.spano.x@gmail.com, 
                   df17c9fe-de76-4143-bbae-77b75fa0705b]
Account          : davide.spano.x@gmail.com
SubscriptionName : Visual Studio Professional with MSDN
TenantId         : 981b07d1-b261-4c3e-a400-b86f7809d9bc
Environment      : AzureCloud
#>
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Set location where our demo files are located
$dir = "C:\GitHub\WPPresentation"
Set-Location $dir
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Run a script with functions used by multiple scripts in this course
. .\00.HelperFunctions.ps1
# ----------------------------------------------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------------------------------------------
# Create the resource group, if needed
$resourceGroupName = "wppres1rg1"
$location = "West Europe"          # Geographic location to store everything
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Create the resource group, if needed
# use imported custom function New-PSResourceGroup
New-PSResourceGroup -ResourceGroupName $resourceGroupName `
                    -Location $location `
                    -Verbose
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------

# Create a Key Vault to hold the Column Master Key (CMK)
# The Column Master Key is used to encrypt and decript the Column Encryption Key (CEK) 
$kvname = "wppres1kv2"
New-AzureRmKeyVault -VaultName $kvname -ResourceGroupName  $resourceGroupName -Location $location
# ----------------------------------------------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------------------------------------------
# Grant key 
# ====================================
# Unfortunately the following fails!
# Cannot find the Active Directory object '' in tenant '981b07d1-b261-4c3e-a400-b86f7809d9bc'.
# ====================================

# https://social.msdn.microsoft.com/Forums/azure/en-US/5ec401e9-258e-4e9d-ac73-98bef335a5ad/azure-keyvault-setup-error-setazurermkeyvaultaccesspolicy?forum=AzureKeyVault

# make sure to use the right $userPrincipalName
Get-AzureRmContext #is the current subscription's Azure Active directory.
Get-AzureADUser
Get-AzureADUser | Format-List
(Get-AzureADUser) | Select-Object -Property UserPrincipalName
# $userPrincipalName = 'davide.spano.x@gmail.com' >> will not work!
$userPrincipalName = (Get-AzureADUser) | Select-Object -Property UserPrincipalName
$userPrincipalName
$kvname = "wppres1kv2"
# grant key vault access to the user (user will be used to login to Azure in the SSMS wizard)
Set-AzureRmKeyVaultAccessPolicy -VaultName $kvname -ResourceGroupName $resourceGroupName -PermissionsToKeys create,get,wrapKey,unwrapKey,sign,verify,list -UserPrincipalName $userPrincipalName
# ----------------------------------------------------------------------------------------------------------------------------


$applicationId = '386424df-c14a-4436-b872-f186ea2ddc98'


# ----------------------------------------------------------------------------------------------------------------------------
