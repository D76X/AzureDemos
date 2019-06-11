using System;
using System.Configuration;
using System.Net.Http;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using Microsoft.Azure.KeyVault;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace _02KeyVaultApp
{
    class Program
    {
        // the ID assigned to this app when registered an Azure ID
        // In this version of teh app the is no secret as the app authenticate
        // on Azure AD by means of a certificate installed on the client machine
        // therefore avoiding any client secret exchange and the need to protect
        // the secret locally. You still have the thumbprint of the certificate
        // in the config file but that is NOT sensitive information as it is a 
        // mear hash of the certificate and cannot be used by attackers.
        private static string AppId;
        private static string PfxThumbprint;

        // the URI to the Azure Key Vault that holds the Secret, Key or Certificate
        // that the application needs to retrieve
        private static string VaultResourceUri;

        static async Task Main(string[] args)
        {
            Console.WriteLine($"Start Application {System.Reflection.Assembly.GetExecutingAssembly().GetName().Name} and get key vault values");
            
            string config_aad_appId = ConfigurationManager.AppSettings["aad_appId"];
            string config_pfxthumbprint = ConfigurationManager.AppSettings["pfxthumbprint"];
            string config_kv_secret_uri = ConfigurationManager.AppSettings["kv_secret_uri"];
            string config_kv_secret_uri_versioned = ConfigurationManager.AppSettings["kv_secret_uri_versioned"];
            string config_kv_dnsname = ConfigurationManager.AppSettings["kv_dnsname"];

            Console.WriteLine();
            Console.WriteLine($"{nameof(config_aad_appId)}={config_aad_appId}");
            Console.WriteLine($"{nameof(config_pfxthumbprint)}={config_pfxthumbprint}");
            Console.WriteLine($"{nameof(config_kv_secret_uri)}={config_kv_secret_uri}");
            Console.WriteLine($"{nameof(config_kv_secret_uri_versioned)}={config_kv_secret_uri_versioned}");
            Console.WriteLine($"{nameof(config_kv_dnsname)}={config_kv_dnsname}");
            Console.WriteLine();

            AppId = config_aad_appId;
            PfxThumbprint = config_pfxthumbprint;
            VaultResourceUri = config_kv_secret_uri;

            var secret = await GetSecretAsync(secretUri: VaultResourceUri);
            Console.WriteLine($"{nameof(secret)}={secret}");
            Console.WriteLine();

            Console.WriteLine("Press any key to exit.");
            Console.ReadKey();
        }

        // https://stackoverflow.com/questions/47875589/cant-access-azure-key-vault-from-desktop-console-app
        private static async Task<string> GetSecretAsync(string secretUri)
        {
            var client = new KeyVaultClient(
                authenticationCallback: new KeyVaultClient.AuthenticationCallback(GetAccessTokenAsync),
                httpClient: new HttpClient());

            var secret = await client.GetSecretAsync(secretIdentifier: secretUri);

            return secret.Value;
        }

        /// <summary>
        /// Retrieves a x509 from the local store if any installed certificates
        /// matches the given thumbprint.
        /// </summary>
        /// <param name="pfxthumbprint">the thumbprint of a PFX</param>
        /// <returns></returns>
        private static X509Certificate2 GetCertificate(string pfxthumbprint)
        {
            X509Store certStore = new X509Store(StoreName.My, StoreLocation.CurrentUser);
            certStore.Open(OpenFlags.ReadOnly);
            X509Certificate2Collection certCollection = certStore.Certificates.Find(
                                 X509FindType.FindByThumbprint,                                 
                                 pfxthumbprint,
                                 false);
            X509Certificate2 cert = certCollection[0];
            Console.WriteLine($"certificate name = {cert.FriendlyName}");
            Console.WriteLine();
            certStore.Close();
            return cert;
        }

        /// <summary>
        /// Authenticates with Azure AD and retrieves an access token 
        /// for the resource that this application needs to access.
        /// </summary>        
        private static async Task<string> GetAccessTokenAsync(
            string authority,
            string resource,
            string scope)
        {
            var pfxCertificate = GetCertificate(PfxThumbprint);

            var clientAssertionCertificate = new ClientAssertionCertificate(
                clientId: AppId,
                certificate: pfxCertificate);

            var autheticationContext = new AuthenticationContext(authority, TokenCache.DefaultShared);

            var result = await autheticationContext.AcquireTokenAsync(
                resource: resource, 
                clientCertificate: clientAssertionCertificate);

            var accessToken = result.AccessToken;
            Console.WriteLine($"{nameof(accessToken)}={accessToken}");
            Console.WriteLine();
            return result.AccessToken;
        }
    }
}
