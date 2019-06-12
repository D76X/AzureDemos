#region Get-PSStorageAccountKey
<#---------------------------------------------------------------------------#>
<# Get-PSStorageAccountKey                                                   #>
<#---------------------------------------------------------------------------#>
function Get-PSStorageAccountKey ()
{
<#
  .SYNOPSIS
  Gets the key associated with a storage account

  .DESCRIPTION
  Every storage account has a special key assoicated with it. This key unlocks
  the storage vault to get data in or out of it. This cmdlet will get the key
  for the passed storage account.

  .PARAMETER ResourceGroupName
  The name of the resource group containing the storage account

  .PARAMETER StorageAccountName
  The name of the storage account you need the key for

  .INPUTS
  System.String

  .OUTPUTS
  Storage Account Key

  .EXAMPLE
  Get-PSStorageAccountKey -ResourceGroupName 'ArcaneRG' `
                          -StorageAccountName 'ArcaneStorageAcct'

  .NOTES
  Author: Davide Spano
#>
  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The resource group containing the storage account'
                   )
         ]
         [string]$ResourceGroupName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The name of the storage account to get the key for'
                   )
         ]
         [string]$StorageAccountName
       )

  $fn = 'Get-PSStorageAccountKey:'

  Write-Verbose "$fn Getting storage account key for storage account $StorageAccountName"
  $storageAccountKey = $(Get-AzureRmStorageAccountKey `
                           -ResourceGroupName $ResourceGroupName `
                           -Name $StorageAccountName `
                        ).Value[0]

  return $storageAccountKey
}
#endregion Get-PSStorageAccountKey

#region Get-PSStorageContext
<#---------------------------------------------------------------------------#>
<# Get-PSStorageContext                                                      #>
<#---------------------------------------------------------------------------#>
function Get-PSStorageContext ()
{
<#
  .SYNOPSIS
  Get the context for a storage account.

  .DESCRIPTION
  To fully access a storage account you use its context. The context is based
  on a combination of the account name and key. This cmdlet will retrieve the
  context so you can use it in subsequent storage operations.

  .PARAMETER ResourceGroupName
  The resource group containing the storage account.

  .PARAMETER StorageAccountName
  The name of the storage account. 

  .INPUTS
  System.String

  .OUTPUTS
  Context

  .EXAMPLE
  Get-PSStorageContext -ResourceGroupName 'ArcaneRG' `
                       -StorageAccountName 'ArcaneStorageAcct'


  .NOTES
  Author: Davide Spano
#>
  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The resource group containing the storage account'
                   )
         ]
         [string]$ResourceGroupName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The name of the storage account to get the context for'
                   )
         ]
         [string]$StorageAccountName
       )
  
  $fn = 'Get-PSStorageContext:'
  # This uses the custom cmdlet declared earlier in this file
  $storageAccountKey = Get-PSStorageAccountKey `
                         -ResourceGroupName $ResourceGroupName `
                         -StorageAccountName $StorageAccountName
  

  # Now that we have the key, we can get the context
  Write-Verbose "$fn Getting Storage Context for account $StorageAccountName"
  $context = New-AzureStorageContext `
               -StorageAccountName $StorageAccountName `
               -StorageAccountKey $storageAccountKey

  return $context
}
#endregion Get-PSStorageContext

#region New-PSResourceGroup
<#---------------------------------------------------------------------------#>
<# New-PSResourceGroup                                                       #>
<#---------------------------------------------------------------------------#>
function New-PSResourceGroup ()
{ 
<#
  .SYNOPSIS
  Create a new resource group.

  .DESCRIPTION
  Checks to see if the passed in resource group name exists, if not it will 
  create it in the location that matches the location parameter.
  
  .PARAMETER ResourceGroupName
  The name of the resource group to create

  .PARAMETER Location
  The Azure geographic location to store the resource group in.

  .INPUTS
  System.String

  .OUTPUTS
  n/a

  .EXAMPLE
  New-PSResourceGroup -ResourceGroupName 'ArcaneRG' -Location 'southcentralus'

  .NOTES
  Author: Davide Spano
#>
  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The name of the resource group to create'
                   )
         ]
         [string]$ResourceGroupName 
       , [Parameter( Mandatory=$true
                   , HelpMessage='The geo location to store the Resource Group in'
                   )
         ]
         [string]$Location
       )
  
  $fn = 'New-PSResourceGroup:'
  # Check to see if the resource group already exists
  Write-Verbose "$fn Checking for Resource Group $ResourceGroupName"

  # Method 1 - Ignores errors
  # $rgExists = Get-AzureRmResourceGroup -Name $ResourceGroupName `
  #                                      -ErrorAction SilentlyContinue

  # Method 2 - Filters on this end
  $rgExists = Get-AzureRmResourceGroup |
     Where-Object {$_.ResourceGroupName -eq $ResourceGroupName}

  
  # If not, create it.
  if ( $rgExists -eq $null )
  {
    Write-Verbose "$fn Creating Resource Group $ResourceGroupName"
    New-AzureRmResourceGroup -Name $ResourceGroupName `
                             -Location $Location
  }
}
#endregion New-PSResourceGroup

#region New-PSStorageAccount
<#---------------------------------------------------------------------------#>
<# New-PSStorageAccount                                                      #>
<#---------------------------------------------------------------------------#>
function New-PSStorageAccount ()
{ 
<#
  .SYNOPSIS
  Create a new storage account

  .DESCRIPTION
  Checks to see if an Azure storage account exists in a particular resource
  group. If not, it will create it. 

  .PARAMETER StorageAccountName
  The name of the storage account to create.

  .PARAMETER ResourceGroupName
  The resource group to put the storage account in.

  .Parameter Location
  The Azure geographic location to put the storage account in.

  .INPUTS
  System.String

  .OUTPUTS
  A new storage account

  .EXAMPLE
  New-PSStorageAccount -StorageAccountName 'ArcaneStorageAcct' `
                       -ResourceGroupName 'ArcaneRG' `
                       -Location 'southcentralus'

  .NOTES
  Author: Davide Spano
#>
  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The name of the storage account to create'
                   )
         ]
         [string]$StorageAccountName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The resource group to put the storage account in'
                   )
         ]
         [string]$ResourceGroupName 
       , [Parameter( Mandatory=$true
                   , HelpMessage='The geo location to put the storage account in'
                   )
         ]
         [string]$Location
       )

  $fn = 'New-PSStorageAccount:'

  # Check to see if the storage account exists
  Write-Verbose "$fn Checking Storage Account $StorageAccountName"
  $saExists = Get-AzureRMStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $StorageAccountName `
                -ErrorAction SilentlyContinue

  # If not, create it.
  if ($saExists -eq $null)
  { 
    Write-Verbose "$fn Creating Storage Account $StorageAccountName"
    New-AzureRmStorageAccount -ResourceGroupName $ResourceGroupName `
                              -Name $StorageAccountName `
                              -Location $Location `
                              -Type Standard_LRS
  }
}
#endregion New-PSStorageAccount

#region New-PSStorageContainer
<#---------------------------------------------------------------------------#>
<# New-PSStorageContainer                                                    #>
<#---------------------------------------------------------------------------#>
function New-PSStorageContainer ()
{ 
<#
  .SYNOPSIS
  Create a new Azure Blob Storage Container.

  .DESCRIPTION
  Checks to see if a storage container already exists for the name passed in.
  If not, it will create a new Blob Storage Container. 

  .PARAMETER ContainerName
  The name of the container to create.

  .PARAMETER ResourceGroupName
  The name of the resource group containing the storage account

  .PARAMETER StorageAccountName
  The name of the storage account you want to create a container in

  .INPUTS
  System.String

  .OUTPUTS
  A new Azure Blob Storage Container

  .EXAMPLE
  New-PSStorageContainer -ContainerName 'ArcaneContainer' `
                         -ResourceGroupName 'ArcaneRG' `
                         -StorageAccountName 'ArcaneStorageAcct'

  .NOTES
  Author: Davide Spano
#>
  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The name of the container to create'
                   )
         ]
         [string]$ContainerName 
       , [Parameter( Mandatory=$true
                   , HelpMessage='The resource group containing the storage account'
                   )
         ]
         [string]$ResourceGroupName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The name of the storage account to create the container in'
                   )
         ]
         [string]$StorageAccountName
       )
  
  $fn = 'New-PSStorageContainer:'
  Write-Verbose "$fn Checking for Storage Container $ContainerName"

  # First we have to have the storage context
  $context = Get-PSStorageContext `
               -ResourceGroupName $ResourceGroupName `
               -StorageAccountName $StorageAccountName
  
  # Now we can check to see if it exists
  $exists = Get-AzureStorageContainer -Name $ContainerName `
                                      -Context $context `
                                      -ErrorAction SilentlyContinue

  # If it doesn't exist, we'll create it                            
  if ($exists -eq $null)
  { 
    Write-Verbose "$fn Creating Storage Container $ContainerName"
    New-AzureStorageContainer -Name $ContainerName `
                              -Context $context `
                              -Permission Blob
  }
  
  # Whether it already existed or we just created it, we'll grab a reference
  # to it and return it from the function
  Write-Verbose "$fn Retrieving container $ContainerName information"
  $container = Get-AzureStorageContainer -Name $ContainerName `
                                         -Context $context
  return $container
}
#endregion New-PSStorageContainer

#region New-PSAzureSQLServer
<#---------------------------------------------------------------------------#>
<# New-PSAzureSQLServer                                                      #>
<#---------------------------------------------------------------------------#>
function New-PSAzureSQLServer ()
{
<#
  .SYNOPSIS
  Create a new AzureSQL SQL Server.

  .DESCRIPTION
  Checks to see if an AzureSQL SQL Server already exists for the name passed
  in. If not, it will create a new AzureSQL SQL Server. 

  .PARAMETER ServerName
  The name of the server to create.

  .PARAMETER ResourceGroupName
  The name of the resource group to create the AzureSQL SQL Server in.

  .PARAMETER Location
  The geographic location to place the server in (southcentralus, etc)

  .PARAMETER UserName
  The name to use as the administrator user

  .PARAMETER Password
  The password to associate with the administrator user

  .INPUTS
  System.String

  .OUTPUTS
  A new AzureSQL SQL Server

  .EXAMPLE
  New-PSAzureSQLServer -ServerName 'MySQLServer' `
                       -ResourceGroupName 'ArcaneRG' `
                       -Location 'southcentralus' `
                       -UserName 'ArcaneCode' `
                       -Password 'mypasswordgoeshere'

  .NOTES
  Author: Davide Spano
#>

  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The name of the SQL Server to create'
                   )
         ]
         [string]$ServerName 
       , [Parameter( Mandatory=$true
                   , HelpMessage='The resource group to put the SQL Server in'
                   )
         ]
         [string]$ResourceGroupName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The name of the geographic location to create the server in'
                   )
         ]
         [string]$Location
       , [Parameter( Mandatory=$true
                   , HelpMessage='The user name for the administrator of the SQL Server'
                   )
         ]
         [string]$UserName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The password for the administrator of the SQL Server'
                   )
         ]
         [string]$Password
       )

  $fn = 'New-PSAzureSQLServer:'
  Write-Verbose "$fn Checking for SQL Server $ServerName"
  $exists = Get-AzureRmSqlServer | Where-Object ServerName -eq $serverName

  # If the server doesn't exist, create it.
  if ($exists -eq $null)
  {   
    # Generate a credential object for use with the server
    $passwordSecure = $Password | ConvertTo-SecureString -AsPlainText -Force
    $cred = New-Object PSCredential ($username, $passwordSecure)
  
    # Now create the server
    Write-Verbose "$fn Creating the SQL Server $serverName"
    New-AzureRmSqlServer -ResourceGroupName $resourceGroupName `
                         -ServerName $serverName `
                         -Location $location `
                         -SqlAdministratorCredentials $cred
  }

}
#endregion New-PSAzureSQLServer

#region New-PSAzureSQLServerFirewallRule
<#---------------------------------------------------------------------------#>
<# New-PSAzureSQLServerFirewallRule                                          #>
<#---------------------------------------------------------------------------#>
function New-PSAzureSQLServerFirewallRule ()
{
<#
  .SYNOPSIS
  Create a new firewall on an existing AzureSQL SQL Server.

  .DESCRIPTION
  Checks to see if the passed in name for the firewall on the specified 
  AzureSQL SQL Server already exists. If not, it will create the firewall 
  using the supplied parameters. 

  .PARAMETER ServerName
  The name of the server to apply the firewall rule to.

  .PARAMETER ResourceGroupName
  The name of the resource group containing the AzureSQL SQL Server

  .PARAMETER FirewallRuleName
  The name to give to this firewall rule

  .PARAMETER StartIpAddress
  The beginning IP address to open up

  .PARAMETER EndIpAddress
  The last IP address to open up

  .INPUTS
  System.String

  .OUTPUTS
  A new firewall rule

  .EXAMPLE
  New-PSAzureSQLServerFirewallRule -ServerName 'MySQLServer' `
                                   -ResourceGroupName 'ArcaneRG' `
                                   -FirewallRuleName 'myfirewallrule' `
                                   -StartIpAddress '192.168.0.1' `
                                   -EndIpAddress '192.168.1.255'

  .NOTES
  Author: Davide Spano
#>

  [cmdletbinding()]
  param(
         [Parameter( Mandatory=$true
                   , HelpMessage='The name of the SQL Server to create the rule for'
                   )
         ]
         [string]$ServerName 
       , [Parameter( Mandatory=$true
                   , HelpMessage='The resource group holding the SQL Server'
                   )
         ]
         [string]$ResourceGroupName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The name of the firewall rule to create'
                   )
         ]
         [string]$FirewallRuleName
       , [Parameter( Mandatory=$true
                   , HelpMessage='The beginning IP Address this rule applies to'
                   )
         ]
         [string]$StartIpAddress
       , [Parameter( Mandatory=$true
                   , HelpMessage='The ending IP Address this rule applies to'
                   )
         ]
         [string]$EndIpAddress
       )

  $fn = 'New-PSAzureSQLServerFirewallRule:'

  Write-Verbose "$fn Checking for Firewall Rule $FirewallRuleName"
  $exists = Get-AzureRmSqlServerFirewallRule `
              -ResourceGroupName $ResourceGroupName `
              -ServerName $Servername `
              -FirewallRuleName $FirewallRuleName `
              -ErrorAction SilentlyContinue
  

  # If not found, create it
  if ($exists -eq $null)
  { 
    Write-Verbose "$fn Creating Firewall Rule $FirewallRuleName"
    New-AzureRmSqlServerFirewallRule `
       -ResourceGroupName $ResourceGroupName `
       -ServerName $Servername `
       -FirewallRuleName $FirewallRuleName `
       -StartIpAddress $StartIpAddress `
       -EndIpAddress $EndIpAddress
  }
  
}
#endregion New-PSAzureSQLServerFirewallRule