param location string = resourceGroup().location
@minLength(5)
@maxLength(30)
param solutionName string = 'azurestart' //${uniqueString(resourceGroup().id)}'

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1
param appServicePlanSku object

@secure()
param sqlServerAdministratorLogin string
@secure()
param sqlServerAdministratorPassword string
param sqlDatabaseSku object

param storageAccountSkuName string = 'Standard_LRS'
param virtualNetworkAddressPrefix string 
param subnets array 

param tenantId string = subscription().tenantId 
param objectId string =  '2c52c6b6-1ce7-4ad6-942c-499a8fddba1f' 
param keysPermissions array 
param secretsPermissions array 
//param skuName string 
param secretNames array

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'
var sqlServerName = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'
var storageAccountName = '${environmentName}${solutionName}st'
var virtualnetworkName = '${environmentName}-${solutionName}-vnet'
var synapseWorkspaceName = '${environmentName}-${solutionName}-saws'
var keyVaultName = '${environmentName}-${solutionName}-kv'


param containerNames array = [
  'synapse'
  'audit'
  'log'
]


module keyvault 'modules/keyvault.bicep'={
  name:'keyvault'
  params:{
    keysPermissions:keysPermissions
    keyVaultName:keyVaultName
    location:location
    objectId:objectId
    secretNames:secretNames 
    secretsPermissions:secretsPermissions
    tenantId:tenantId
  }
}

module storage 'modules/storage.bicep'={
  name: 'storage'
  params:{
    location: location
    storageAccountName: storageAccountName
    storageAccountSkuName:  storageAccountSkuName
    containerNames: containerNames
  }
}

module virtualNetwork 'modules/network.bicep'={
  name: 'virtualNetwork'
  params:{
    location: location    
    virtualNetworkName:virtualnetworkName
    subnets: subnets
    virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params:{
    location: location
    appServicePlanName: appServicePlanName
    appServiceAppName: appServiceAppName
    appServicePlanaInstanceCount: appServicePlanInstanceCount
    appServicePlanSku: appServicePlanSku
  }
}


resource storageaccountKey 'Microsoft.Storage/storageAccounts@2021-02-01' existing= {
  name: storageAccountName
}

resource keyVaultSecrets 'Microsoft.KeyVault/vaults@2019-09-01' existing= {
  name: keyVaultName 
  scope:resourceGroup()
}



module sqlServer 'modules/sqlServer.bicep' = {
  name: 'sqlServer'
  dependsOn:[
    storage
    keyvault
  ]
  params: {
    location: location
    sqlDatabaseName: sqlDatabaseName
    sqlDatabaseSku: sqlDatabaseSku
    //sqlServerAdministratorLogin: keyVaultSecrets.getSecret('sqlAdminLogin')
    sqlServerAdministratorPassword: keyVaultSecrets.getSecret('sqlAdminLoginPassword')
    sqlServerName: sqlServerName
    storageAccount: storage.outputs.storageAccount
    storageAccountKey:  storageaccountKey.listKeys().keys[0].value
 
  }
}


module synapse 'modules/synapse.bicep' = {
  name: 'synapse'
  dependsOn:[
    storage
    keyvault
]
  params:{
    synapseSqlAdminUserName: sqlServerAdministratorLogin
    synapseSqlAdminPassword: sqlServerAdministratorPassword
    resourceLocation: location
    synapseDefaultContainerName:'synapse'
    workspaceDataLakeAccountName: storageAccountName
    synapseWorkspaceName: synapseWorkspaceName
  }
}


output solutionName string = solutionName
//output auditstorageEndpointBlob string =  sqlServer.outputs.auditstorageEndpointBlob
//output storageAccesskey string = sqlServer.outputs.storageAccesskey

