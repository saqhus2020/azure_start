param keyVaultName string 
param location string 
param tenantId string 
param objectId string
param keysPermissions array
param secretsPermissions array 
//param skuName string 
param secretNames array
@secure()
param secretValue string

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    enableRbacAuthorization: false

    tenantId: tenantId
    accessPolicies: [
      {
        objectId: objectId
        tenantId: tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = [for secretName in secretNames:{
  parent: kv
  name: secretName
  properties: {
    value: uniqueString(resourceGroup().id, secretName)
  }
}]

