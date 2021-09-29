// This template is used to create a secure Azure Machine Learning workspace with CPU cluster, GPU cluster, Compute Instance and attached private AKS cluster.

targetScope = 'resourceGroup'

// General parameters
@description('Specifies the location for all resources.')
param location string = resourceGroup().location

@minLength(2)
@maxLength(10)
@description('Specifies the prefix for all resources created in this deployment.')
param prefix string

@description('Specifies the tags that you want to apply to all resources.')
param tags object = {}

// Resource parameters
// Vnet/Subnet address prefixes
@description('Specifies the address prefix of the virtual network.')
param vnetAddressPrefix string = '192.168.0.0/16'

@description('Specifies the address prefix of the training subnet.')
param trainingSubnetPrefix string = '192.168.0.0/24'

@description('Specifies the address prefix of the scoring subnet.')
param scoringSubnetPrefix string = '192.168.1.0/24'

@description('Specifies the address prefix of the azure bastion subnet.')
param azureBastionSubnetPrefix string = '192.168.250.0/27'

// DSVM Jumpbox username and password
param dsvmJumpboxUsername string
@secure()
param dsvmJumpboxPassword string

// Variables
var name = toLower('${prefix}')

// Resources

module nsg 'modules/nsg.bicep' = {
  name: '${name}-nsg001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    nsgName: '${name}-nsg001'
  }
}

module vnet 'modules/vnet.bicep' = {
  name: '${name}-vnet001'
  dependsOn: [
    nsg
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    virtualNetworkName: '${name}-vnet001'
    networkSecurityGroupId: nsg.outputs.networkSecurityGroup
    vnetAddressPrefix: vnetAddressPrefix
    trainingSubnetPrefix: trainingSubnetPrefix
    scoringSubnetPrefix: scoringSubnetPrefix
    azureBastionSubnetPrefix: azureBastionSubnetPrefix
  }
}


module storage 'modules/storage.bicep' = {
  name: '${name}-storage001'
  dependsOn: [
    vnet
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    storageName: '${name}-storage001'
    storageSkuName: 'Standard_LRS'
    subnetId: '${vnet.outputs.virtualNetworkId}/subnets/training-subnet'
    virtualNetworkId: '${vnet.outputs.virtualNetworkId}'
  }
}

// Resources
module keyvault 'modules/keyvault.bicep' = {
  name: '${name}-keyvault001'
  dependsOn: [
    vnet
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    keyvaultName: '${name}-vault001'
    subnetId: '${vnet.outputs.virtualNetworkId}/subnets/training-subnet'
    virtualNetworkId: '${vnet.outputs.virtualNetworkId}'
  }
}

module containerRegistry 'modules/containerregistry.bicep' = {
  name: '${name}-containerRegistry001'
  dependsOn: [
    vnet
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    containerRegistryName: '${name}-containerregistry001'
    subnetId: '${vnet.outputs.virtualNetworkId}/subnets/training-subnet'
    virtualNetworkId: '${vnet.outputs.virtualNetworkId}'
  }
}

module applicationInsights 'modules/applicationinsights.bicep' = {
  name: '${name}-applicationInsights001'
  dependsOn: [
    vnet
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    applicationInsightsName: '${name}-insights001'
  }
}

module amlWorkspace 'modules/machinelearning.bicep' = {
  name: '${name}-machineLearning001'
  dependsOn: [
    keyvault
    containerRegistry
    applicationInsights
    storage
  ]
  scope: resourceGroup()
  params: {
    location: location
    prefix: name
    tags: tags
    machineLearningName: '${name}-ws'
    applicationInsightsId: applicationInsights.outputs.applicationInsightsId
    containerRegistryId: containerRegistry.outputs.containerRegistryId
    keyVaultId: keyvault.outputs.keyvaultId
    storageAccountId: storage.outputs.storageId
    subnetId: '${vnet.outputs.virtualNetworkId}/subnets/training-subnet'
    computeSubnetId: '${vnet.outputs.virtualNetworkId}/subnets/training-subnet'
    aksSubnetId: '${vnet.outputs.virtualNetworkId}/subnets/scoring-subnet'
    virtualNetworkId: '${vnet.outputs.virtualNetworkId}'
  }
}

module dsvm 'modules/dsvmjumpbox.bicep' = {
  name: '${name}-dsvm001'
  scope: resourceGroup()
  params: {
    location: location
    virtualMachineName: name
    subnetId: '${vnet.outputs.virtualNetworkId}/subnets/training-subnet'
    adminUsername: dsvmJumpboxUsername
    adminPassword: dsvmJumpboxPassword
    networkSecurityGroupId: nsg.outputs.networkSecurityGroup
  }
}
