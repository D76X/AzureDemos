# Register an application in Azure AD with a certificate associated to it.
# The certificate is created on the client machine.
# The public key of the certificate is passed to Azure AD for that Application ID at the time of registration.
# Any client machine that holds the corresponding private key for the certificate can now authenticate using it.
# This removes the produce a client secret on Azure AD and to have to exchange it at runtime!
# The application

#-------------------------------------------------------------------------------------------------------
Login-AzureRmAccount
#-------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------------------------
# Setting up

# Must run as Admin

# Must log in some account
Connect-AzureRmAccount

# Find the subscriptions forthe account you are logged on
Get-AzureRmSubscription

# https://stackoverflow.com/questions/34928451/how-to-find-the-current-azure-rm-subscription
# https://blogs.msdn.microsoft.com/benjaminperkins/2017/08/02/how-to-set-azure-powershell-to-a-specific-azure-subscription/
Get-AzureRmContext
(Get-AzureRmContext).Subscription
Set-AzureRmContext -SubscriptionId "df17c9fe-de76-4143-bbae-77b75fa0705b"

#--------------------------------------------------------------------------------------

# Certification creation script 

#--------------------------------------------------------------------------------------------
# CER: Contains the public part of the certificate and usually distributed outside.
# PVK: Contains the Private key and securely stored
# PFX: Usually has public, private keys, other certificate chains and password protected.
#--------------------------------------------------------------------------------------------
   
# This does not work for some reason!
# It fails to produce 
# extract the info you need from the certificate files that you have created 
# on the client machine
#$certificateFilePath = "C:\GitHub\WPPresentation\Certificates\02KeyVaultApp.cer"
$certificateFilePath = "C:\GitHub\WPPresentation\Certificates\02KeyVaultApp.pfx"
$certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$KeyStorageFlags = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet
$certificate.Import($certificateFilePath,$pwd,$KeyStorageFlags)
$rawCertificateData = $certificate.GetRawCertData()
$credential = [System.Convert]::ToBase64String($rawCertificateData)
$startDate = $certificate.GetEffectiveDateString()
$endDate = $certificate.GetExpirationDateString()
$validTo = [datetime]::Parse($certificate.GetExpirationDateString())
$credential
$startDate
$endDate
$validTo

#-------------------------------------------------------------------------------------------------------
# https://docs.microsoft.com/en-us/powershell/module/azurerm.resources/new-azurermadapplication?view=azurermps-6.13.0

# =================================================================
# WARNING !
# There are problems when using this New-AzureRmADApplication cmd
# to upload a CER file for authentication to be used by an application.
# The problem lies with the cmdlet not being able to correctly read
# the dates in the certificate due to localization problems.
# This seems to be a documented and recurrent problem and requires
# further investigation.
# As a workaround use the portal and upload the CER file created 
# by the makecert utility to it.
# =================================================================

# create an Application ID on Azure AD and pass to it the PK of the certificate
# as a means to authentication.
# The application may or may not a web application.
# It might be a console application in which case -HomePage and 
$appName = "02KeyVaultApp"
$SecureStringPassword = ConvertTo-SecureString -String "password" -AsPlainText -Force
New-AzureRmADApplication -DisplayName $appName -CertValue $credential -HomePage "http://www.somedomain.com/02KeyVaultApp" -IdentifierUris "http://www.somedomain.com/02KeyVaultApp/id4"
# -StartDate $startDate -EndDate $endDate
#-Password $SecureStringPassword
# -HomePage "http://www.somedomain.com/02KeyVaultApp" -IdentifierUris "http://www.somedomain.com/02KeyVaultApp/id2"
#-------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------

# Set the access policy for the new application
# This process makes a specific Azure Key Vault asset determine which access claim
# an application registered on the same Azure AD Directory can have on its Secrets
# Keys and Certificates.

# Frist a Service Principla is required
# AD Service Pricipal

$appName = "02KeyVaultApp"
Get-AzureADApplication -All:$true `
| Select-Object -Property ObjectType, ObjectID, AppID ,DisplayName `
| Format-List

Get-AzureADApplication -All:$true | Where-Object -Property DisplayName -eq $appName | Format-List

$appId = Get-AzureADApplication -All:$true `
| Where-Object -Property DisplayName -eq $appName `
| Select-Object AppId

$appId

# $servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId $adApplication.ApplicationId 
$servicePrincipal = New-AzureRmADServicePrincipal -ApplicationId "b44936d4-0231-44e0-93b2-c92fc46b09b5"
$servicePrincipal = (Get-AzureRmADServicePrincipal | Where-Object ApplicationId -EQ "b44936d4-0231-44e0-93b2-c92fc46b09b5")[0]
<#
ServicePrincipalNames : {b44936d4-0231-44e0-93b2-c92fc46b09b5}
ApplicationId         : b44936d4-0231-44e0-93b2-c92fc46b09b5
DisplayName           : 02KeyVaultApp
Id                    : bc927c17-0b92-4eae-8437-b8934d93f833
Type                  : ServicePrincipal
#>
$servicePrincipalId = $servicePrincipal.Id
$servicePrincipalId 
$servicePrincipal.ApplicationId

# Once the Service Principla is known then it is possible to set the policy
# This sets the access policy of the the client application to teh key vault
# the "all" causes a warning obviously and should not be used in production
$rgname = "wppres1rg1"
$kvname = "wppres1kv1"
Set-AzureRmKeyVaultAccessPolicy `
-ResourceGroupName $rgname `
-VaultName $kvname `
-ObjectID $servicePrincipalId `
-PermissionsToKeys all `
-PermissionsToSecrets all  
#-------------------------------------------------------------------------------------------------------
