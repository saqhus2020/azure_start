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

param auditStorageAccountSkuName string = 'Standard_LRS'
param virtualNetworkAddressPrefix string 
param subnets array 


var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'
var sqlServerName = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'
var auditStorageAccountName = '${environmentName}${solutionName}auditst'
var virtualnetworkName = '${environmentName}-${solutionName}-vnet'

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
    auditStorageAccountName: auditStorageAccountName
    auditStorageAccountSkuName: auditStorageAccountSkuName
    
  }
}


output solutionName string = solutionName
output auditstorageEndpointBlob string = sqlServer.outputs.auditstorageEndpointBlob
//output storageAccesskey string = sqlServer.outputs.storageAccesskey

