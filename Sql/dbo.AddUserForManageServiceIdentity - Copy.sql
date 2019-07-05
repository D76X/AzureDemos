--Refs
--When you want to allow a MSI to access an Azure DB you must create a login on 
--the database with the MSI in order for that MSI to be able to get to the DB
--you can run this query directly in the portal on the database fo interest using
--the Query Editor blade.

--Examples
CREATE USER "msi-of-a-vm-from-azure" FROM EXTERNAL PROVIDER
CREATE USER "msi-of-an-azure-function-from-azure" FROM EXTERNAL PROVIDER
CREATE USER "msi-of-an-azure-ARTIFACT-from-azure" FROM EXTERNAL PROVIDER



--After the login for the external provider has been created you must
--assign some meaningful roles to it in order to let the MSI perform the
--work it needs on the DB i.e.

--Examples
ALTER ROLE db_datareader ADD MEMBER "msi-of-an-azure-ARTIFACT-from-azure"

--If you are trying to access a Azure SQL DB from an AppService or Azure Fuction
--you would need to use some libraries to authenticate the AppService or Azure
--Function by means of its MSI to the Azure DB.

--In an AppService
using System.Data.SqlClient;
using Microsoft.Azure.Services.AppAuthentication;

--In a function App
--add a function.proj file to the FunctionApp

<Project Sdk="Microsoft.NET.Sdk">
<PropertyGroup>
    <TargetFramework>netstandard2.0</TargetFramework>
  </PropertyGroup>
 
  <ItemGroup>
    <PackageReference Include="Microsoft.Azure.Services.AppAuthentication" Version="1.2.0-preview"/>
    <PackageReference Include="Microsoft.Azure.KeyVault" Version="3.0.2"/>
    <PackageReference Include="System.Data.SqlClient" Version="?.?.?"/>
  </ItemGroup>
 
</Project>


--Some sample code for the Function App Basics
var azureServiceTokenProvider = new AzureServiceTokenpProvider();
--The global end point for Azure SQL DBs "https%3A%2F%2Fdatabase.windows.net%2F"
var accessToken = await azureServiceTokenProvider.GetAccessToken("https%3A%2F%2Fdatabase.windows.net%2F");


--More complete
using System;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Azure.Services.AppAuthentication;

namespace ConsoleApp1Test1
{
    class Program
    {
        static async Task Main(string[] args)
        {

            var azureServiceTokenProvider = new AzureServiceTokenProvider();
            

            var accessToken = await azureServiceTokenProvider.GetAccessTokenAsync("https%3A%2F%2Fdatabase.windows.net%2F");


            Console.WriteLine(accessToken);

	    --Notice that this is a MSI style configuration string so it's safe in Function App
	    --but you could make it extra safe either by leaving it in the Funcion's settings
            --or KeyVault if you really are not happy with it being hard coded.. 
            var connectionString = "Data Source=psdemosql01.database.windows.net;Initial Catalog=AdventureWorks";

            using (var connection = new SqlConnection(connectionString))
            {
                connection.AccessToken = accessToken;
                connection.Open();
                Console.WriteLine(connection.State);
                var statement = $"select top 5 LastName from SalesLT.Customer";
                Console.WriteLine(statement);
                using (var sqlCmd = new SqlCommand(statement, connection))
                {
                    using (var reader = sqlCmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Console.WriteLine(reader.GetString(0));

                        }
                    }
                }

            }

        }
    }
}






