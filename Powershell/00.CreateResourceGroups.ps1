
#----------------------------------------------------------------------------------------------------------------------------
# Create a Resource Group
# https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/new-azurermresourcegroup?view=azurermps-6.13.0
# https://app.pluralsight.com/player?course=microsoft-azure-resource-groups-using&author=gary-grudzinskas&name=a02863bf-68fa-4377-ba2f-7ae560f0cd22&clip=3&mode=live
$rgname = "wppres1rg1"
$loc = "West Europe"
New-AzureRmResourceGroup -Name $rgname -Location $loc
#----------------------------------------------------------------------------------------------------------------------------