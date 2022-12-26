resource example 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'password-generate'
  location: 'UK South'
  kind: 'AzurePowerShell'
  properties: {
    azPowerShellVersion: '3.0' 
    retentionInterval: 'P1D'
    scriptContent: loadTextContent('./generatepwd.ps1')
  }
}

output encodedPassword string =  example.properties.outputs.encodedPassword
output passwordText string =  example.properties.outputs.password
