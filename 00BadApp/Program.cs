using System;
using System.Configuration;
using System.Data.SqlClient;

namespace _00BadApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine($"Start Application {System.Reflection.Assembly.GetExecutingAssembly().GetName().Name} and get key vault values");

            string config_aad_appId = ConfigurationManager.AppSettings["aad_appId"];
            string config_pfxthumbprint = ConfigurationManager.AppSettings["pfxthumbprint"];
            string config_kv_secret_uri = ConfigurationManager.AppSettings["kv_secret_uri"];
            string config_kv_secret_uri_versioned = ConfigurationManager.AppSettings["kv_secret_uri_versioned"];
            string config_kv_dnsname = ConfigurationManager.AppSettings["kv_dnsname"];

            string connectionString = ConfigurationManager.AppSettings["connectionString"];
            Console.WriteLine($"{nameof(connectionString)}={connectionString}");
            Console.WriteLine();

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
                                Console.WriteLine(reader.GetValue(i));
                            }
                            Console.WriteLine();
                        }
                    }
                }
            }

            Console.WriteLine();
            Console.WriteLine("Press any key to exit.");
            Console.ReadKey();
        }
    }
}
