# --------------------------------------------------------------------------------------------------------------------------
# http://tritoneco.com/2014/02/21/fix-for-powershell-script-not-digitally-signed/
Set-ExecutionPolicy -ExecutionPolicy ByPass -Scope Process
# --------------------------------------------------------------------------------------------------------------------------
# Refs
# https://docs.microsoft.com/en-us/azure/marketplace/cloud-partner-portal/virtual-machine/cpp-create-key-vault-cert
# https://www.rahulpnath.com/blog/pfx-certificate-in-azure-key-vault/
# https://medium.com/the-new-control-plane/generating-self-signed-certificates-on-windows-7812a600c2d8
# https://www.pluralsight.com/blog/software-development/selfcert-create-a-self-signed-certificate-interactively-gui-or-programmatically-in-net
# https://docs.microsoft.com/en-us/powershell/module/pkiclient/new-selfsignedcertificate?view=win10-ps 
# https://www.youtube.com/watch?v=Y0pN0rN8MEM

# Certification creation script 

#--------------------------------------------------------------------------------------------
# CER: Contains the public part of the certificate and usually distributed outside.
# PVK: Contains the Private key and securely stored
# PFX: Usually has public, private keys, other certificate chains and password protected.
#--------------------------------------------------------------------------------------------
    
# pfx certification stored path
$certroopath = "C:\CertLocation" 
$certname = "wuerthphxpres1.onmicrosoft.com" 
$certpassword = "password"
# --------------------------------------------------------------------------------------------------------------------------
# https://github.com/AzureAD/azure-activedirectory-library-for-dotnet/issues/650 << Issue with the self-signed pfx
# -KeySpec Signature
# -------------------------------------------------------------------------------------------------------------------------- 
$cert=New-SelfSignedCertificate -DnsName "$certname" -CertStoreLocation cert:\LocalMachine\My -KeySpec Signature
$pwd = ConvertTo-SecureString -String $certpassword -Force -AsPlainText
$certwithThumb="cert:\localMachine\my\"+$cert.Thumbprint
$filepath="$certroopath\$certname.pfx"
Export-PfxCertificate -cert $certwithThumb -FilePath $filepath -Password $pwd
Remove-Item -Path $certwithThumb 
