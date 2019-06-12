# ----------------------------------------------------------------------------------------------------------------------------
# The basics 
Login-AzureRmAccount
Connect-AzureRmAccount
Connect-AzureAD -TenantId "981b07d1-b261-4c3e-a400-b86f7809d9bc"
Set-AzureRmContext -SubscriptionId "df17c9fe-de76-4143-bbae-77b75fa0705b"
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
$storageAccountName = 'wppres1sa1' # Name of the storage account
$containerName = 'wppressa1cont1'  # Name of container inside storage account
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Create the resource group, if needed
# use imported custom function New-PSResourceGroup
New-PSResourceGroup -ResourceGroupName $resourceGroupName `
                    -Location $location `
                    -Verbose
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Create the storage account, if needed
# use imported custom function New-PSStorageAccount
New-PSStorageAccount -StorageAccountName $storageAccountName `
                     -ResourceGroupName $resourceGroupName `
                     -Location $location `
                     -Verbose
# ----------------------------------------------------------------------------------------------------------------------------
<#
StorageAccountName     : wppres1sa1
Id                     : /subscriptions/df17c9fe-de76-4143-bbae-77b75fa0705b/re
                         sourceGroups/wppres1rg1/providers/Microsoft.Storage/st
                         orageAccounts/wppres1sa1
#>
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Create the Storage Container, if needed
# use imported custom function New-PSStorageContainer
$container = New-PSStorageContainer -ContainerName $containerName `
                                    -ResourceGroupName $resourceGroupName `
                                    -StorageAccountName $storageAccountName `
                                    -Verbose
# ----------------------------------------------------------------------------------------------------------------------------
