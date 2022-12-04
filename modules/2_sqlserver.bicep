param serverName string 
param sqlDBName string 
param location string 
param administratorLogin string
@secure()
param administratorLoginPassword string

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}


resource SqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview'={
  parent: sqlServer
  name: 'SqlFirewallRuleName'
  properties: {
    startIpAddress: '77.163.184.203'
    endIpAddress: '77.163.184.203'
  }
}


resource sqlDB 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }

}

