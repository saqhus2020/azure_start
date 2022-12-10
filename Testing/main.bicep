param location string = resourceGroup().location
@minLength(5)
@maxLength(30)
param solutionName string = 'azure-start${uniqueString(resourceGroup().id)}'

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

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'
var sqlServerName = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'


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
