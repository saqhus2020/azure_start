@description('Unique Suffix')
param uniqueSuffix string = substring(uniqueString(resourceGroup().id),0,6)
//Data Lake Parameters
@description('Synapse Workspace Data Lake Storage Account Name')
param workspaceDataLakeAccountName string = 'azwksdatalake${uniqueSuffix}'

@description('Synapse Workspace Data Lake Storage Account Name')
param rawDataLakeAccountName string = 'azrawdatalake${uniqueSuffix}'

@description('Synapse Workspace Data Lake Storage Account Name')
param curatedDataLakeAccountName string = 'azcurateddatalake${uniqueSuffix}'

@description('Data Lake Raw Zone Container Name')
param dataLakeRawZoneName string = 'raw'

@description('Data Lake Trusted Zone Container Name')
param dataLakeTrustedZoneName string = 'trusted'

@description('Data Lake Curated Zone Container Name')
param dataLakeCuratedZoneName string = 'curated'

@description('Data Lake Transient Zone Container Name')
param dataLakeTransientZoneName string = 'transient'

@description('Data Lake Sandpit Zone Container Name')
param dataLakeSandpitZoneName string = 'sandpit'

@description('Synapse Default Container Name')
param synapseDefaultContainerName string = synapseWorkspaceName
//----------------------------------------------------------------------

//Synapse Workspace Parameters
@description('Synapse Workspace Name')
param synapseWorkspaceName string = 'azsynapsewks${uniqueSuffix}'

@description('SQL Admin User Name')
param synapseSqlAdminUserName string = 'azsynapseadmin'

@description('SQL Admin User Password')
param synapseSqlAdminPassword string

@description('Synapse Managed Resource Group Name')
param synapseManagedRGName string = '${synapseWorkspaceName}-mrg'

@description('Deploy SQL Pool')
param ctrlDeploySynapseSQLPool bool = false //Controls the creation of Synapse SQL Pool

@description('SQL Pool Name')
param synapseDedicatedSQLPoolName string = 'EnterpriseDW'

@description('SQL Pool SKU')
param synapseSQLPoolSKU string = 'DW100c'

@description('Deploy Spark Pool')
param ctrlDeploySynapseSparkPool bool = false //Controls the creation of Synapse Spark Pool

@description('Spark Pool Name')
param synapseSparkPoolName string = 'SparkPool'

@description('Spark Node Size')
param synapseSparkPoolNodeSize string = 'Small'

@description('Spark Min Node Count')
param synapseSparkPoolMinNodeCount int = 3

@description('Spark Max Node Count')
param synapseSparkPoolMaxNodeCount int = 3

@description('Deploy ADX Pool')
param ctrlDeploySynapseADXPool bool = false //Controls the creation of Synapse Spark Pool

@description('ADX Pool Name')
param synapseADXPoolName string = 'adxpool${uniqueSuffix}'

@description('ADX Database Name')
param synapseADXDatabaseName string = 'ADXDB'

@description('ADX Pool Enable Auto-Scale')
param synapseADXPoolEnableAutoScale bool = false

@description('ADX Pool Minimum Size')
param synapseADXPoolMinSize int = 2

@description('ADX Pool Maximum Size')
param synapseADXPoolMaxSize int = 2


@description('Resource Location')
param resourceLocation string = resourceGroup().location


var storageEnvironmentDNS = environment().suffixes.storage
var dataLakeStorageAccountUrl = 'https://${workspaceDataLakeAccountName}.dfs.${storageEnvironmentDNS}'
//var azureRBACStorageBlobDataContributorRoleID = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //Storage Blob Data Contributor Role



resource r_workspaceDataLakeAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: workspaceDataLakeAccountName
  location: resourceLocation
  properties:{
    isHnsEnabled: true
    accessTier:'Hot'
    networkAcls: {
      defaultAction: 'Allow'
      bypass:'None'
      resourceAccessRules: [
        {
          tenantId: subscription().tenantId
          resourceId: r_synapseWorkspace.id
        }
    ]
    }
  }
  kind:'StorageV2'
  sku: {
      name: 'Standard_LRS'
  }
}

//Synapse Workspace
resource r_synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name:synapseWorkspaceName
  location: resourceLocation
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    defaultDataLakeStorage:{
      accountUrl: dataLakeStorageAccountUrl
      filesystem: synapseDefaultContainerName
    }
    sqlAdministratorLogin: synapseSqlAdminUserName
    sqlAdministratorLoginPassword: synapseSqlAdminPassword
    //publicNetworkAccess: Post Deployment Script will disable public network access for vNet integrated deployments.
    managedResourceGroupName: synapseManagedRGName
    managedVirtualNetwork: 'default'
    managedVirtualNetworkSettings: {
      preventDataExfiltration:false
      
    }
    
  }
}
