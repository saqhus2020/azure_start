
param location string
param sqlServerName string
param sqlServerAdministratorLogin string = 'sqladmin'
@secure()
param sqlServerAdministratorPassword string
param sqlDatabaseName string
param sqlDatabaseSku object
param storageAccount object
@secure()
param storageAccountKey string


resource sqlServer 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
  tags:{
    CostCenter: 'AzureStart'
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

resource SqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview'={
  parent: sqlServer
  name: 'SqlFirewallRuleName'
  properties: {
    startIpAddress: '77.163.184.203'
    endIpAddress: '77.163.184.203'
  }
}

resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2022-05-01-preview'={
  parent: sqlServer
  name: 'default'
  properties:{
    state: 'Enabled'
    storageEndpoint: storageAccount.properties.primaryEndpoints.blob
    storageAccountAccessKey:storageAccountKey
  }

}


//output auditstorageEndpointBlob string = auditStorageAccount.properties.primaryEndpoints.blob
//output storageAccesskey string = listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0]
