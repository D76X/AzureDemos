
---

## NuGet Packages 

The projects in this solution make use of the following nuget packages which must be installed in each project that needs them.

- Microsoft.Azure.KeyVault
- Microsoft.IdentityModel.Client.ActivaeDirectory (ADAL)
- Microsoft.SqlServer.Management.AlwaysEncrypted.AzureKeyVaultProvider
- Microsoft.Azure.Services.AppAuthentication
- Microsoft.SqlServer.Management.AlwaysEncrypted.AzureKeyVault

---

## Assembly References

The following assembly references may have been used. 

- System.Configuration

---

## C# 7.x Language Features

Some of the console applications in this solution make use of some of the C# language features available only for version of the language starting from 7.1. i.e. the **async main** entry method. 

When a new console application based on the full .Net Framework is added to the solution from the Visual Studio preinstalled project template the default language feature might be set to a version preceding C# 7.1 and if any of the later language features are employed in the code the compiler might fail and issue corresponding warning. 

**In order to change the language version for a project do the the following**.

1. Select the project in the Solution Explorer and then properties.
2. In the build tab click on the **Advanced...** button.
3. Ser the **Language version** to the required level.

---

## Some References 

https://damienbod.com/2019/02/07/using-azure-key-vault-from-an-non-azure-app/  
https://blog.bitscry.com/2019/02/13/using-azure-key-vault-in-a-console-application/  
https://azurecto.com/azure-keyvault-authenticating-with-certificates-and-reading-secrets/  
https://stackoverflow.com/questions/47875589/cant-access-azure-key-vault-from-desktop-console-app  
https://docs.microsoft.com/en-us/azure/key-vault/tutorial-net-create-vault-azure-web-app  
https://github.com/damienbod/AspNetCoreBackChannelLogout/blob/master/ConsoleStandaloneUsingAzureSecrets/Program.cs
https://docs.microsoft.com/en-us/azure/key-vault/tutorial-net-create-vault-azure-web-app  

----------------------------------------------------------------------------------------


Application Registration

https://damienbod.com/2019/02/07/using-azure-key-vault-from-an-non-azure-app/
https://stackoverflow.com/questions/47875589/cant-access-azure-key-vault-from-desktop-console-app
01KeyVaultApp
Application(client) ID: 3da2ec55-4670-4e30-b7f2-6c4a29ec9a3f
Directory(tenant) ID : 981b07d1-b261-4c3e-a400-b86f7809d9bc
Object ID : 2458fef3-3247-4fb2-a3ab-e144b93d1818
Supported account types : My organization only
Redirect URIs :Add a Redirect URI
Managed application in local directory :01KeyVaultApp
--------------------------------------------------------------------------------------
https://damienbod.com/2019/02/07/using-azure-key-vault-from-an-non-azure-app/
Now a secret for the AAD Application registration needs to be created.
Click the Certificates & secrets button, and then New client secret.
Store the client secret!
/nKN++8?2m2LUUTdWva5bwcZHR__slTr
/nKN++8?2m2LUUTdWva5bwcZHR__slTr
--------------------------------------------------------------------------------------
Secrets vs Certificates for Client App Registration
Credentials enable applications to identify themselves to the authentication service when receiving tokens at a web addressable location(using an HTTPS scheme).
For a higher level of assurance, we recommend using a certificate(instead of a client secret) as a credential.
//--------------------------------------------------------------------------------------
Configure the Azure Key Vault to allow the Azure AD Application
In the Azure Key Vault, the Application registration needs to be given access rights.
Open the Key Vault, and click the Access policies. Then click the Add new button.
Select the AAD Application registration principle which was created before. 
You can find this, by entering the name of the app 01KeyVaultApp. 
--------------------------------------------------------------------------------------
Now configure the application to use the Key Vault.
--------------------------------------------------------------------------------------

https://www.rahulpnath.com/blog/pfx-certificate-in-azure-key-vault/
//Client
//byte[] encryptedData;
//You can also use the PFX here as it contains the private key
//var publicCertificate = new X509Certificate2(@"C:\CertificateKey.cer"); 
//using (var cryptoProvider = publicCertificate.PublicKey.Key as RSACryptoServiceProvider)
//{
//var byteData = Encoding.Unicode.GetBytes(textToEncrypt);
//encryptedData = cryptoProvider.Encrypt(byteData, true);
//}

////Server
//var privateCertificate = new X509Certificate2(@"C:\CertificateKey.pfx", "test");
//using (var cryptoProvider = privateCertificate.PrivateKey as RSACryptoServiceProvider)
//{
//var decryptedData = cryptoProvider.Decrypt(encryptedData, true);
//var decryptedText = Encoding.Unicode.GetString(decryptedData);
//}
//-----------------
//var keyIdentifier = "https://rahulkeyvault.vault.azure.net:443/keys/KeyFromCert/";

//Client Remains the same or use the Key Vault Client
//var encryptedResult = await keyClient.EncryptAsync(keyIdentifier, "RSA-OAEP", byteData);

//Server
//var decryptedData = await keyClient.DecryptAsync(keyIdentifier, "RSA-OAEP", certED);
//var decryptedText = Encoding.Unicode.GetString(decryptedData.Result);
//-------------
//var secretRetrieved = await keyClient.GetSecretAsync(secretIdentifier);
//var pfxBytes = Convert.FromBase64String(secretRetrieved.Value);
//File.WriteAllBytes(@"C:\cert\ADTestVaultApplicationNew.pfx", pfxBytes);

//or recreate the certificate directly
//var certificate = new X509Certificate2(pfxBytes);