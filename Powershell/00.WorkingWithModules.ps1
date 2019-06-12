# Refs
# https://docs.microsoft.com/en-us/powershell/module/powershellget/install-module?view=powershell-6
# https://docs.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule?view=powershell-6

# Downloads one or more modules from a repository, and installs them on the local computer.
Install-Module 'Az.Compute' -AllowClobber
Import-Module 'Az.Compute'

# Gets the modules that have been imported or that can be imported into the current session.
Get-Module

# Gets installed modules on a computer.
Get-InstalledModule

# Check for installed versions
Get-InstalledModule -Name AzureRM -AllVersions

# ------------------------
# Uninstall a module
# Uninstall-AzureRm
# Uninstall-AllModules
# ------------------------

# Removes modules from the current session.
Remove-Module -Name AzureRM

# Remove all modules
Get-Module | Remove-Module
Remove-Module -Name AzureRM.Profile
Remove-Module -Name AzureRM.KeyVault
Remove-Module -Name AzureRM.Resources
Remove-Module -Name AzureRM.Websites
Get-Module

# ------------------------------------------------------------------
# Example of workflow 1

# Ref https://www.powershellgallery.com/packages/Az.Websites/1.0.0
# Need the module 'Az.Websites' for the cmdlet Set-AzWebApp
# First must remove some modules from the current session.
# AzureRM.XXX as these have conflicting cmdltes then you can 
# istall the Az.Websites and load it into teh session
# Then load 

Remove-Module -Name AzureRM.Profile
Remove-Module -Name AzureRM.KeyVault
Remove-Module -Name AzureRM.Resources
Remove-Module -Name AzureRM.Websites

Get-Module

Install-Module -Name Az.Websites -RequiredVersion 1.0.0

Import-Module 'Az.Websites'

Get-Module
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# Example of workflow 2

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
# ------------------------------------------------------------------