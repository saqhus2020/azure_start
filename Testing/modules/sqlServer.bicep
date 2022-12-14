
param location string
param sqlServerName string
param sqlServerAdministratorLogin string
@secure()
param sqlServerAdministratorPassword string
param sqlDatabaseName string
param sqlDatabaseSku object
param auditStorageAccountName string
param auditStorageAccountSkuName string

resource sqlServer 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2020-11-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
}

resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01'={
  name: auditStorageAccountName
  location: location
  sku:{
    name: auditStorageAccountSkuName
  }
  kind: 'StorageV2'
}



resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2022-05-01-preview'={
  parent: sqlServer
  name: 'default'
  properties:{
    state: 'Enabled'
    storageEndpoint: auditStorageAccount.properties.primaryEndpoints.blob
    storageAccountAccessKey: auditStorageAccount.listKeys().keys[0].value
  }

}


output auditstorageEndpointBlob string = auditStorageAccount.properties.primaryEndpoints.blob
//output storageAccesskey string = listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0]
