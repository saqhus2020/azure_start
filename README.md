# azure_start
Start creating azure environment from start


az login
az account set --subscription <subscription id>
az deployment sub create --location 'westeurope'  --template-file 1_resourcegroup.bicep
az deployment group create --resource-group rs_azure_start_dev01 --template-file main.bicep --parameters main.parameters.json

az deployment group create --resource-group rs_azure_start_dev01 --template-file ./4_keyvault.bicep --parameters keyVaultName="kv-azure-start" objectId="put here id"


az deployment group create --resource-group storage-resource-group --template-file maintest.bicep --parameters environmentType="nonprod"

az deployment group create --resource-group rs_azure_start_dev01 --template-file main.bicep --parameters main.parameters.json location="westeurope"

az deployment group create --resource-group storage-resource-group --template-file main.bicep --parameters main.parameters.json



//output appServiceAppHostName string = appService.outputs.appServiceAppHostName