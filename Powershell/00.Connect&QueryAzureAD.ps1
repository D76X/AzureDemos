# ----------------------------------------------------------------------------------------------------------------------------
# First Login to Azure Account to retrieve the TenantID
Login-AzureRmAccount

# Then connect to Azure AD with teh right tenant (admin)
# If not the permission to query Azure AD will not be available to the script
# http://get-cmd.com/?p=4949
Connect-AzureAD -TenantId "981b07d1-b261-4c3e-a400-b86f7809d9bc"
Get-AzureADDomain
Get-AzureADApplication -All:$true | Format-List

Get-AzureADApplication -All:$true `
| Select-Object -Property ObjectType, ObjectID, AppID ,DisplayName `
| Format-List
# ----------------------------------------