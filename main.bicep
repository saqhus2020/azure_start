param serverName string
param sqlDBName string 
param location string
param administratorLogin string 
@secure()
param administratorLoginPassword string

param vnetName string 
param vnetAddressPrefix string 
param subnet1Prefix string 
param subnet1Name string 
param subnet2Prefix string 
param subnet2Name string 

param keyVaultName string
param tenantId string = subscription().tenantId 
param objectId string = '2c52c6b6-1ce7-4ad6-942c-499a8fddba1f' 
param keysPermissions array = [
  'list'
  'get'
]
param secretsPermissions array 
param skuName string 
param secretName string
@secure()
param secretValue string


module SQLDatabase 'modules/2_sqlserver.bicep' ={
  name : 'SQLDatabase'
  params: {
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    serverName: serverName
    sqlDBName: sqlDBName
  }
}

module VirtualNetwork 'modules/3_virtualnetwork.bicep' ={
  name: 'VirtualNetwork'
  params: {
    location: location
    subnet1Name: subnet1Name
    subnet1Prefix: subnet1Prefix
    subnet2Name: subnet2Name
    subnet2Prefix: subnet2Prefix
    vnetAddressPrefix: vnetAddressPrefix
    vnetName: vnetName
  }
}

module Keyvault 'modules/4_keyvault.bicep' ={
  name: 'Keyvault'
  params:{
    keyVaultName: keyVaultName
    objectId: objectId
    secretName: secretName
    secretValue: secretValue
    keysPermissions: keysPermissions
    location: location
    secretsPermissions: secretsPermissions
    skuName: skuName
    tenantId: tenantId
  }
}
