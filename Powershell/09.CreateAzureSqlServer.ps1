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
$serverName = 'wppres1sqlserver1'  # Name for our new SQL Server
$userName = 'dspano'               # Admin User Name for the SQL Server # cannot use admin!!!
# ---------------------------------------------------------------------------
# should use Convert-To-SecureString
# there is a minimum complexity level required
$password = '@X1y2z3w4z5'             # bad OK only for Demos no Production! 
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Create a Azure SQL Instance
# use the imported custom function New-PSAzureSQLServer
New-PSAzureSQLServer -ServerName $serverName `
                     -ResourceGroupName $resourceGroupName `
                     -Location $location `
                     -UserName $userName `
                     -Password $password `
                     -Verbose
# ----------------------------------------------------------------------------------------------------------------------------
<#
ResourceGroupName        : wppres1rg1
ServerName               : wppres1sqlserver1
Location                 : westeurope
SqlAdministratorLogin    : dspano
SqlAdministratorPassword : 
ServerVersion            : 12.0
Tags                     : 
Identity                 : 
FullyQualifiedDomainName : wppres1sqlserver1.database.windows.net
#>
# ----------------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------------
# Any time a new instance of Azure SQL Server is created 
# this is by default protected by a Firewall that blocks 
# ALL traffic in and out. It would not even be possible 
# to connect to it by using SSMS with usr and psw as 
# customary without first taking action to relax this 
# default policy.

# We must create a new Firewall Rule to allow remote connection 
# to the Azure SQL Server Instance. 

$firewallRuleName = 'AdminFirewallRule' 

# Select the range of addresses that Firewall Rule should allow
# to connect to the Azure SQL Server Instance

# ----------------------------------------------------------
# Example 1 - The addresses of teh local machine
# There are two ways to get the IP address for the firewall.
# First, you can get the IP Address of the computer running 
# this script
$x = Get-NetIPAddress -AddressFamily IPv4
$startIP = $x[0].IPAddress
$endIP = $x[0].IPAddress
# ----------------------------------------------------------

# ----------------------------------------------------------
# Example 2 - use a specific static range i.e. that of your company
# Alternatively, you can manually enter a range of IPs. Here it's just
# been opened to the entire internet, in reality you'd limit it to just 
# the range needed by your company.
# This is not suitable for production, of course.
$startIP = '0.0.0.0'
$endIP = '255.255.255.255'
# ----------------------------------------------------------

# Create the Firewall Rule to allow access to the Azure SQL Instance
# use the custom helper function New-PSAzureSQLServerFirewallRule
New-PSAzureSQLServerFirewallRule -ServerName $serverName `
                                 -ResourceGroupName $resourceGroupName `
                                 -FirewallRuleName $firewallRuleName `
                                 -StartIpAddress $startIP `
                                 -EndIpAddress $endIP `
                                 -Verbose
# ----------------------------------------------------------------------------------------------------------------------------
<#
ResourceGroupName : wppres1rg1
ServerName        : wppres1sqlserver1
StartIpAddress    : 0.0.0.0
EndIpAddress      : 255.255.255.255
FirewallRuleName  : AdminFirewallRule
#>
# ----------------------------------------------------------------------------------------------------------------------------


# Connect as admin to the Azure SQL Instance
# three pieces of info are required
# username : as set
# password : as set
# servername : From Azure portal wppres1sqlserver1 => wppres1sqlserver1.database.windows.net 