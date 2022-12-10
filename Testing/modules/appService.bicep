param location string 
param appServicePlanName string
param appServiceAppName string 
param appServicePlanSku object
param appServicePlanaInstanceCount int


resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanaInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}


output appServiceAppHostName string = appServiceApp.properties.defaultHostName
