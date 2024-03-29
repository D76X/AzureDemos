# Generated by SQL Server Management Studio at 2:39 PM on 5/5/2019

Import-Module SqlServer
# Set up connection and database SMO objects

$password = "<replace with your password>"
$sqlConnectionString = "Data Source=wppres1sqlserver1.database.windows.net;Initial Catalog=wppres1db1;User ID=dspano;Password=$password;MultipleActiveResultSets=False;Connect Timeout=30;Encrypt=True;TrustServerCertificate=False;Packet Size=4096;Application Name=`"Microsoft SQL Server Management Studio`""
$smoDatabase = Get-SqlDatabase -ConnectionString $sqlConnectionString

# If your encryption changes involve keys in Azure Key Vault, uncomment one of the lines below in order to authenticate:
#   * Prompt for a username and password:
#Add-SqlAzureAuthenticationContext -Interactive

#   * Enter a Client ID, Secret, and Tenant ID:
#Add-SqlAzureAuthenticationContext -ClientID '<Client ID>' -Secret '<Secret>' -Tenant '<Tenant ID>'

# Change encryption schema

$encryptionChanges = @()

# Add changes for table [dbo].[People]
$encryptionChanges += New-SqlColumnEncryptionSettings -ColumnName dbo.People.SSNE -EncryptionType Deterministic -EncryptionKey "CEK_Auto1"

Set-SqlColumnEncryption -ColumnEncryptionSettings $encryptionChanges -InputObject $smoDatabase

