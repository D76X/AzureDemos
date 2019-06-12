$kvname = "wppres1kv1"
$connectionString = "Server=tcp:wppres1sqlserver1.database.windows.net,1433;Initial Catalog=wppres1db1;Persist Security Info=False;User ID=dspano;Password=@X1y2z3w4z5;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$secretvalue = ConvertTo-SecureString –String $connectionString -AsPlainText -Force
$secretname = "connectionString1"
# add the secure string to our new Key Vault
$secret = Set-AzureKeyVaultSecret -VaultName $kvname -Name "importantsecret1" -SecretValue $secretvalue
$secret.Id