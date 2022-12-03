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
