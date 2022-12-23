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


var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'
var sqlServerName = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'
var storageAccountName = '${environmentName}${solutionName}st'
var virtualnetworkName = '${environmentName}-${solutionName}-vnet'
var synapseWorkspaceName = '${environmentName}-${solutionName}-saws'


param containerNames array = [
  'synapse'
  'audit'
  'log'
]



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

module sqlServer 'modules/sqlServer.bicep' = {
  name: 'sqlServer'
  params: {
    location: location
    sqlDatabaseName: sqlDatabaseName
    sqlDatabaseSku: sqlDatabaseSku
    sqlServerAdministratorLogin: sqlServerAdministratorLogin
    sqlServerAdministratorPassword: sqlServerAdministratorPassword
    sqlServerName: sqlServerName
    storageAccount: storage.outputs.storageAccount
    storageAccountKey: storage.outputs.StorageAccountKey
    
  }
}


module synapse 'modules/synapse.bicep' = {
  name: 'synapse'
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

