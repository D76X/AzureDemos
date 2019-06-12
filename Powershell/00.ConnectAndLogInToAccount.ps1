#----------------------------------------------------------------------------------------------------------------------------
# Must run as Admin

# Must log in some account
Login-AzureRmAccount
Connect-AzureRmAccount
#----------------------------------------------------------------------------------------------------------------------------
#Account          : davide.spano.x@gmail.com
#SubscriptionName : Visual Studio Professional with MSDN
#SubscriptionId   : df17c9fe-de76-4143-bbae-77b75fa0705b
#TenantId         : 981b07d1-b261-4c3e-a400-b86f7809d9bc
#Environment      : AzureCloud

#----------------------------------------------------------------------------------------------------------------------------
# Get/Set Subscription Context 
Get-AzureRmContext
(Get-AzureRmContext).Subscription
Set-AzureRmContext -SubscriptionId "df17c9fe-de76-4143-bbae-77b75fa0705b"
#----------------------------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------
# Setting up
Login-AzureRmAccount
Get-AzureRmContext
(Get-AzureRmContext).Subscription
Set-AzureRmContext -SubscriptionId "df17c9fe-de76-4143-bbae-77b75fa0705b"
Set-AzureRmContext -Subscription "df17c9fe-de76-4143-bbae-77b75fa0705b"
Connect-AzureRmAccount
# Find the subscriptions forthe account you are logged on
Get-AzureRmSubscription
# ----------------------------------------------------------------------------------------------------------------------------
