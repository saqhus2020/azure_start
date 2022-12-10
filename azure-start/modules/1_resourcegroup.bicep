targetScope = 'subscription'
param location string
param name string


resource resourcegroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
  }
