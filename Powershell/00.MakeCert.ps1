# In Visual Studio Developer Command Propmpt 
makecert -!

#-------------------------------------------------------------------------------------------------------
<#
**********************************************************************
** Visual Studio 2017 Developer Command Prompt v15.9.4
** Copyright (c) 2017 Microsoft Corporation
**********************************************************************

C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional>makecert -!
Usage: MakeCert [ basic|extended options] [outputCertificateFile]
Extended Options
 -tbs <file>         Certificate or CRL file to be signed
 -sc  <file>         Subject's certificate file
 -sv  <pvkFile>      Subject's PVK file; To be created if not present
 -ic  <file>         Issuer's certificate file
 -ik  <keyName>      Issuer's key container name
 -iv  <pvkFile>      Issuer's PVK file
 -is  <store>        Issuer's certificate store name.
 -ir  <location>     Issuer's certificate store location
                        <CurrentUser|LocalMachine>.  Default to 'CurrentUser'
 -in  <name>         Issuer's certificate common name.(eg: Fred Dews)
 -a   <algorithm>    The signature's digest algorithm.
                        <md5|sha1|sha256|sha384|sha512>.  Default to 'sha1'
 -ip  <provider>     Issuer's CryptoAPI provider's name
 -iy  <type>         Issuer's CryptoAPI provider's type
 -sp  <provider>     Subject's CryptoAPI provider's name
 -sy  <type>         Subject's CryptoAPI provider's type
 -iky <keytype>      Issuer key type
                        <signature|exchange|<integer>>.
 -sky <keytype>      Subject key type
                        <signature|exchange|<integer>>.
 -l   <link>         Link to the policy information (such as a URL)
 -cy  <certType>     Certificate types
                        <end|authority>
 -b   <mm/dd/yyyy>   Start of the validity period; default to now.
 -m   <number>       The number of months for the cert validity period
 -e   <mm/dd/yyyy>   End of validity period; defaults to 2039
 -h   <number>       Max height of the tree below this cert
 -len <number>       Generated Key Length (Bits)
                        Default to '2048' for 'RSA' and '512' for 'DSS'
 -r                  Create a self signed certificate
 -nscp               Include Netscape client auth extension
 -crl                Generate a CRL instead of a certificate
 -eku <oid[<,oid>]>  Comma separated enhanced key usage OIDs
 -?                  Return a list of basic options
 -!                  Return a list of extended options
#>


#-------------------------------------------------------------------------------------------------------
# There are three parts to a certificate
#CER: Contains the public part of the certificate and usually distributed outside.
#PVK: Contains the Private key and securely stored
#PFX: Usually has public, private keys, other certificate chains and password protected.
#-------------------------------------------------------------------------------------------------------
# This command prompts for teh psw to secure the private key file
makecert -sv MyPrivateKey.pvk -n "cn=CertificateSubject" MyPublicKey.cer -b 05/04/2018 -e 05/04/2020 -r
# This command puts the CER and PVK together
pvk2pfx -pvk MyPrivateKey.pvk -spc MyPublicKey.cer -pfx MyCertificate.pfx -po password 
#-------------------------------------------------------------------------------------------------------


#-------------------------------------------------------------------------------------------------------
# Create a certificate for the 02KeyVaultApp Demo
# This command prompts for teh psw to secure the private key file
makecert -sv 02KeyVaultApp.pvk -n "cn=02KeyVaultApp" 02KeyVaultApp.cer -b 05/04/2019 -e 05/04/2020 -r
# This command puts the CER and PVK together
pvk2pfx -pvk 02KeyVaultApp.pvk -spc 02KeyVaultApp.cer -pfx 02KeyVaultApp.pfx -po password 
#-------------------------------------------------------------------------------------------------------