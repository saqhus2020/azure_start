param virtualNetworkAddressPrefix string 
param virtualNetworkName string ='vnet123'
param location string = resourceGroup().location
param subnets array


var subNetProperties = [for subnet in subnets: {
  name: subnet.name
  properties: {
    addressPrefix: subnet.ipAddressRange
  }
}]

resource virtualNetworks 'Microsoft.Network/virtualNetworks@2022-07-01' ={
  name: virtualNetworkName
  location: location
  properties:{
    addressSpace:{
      addressPrefixes:[
        virtualNetworkAddressPrefix
    ]
    }
    subnets: subNetProperties
  }
} 
