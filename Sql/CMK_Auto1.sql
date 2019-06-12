/****** Object:  ColumnMasterKey [CMK_Auto1]    Script Date: 5/5/2019 2:47:28 PM ******/
CREATE COLUMN MASTER KEY [CMK_Auto1]
WITH
(
	KEY_STORE_PROVIDER_NAME = N'AZURE_KEY_VAULT',
	KEY_PATH = N'https://wppres1kv2.vault.azure.net:443/keys/CMKAuto1/bbcd771cef23492ebe09e181ec9ce804'
)
GO


