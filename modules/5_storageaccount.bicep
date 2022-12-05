param storageAccountType string = 'Standard_LRS'
param location string = resourceGroup().location
param storageAccountName string = 'store${uniqueString(resourceGroup().id)}'
param containerName string = 'blobcontainer'

resource sa 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: true
    networkAcls:{      
      defaultAction: 'Deny'
      bypass: 'None'
    }
  }
}



resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${sa.name}/default/${containerName}'
}


output storageAccountName string = storageAccountName
output storageAccountId string = sa.id
