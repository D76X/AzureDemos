
#-------------------------------------------------------------------------------------------------------
# This prompts for the password that protects the certificate
$certificateFilePath = "C:\GitHub\WPPresentation\Certificates\02KeyVaultApp.pfx"
Get-PfxCertificate $certificateFilePath
#-------------------------------------------------------------------------------------------------------
<#
Thumbprint                                Subject                              
----------                                -------                              
792F7A2662626C57073A5748386D19D1037368EF  CN=02KeyVaultApp
#>
#-------------------------------------------------------------------------------------------------------