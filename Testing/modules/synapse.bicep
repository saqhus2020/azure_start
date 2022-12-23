@description('Unique Suffix')
param uniqueSuffix string = substring(uniqueString(resourceGroup().id),0,6)
//Data Lake Parameters
param workspaceDataLakeAccountName string = 'azwksdatalake${uniqueSuffix}'
//param workspaceDataLakeAccount object
param synapseWorkspaceName string = 'azsynapsewks${uniqueSuffix}'
param synapseDefaultContainerName string = synapseWorkspaceName
param synapseSqlAdminUserName string 
@secure()
param synapseSqlAdminPassword string
param synapseManagedRGName string = '${synapseWorkspaceName}-mrg'
param resourceLocation string = resourceGroup().location
var storageEnvironmentDNS = environment().suffixes.storage
//var dataLakeStorageAccountUrl = 'https://${workspaceDataLakeAccountName}.dfs.${storageEnvironmentDNS}' 
var dataLakeStorageAccountUrl = 'https://${workspaceDataLakeAccountName}.dfs.${storageEnvironmentDNS}' 
var azureRBACStorageBlobDataContributorRoleID = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe' //Storage Blob Data Contributor Role


/*
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
*/

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

//Synapse Workspace Role Assignment as Blob Data Contributor Role in the Data Lake Storage Account
//https://docs.microsoft.com/en-us/azure/synapse-analytics/security/how-to-grant-workspace-managed-identity-permissions
/*
resource r_dataLakeRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(r_synapseWorkspace.name, workspaceDataLakeAccountName)
  scope: workspaceDataLakeAccount
  properties:{
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', azureRBACStorageBlobDataContributorRoleID)
    principalId: r_synapseWorkspace.identity.principalId
    principalType:'ServicePrincipal'
  }
}
*/

resource r_synapseWorkspaceFirewallAllowAll 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  parent: r_synapseWorkspace
  name: 'MyIP'
  properties: {
    startIpAddress: '77.163.184.203'
    endIpAddress: '77.163.184.203'
  }
}

