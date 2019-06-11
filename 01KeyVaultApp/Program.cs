using System;
using System.Configuration;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.KeyVault;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace _01KeyVaultApp
{
    class Program
    {
        // the ID assigned to this app when registered an Azure ID
        private static string AppId;
        // a secret that was created on Azure ID when the application
        // was registered - this can be revoked!
        private static string ClientSecret;

        // the URI to the Azure Key Vault that holds the Secret, Key or Certificate
        // that the application needs to retrieve
        private static string VaultResourceUri;        

        static async Task Main(string[] args)
        {
            Console.WriteLine($"Start Application {System.Reflection.Assembly.GetExecutingAssembly().GetName().Name} and get key vault values");

            string config_aad_appId = ConfigurationManager.AppSettings["aad_appId"];
            string config_aad_clientsecret = ConfigurationManager.AppSettings["aad_clientsecret"];
            string config_kv_secret_uri = ConfigurationManager.AppSettings["kv_secret_uri"];
            string config_kv_secret_uri_versioned = ConfigurationManager.AppSettings["kv_secret_uri_versioned"];
            string config_kv_dnsname = ConfigurationManager.AppSettings["kv_dnsname"];

            Console.WriteLine();
            Console.WriteLine($"{nameof(config_aad_appId)}={config_aad_appId}");
            Console.WriteLine($"{nameof(config_aad_clientsecret)}={config_aad_clientsecret}");
            Console.WriteLine($"{nameof(config_kv_secret_uri)}={config_kv_secret_uri}");
            Console.WriteLine($"{nameof(config_kv_secret_uri_versioned)}={config_kv_secret_uri_versioned}");
            Console.WriteLine($"{nameof(config_kv_dnsname)}={config_kv_dnsname}");
            Console.WriteLine();

            AppId = config_aad_appId;
            ClientSecret = config_aad_clientsecret;
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
        /// Authenticates with Azure AD and retrieves an access token 
        /// for the resource that this application needs to access.
        /// </summary>        
        private static async Task<string> GetAccessTokenAsync(
            string authority, 
            string resource, 
            string scope)
        {            
            var appClientCredentials = new ClientCredential(
                clientId: AppId, 
                clientSecret: ClientSecret);

            var autheticationContext = new AuthenticationContext(authority, TokenCache.DefaultShared);
            var result = await autheticationContext.AcquireTokenAsync(resource, appClientCredentials);
            var accessToken = result.AccessToken;
            Console.WriteLine($"{nameof(accessToken)}={accessToken}");
            Console.WriteLine();
            return result.AccessToken;
        }               
    }
}
