# ----------------------------------------------------------------------------------------------------------------------------
# 1- Register the application with Azure AD
# 2- Get the Application ID 
# 3- Generate a Client Secret for that Application ID
# --------------------------------------------------------------------------------------
# Application Registration with Azure AD
# Name : 01KeyVaultApp
# Application(client) ID: 3da2ec55-4670-4e30-b7f2-6c4a29ec9a3f
# Directory(tenant) ID : 981b07d1-b261-4c3e-a400-b86f7809d9bc
# Object ID : 2458fef3-3247-4fb2-a3ab-e144b93d1818
# Supported account types : My organization only
# Redirect URIs :Add a Redirect URI
# Managed application in local directory :01KeyVaultApp
# --------------------------------------------------------------------------------------
# # Application Registration with Azure AD - Create a new Key
# Se also Certificates and Secrets tab
# Application Secret (aka Client Secret)
# /nKN++8?2m2LUUTdWva5bwcZHR__slTr
# --------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------------------------------------------
# https://stackoverflow.com/questions/2608144/how-to-split-long-commands-over-multiple-lines-in-powershell
# Access Policies on Azure Key Vault
$kvname = "wppres1kv1"
((Get-AzureRmKeyVault -VaultName $kvname).AccessPolicies).Count
(Get-AzureRmKeyVault -VaultName $kvname).AccessPolicies 

# In table format ObjectId, DisplayName
# The ObjectID is what identifies the access policy object
# DisplayName is normally the name if teh application to which the access policy applies
(Get-AzureRmKeyVault -VaultName "wppres1kv1").AccessPolicies | `
Select-Object -Property ObjectId, DisplayName |`
Format-Table

# better to format as list
# Notice that there are no values for ApplicationIdDisplayName, ApplicationId
# thus you cannot build Where-Object clauses with them
(Get-AzureRmKeyVault -VaultName "wppres1kv1").AccessPolicies | `
Select-Object -Property ObjectId, DisplayName,ApplicationIdDisplayName, ApplicationId |`
Format-List
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# First Login to Azure Account to retrieve the TenantID
Login-AzureRmAccount

# Then connecto to Azure AD with teh right tenant (admin)
# If not the permission to query Azure AD will not be available to the script
# http://get-cmd.com/?p=4949
Connect-AzureAD -TenantId "981b07d1-b261-4c3e-a400-b86f7809d9bc"
Get-AzureADDomain
Get-AzureADApplication -All:$true | Format-List

Get-AzureADApplication -All:$true `
| Select-Object -Property ObjectType, ObjectID, AppID ,DisplayName `
| Format-List
# ----------------------------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------------
# set the access policy 
$kvname = "wppres1kv1"
$appID = "3da2ec55-4670-4e30-b7f2-6c4a29ec9a3f"
Set-AzureRmKeyVaultAccessPolicy -VaultName $kvname `
-ServicePrincipalName $appID `
-PermissionsToSecrets Get # add as many permissions as necessary
# ----------------------------------------------------------------------------------------------------------------------------
