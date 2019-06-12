# ----------------------------------------------------------------------------------------------
# Create an Azure App Service Web App
# Refs
# https://blogs.msdn.microsoft.com/benjaminperkins/2017/10/02/create-an-azure-app-service-web-app-using-powershell/
# https://blogs.msdn.microsoft.com/benjaminperkins/2014/10/01/azure-website-hosting-plans-whp/
# https://www.youtube.com/watch?v=jCfJWYocz1M
# ----------------------------------------------------------------------------------------------
Login-AzureRmAccount
Set-AzureRmContext -Subscription "df17c9fe-de76-4143-bbae-77b75fa0705b"

$resourceGroupName = "wppres1rg1"
$location = "West Europe"          
$appServicePlanName = "wpserviceplan1"
$appServiceName ="05WebApp"

New-AzureRmAppServicePlan -ResourceGroupName $resourceGroupName `
-Location $location `
-Tier Free `
-Name $appServicePlanName

New-AzureRmWebApp -ResourceGroupName $resourceGroupName `
-Location $location `
-AppServicePlan $appServicePlanName `
-Name $appServiceName 

# get all info on your app
Get-AzureRmWebApp -Name $appServiceName 
Get-AzureRmWebApp -ResourceGroupName $resourceGroupName 

#--------------------------------------------------------------------

# Set up a managed identity for the web app.
# This is useful for example to leverage Managed Service Identity (MSI)
# authentication between any number of Azure Managed Services.

# ===================================================
#Refs

# With the Az Modules
# https://docs.microsoft.com/en-us/azure/app-service/overview-managed-identity

# With the AzureRm Module
# https://docs.microsoft.com/en-us/powershell/module/azurerm.websites/set-azurermwebapp?view=azurermps-6.13.0 

# Migrate from AzureRM to Azure PowerShell Az
# https://docs.microsoft.com/en-us/powershell/azure/migrate-from-azurerm-to-az?view=azps-2.0.0
# ===================================================

# ---------------------------------------------------
# This shows how to do it with AzureRm Module
# https://docs.microsoft.com/en-us/powershell/module/azurerm.websites/set-azurermwebapp?view=azurermps-6.13.0

# ----------------------------------------
# might need to update the PSRepository in order to run the 
# update of modules installed on your machine. However, the 
# URI of teh Repomight have changed and be invalid thus it 
# must be updated.
Get-PSRepository # might show the old value 
Register-PSRepository -Name PSGallery1 -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted
# ----------------------------------------

# check out the modules in the session
Get-Module 

# check out the modules on the machine
Get-InstalledModule 

# check the version of AzureRM
Get-InstalledModule -AllVersions -Name AzureRM

# update the AzureRM module if required
Update-Module AzureRM

# ------------------------------------------------------------
# Once the latestversion of the AzureRM module and submodules
# are installed on the machine the following command should 
# work and set the principal fir the application.

# Modifies an Azure Web App by setting AssignIdentity = true
# which causes a service identity to be assigned to it.

Set-AzureRmWebApp -AssignIdentity $true `
-ResourceGroupName $resourceGroupName `
-AppServicePlan $appServicePlanName `
-Name $appServiceName

# this provides info on the app but not its principal
# the principal of an app is an artifact related to 
# Azure AD not teh application itself
Get-AzureRmWebApp -ResourceGroupName $resourceGroupName `
-Name $appServiceName 

# the applicationid can be used to get the principal Id
Get-AzureRmADApplication
Get-AzureRmADApplication -DisplayName $appServiceName 

# with the ApplicationId
Get-AzureRmADServicePrincipal -ApplicationId 9fc8020f-0a8b-4938-aea4-6168c00e5eef #04WebApp
Get-AzureRmADServicePrincipal -ApplicationId 0f5f7e97-04a3-471a-a4e4-eb845a06ce78 #05WebApp
# ------------------------------------------------------------
<#
ServicePrincipalNames : {https://davidespanoxgmail.onmicrosoft.com/04WebApp_201
                        90511300129, 9fc8020f-0a8b-4938-aea4-6168c00e5eef}
ApplicationId         : 9fc8020f-0a8b-4938-aea4-6168c00e5eef
DisplayName           : 04WebApp
Id                    : c9a09003-0e7b-4001-8207-d0273be7f6b0
AdfsId                : 
Type                  : ServicePrincipal
#>
# ------------------------------------------------------------

# ------------------------------------------------------------
# The following shows how to do it with Az Module.

# Unfortunately it only works if AzureRm is uninstalled from 
# the PC first otherwise the command fails with a warning 
# staing that Module Az cannot be used side-by-side with 
# module AzureRm.

# Need the sub-module 'Az.Websites' for the cmdlet Set-AzWebApp

# First must remove some modules from the current session.
# AzureRM.XXX as these have conflicting cmdltes then you can 
# istall the Az.Websites and load it into teh session

# these show how to remove modules from teh session
Remove-Module -Name AzureRM.Profile
Remove-Module -Name AzureRM.KeyVault
Remove-Module -Name AzureRM.Resources
Remove-Module -Name AzureRM.Websites

# check
Get-Module

# install the module on teh machine
Install-Module -Name Az.Websites -RequiredVersion 1.0.0
# import the module into the session
Import-Module 'Az.Websites'

# check
Get-Module

# Modifies an Azure Web App by setting AssignIdentity = true
# which causes a service identity to be assigned to it.
Set-AzWebApp -Name $appServiceName `
-ResourceGroupName $resourceGroupName `
-AssignIdentity $true
#--------------------------------------------------------------------