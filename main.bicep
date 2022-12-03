param serverName string
param sqlDBName string 
param location string
param administratorLogin string 
@secure()
param administratorLoginPassword string




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
