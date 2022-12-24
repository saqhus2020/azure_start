
param storageAccountName string
param location string
param storageAccountSkuName string
param containerNames array

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01'={
  name: storageAccountName
  location: location
  tags: {
    CostCenter: 'AzureStart' 
  }
  sku:{
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
}

//Data Lake zone containers
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01'=[for containerName in containerNames: {
  name:'${storageAccount.name}/default/${containerName}'
  
}]


output storageAccount object = storageAccount
output storageAccountName string = storageAccount.name
//output StorageAccountKey string = storageAccount.listKeys().keys[0].value
output StorageAccountId string = storageAccount.id
