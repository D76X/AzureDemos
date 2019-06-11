using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.SqlServer.Management.AlwaysEncrypted.AzureKeyVaultProvider;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

namespace _01AlwaysEncryptedApp
{
    class Program
    {
        private static string AppId;
        private static string PfxThumbprint;
        private static string AccessToken;

        static async Task Main(string[] args)
        {
            Console.WriteLine($"Start Application {System.Reflection.Assembly.GetExecutingAssembly().GetName().Name} and get key vault values");

            string config_aad_appId = ConfigurationManager.AppSettings["aad_appId"];
            string config_pfxthumbprint = ConfigurationManager.AppSettings["pfxthumbprint"];
            string config_kv_dnsname = ConfigurationManager.AppSettings["kv_dnsname"];
            string connectionString = ConfigurationManager.AppSettings["connectionString"];
            
            Console.WriteLine();

            Console.WriteLine();
            Console.WriteLine($"{nameof(config_aad_appId)}={config_aad_appId}");
            Console.WriteLine($"{nameof(config_pfxthumbprint)}={config_pfxthumbprint}");
            Console.WriteLine($"{nameof(config_kv_dnsname)}={config_kv_dnsname}");
            Console.WriteLine($"{nameof(connectionString)}={connectionString}");
            Console.WriteLine();

            AppId = config_aad_appId;
            PfxThumbprint = config_pfxthumbprint;

            SetUpAdoNetEncryption();            
            
            var results = ReadData(connectionString);
            results.ToList().ForEach(Console.WriteLine);
            Console.WriteLine();

            Console.WriteLine("Press any key to exit.");
            Console.ReadKey();
        }

        /// <summary>
        /// Set up ADO to authenticate to Azure AD and retrieve the 
        /// Column Master Key (CMK) from a Key Vault as set up in the
        /// App.Config. Then ADO will be able to use the CMK to decript
        /// read from the Key Vault to decrypt the column Encryption Key (CEK) 
        /// that is an encrypted key stored in the database itself and returned 
        /// to teh app with the query for which the CMK is the decryption key.
        /// Once ADO can unwrap the CEK by means of the CMK then it can use the
        /// decrypted CEK to decrypt the data read from the database and viceversa
        /// encrypt the data sent to it.
        /// </summary>
        private static void SetUpAdoNetEncryption()
        {            
            var azEncryptionKeyVaultProvider = new SqlColumnEncryptionAzureKeyVaultProvider(GetAccessTokenAsync);
            var providers = new Dictionary<string, SqlColumnEncryptionKeyStoreProvider>();
            providers.Add(SqlColumnEncryptionAzureKeyVaultProvider.ProviderName, azEncryptionKeyVaultProvider);
            SqlConnection.RegisterColumnEncryptionKeyStoreProviders(providers);
            Console.WriteLine($"providers = {providers.Count}");
            Console.WriteLine();
        }

        private static IEnumerable<object> ReadData(string connectionString)
        {
            var result = new List<object>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand("SELECT * FROM People", connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                result.Add(reader.GetValue(i));
                            }
                            result.Add(string.Empty);
                        }
                    }
                }
            }

            return result;
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
            SetAccessToken(accessToken);
            //Console.WriteLine($"{nameof(accessToken)}={accessToken}");
            //Console.WriteLine();
            return result.AccessToken;
        }

        private static void SetAccessToken(string accessToken)
        {
            if (string.IsNullOrEmpty(AccessToken))
            {
                AccessToken = accessToken;
                Console.WriteLine($"{nameof(AccessToken)}={AccessToken}");
                Console.WriteLine();
                return;
            }
            else if(AccessToken != accessToken)
            {
                throw new InvalidOperationException("why new access token?");
            }            
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
    }
}
