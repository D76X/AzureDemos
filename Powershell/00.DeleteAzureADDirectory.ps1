# https://developercommunity.visualstudio.com/content/problem/362987/cant-remove-azure-devops-enterprise-application-fr.html


# 1. Create a new Global Admin account in the directory you are trying to delete. Make sure you copy the temporary password
# -----------------------------------------------------
# Global Admin
# globaldamin@wuerthphxpres1.onmicrosoft.com
# Temp Psw: Turo0398
# New Psw : xttr@34$10
#ObjectID = ee00204a-29f2-4efd-8db7-c63ff1c378a0
# -----------------------------------------------------


# 2. Start Powershell and run: Install-Module -Name AzureAD
Install-Module -Name AzureAD

# 3. Once done run Connect-AzureAD. You will be prompted to login, login with the user you created and will be asked to change your password.
Connect-AzureAD

# If you couldn't see the objectid of Azure DevOps in AAD portal, run Get-AzureADServicePrincipal -All 1and then run 
Get-AzureADServicePrincipal -All 1
Remove-AzureADServicePrincipal -objectid [enter objectid here]

# If you could see the the objectid of Azure DevOps in AAD portal, run Remove-AzureADServicePrincipal -objectid [enter objectid here]directly.
Remove-AzureADServicePrincipal -objectid [enter objectid here]

# https://stackoverflow.com/questions/43252813/connect-msolservice-is-not-recognized-as-the-name-of-a-cmdlet
Get-AzureADApplication
Install-Module MSOnline
Connect-MsolService
Get-AzureRmADServicePrincipal | Remove-AzureRmADServicePrincipal
Get-MsolServicePrincipal | Remove-MsolServicePrincipal


# Other useful cmdlets
Get-AzureRmADApplication
Connect-AzureRmAccount
