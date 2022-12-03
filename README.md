# azure_start
Start creating azure environment from start


az login
az account set --subscription <subscription id>
az deployment sub create --location 'westeurope'  --template-file 1_resourcegroup.bicep
az deployment group create --resource-group azure-start --template-file main.bicep --parameters main.parameters.json

az deployment group create --resource-group rs_azure_start_dev01 --template-file ./4_keyvault.bicep --parameters keyVaultName="kv-azure-start" objectId="put here id"


     # Deploy the example infrastructure (Azure services) using the bicep template
  - task: AzureCLI@1
    displayName: 'Deploy SQL Server Using Bicep template'
    enabled: true
    name: 'Create_SQL'
    inputs:
      azureSubscription: $(AzureSPNOTA)
      scriptLocation: 'inlineScript'
      inlineScript: |
        az deployment group create \
          --name Azure-Start \
          --resource-group $(ResourceGroupName) \
          --template-file "$(System.DefaultWorkingDirectory)/main.bicep" \
          --parameters main.parameters.json



param vnetName string 
param vnetAddressPrefix string 
param subnet1Prefix string 
param subnet1Name string 
param subnet2Prefix string 
param subnet2Name string 

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
