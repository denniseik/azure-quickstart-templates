targetScope = 'resourceGroup'

// General parameters
@description('Specifies the location for all resources.')
param location string

@minLength(2)
@maxLength(10)
@description('Specifies the prefix for all resources created in this deployment.')
param prefix string

@description('Specifies the tags that you want to apply to all resources.')
param tags object = {}

// Resource parameters
// Vnet/Subnet address prefixes
@description('Specifies the address prefix of the virtual network. To use the default value, do not specify a new value.')
param vnetAddressPrefix string
@description('Specifies the address prefix of the training subnet. To use the default value, do not specify a new value.')
param trainingSubnetPrefix string
@description('Specifies the address prefix of the scoring subnet. To use the default value, do not specify a new value.')
param scoringSubnetPrefix string
@description('Specifies the address prefix of the azure bastion subnet. To use the default value, do not specify a new value.')
param azureBastionSubnetPrefix string

// DSVM Jumpbox username and password
param dsvmJumpboxUsername string
@secure()
param dsvmJumpboxPassword string

// Variables
var name = toLower('${prefix}')

// Resources
module nsg001 'modules/nsg.bicep' = {
  name: 'nsg-${name}-001'
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    nsgName: '${name}-nsg001'
  }
}

module vnet001 'modules/vnet.bicep' = {
  name: 'vnet-${name}-${location}-001'
  dependsOn: [
    nsg001
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    virtualNetworkName: 'vnet-${name}-${location}-001'
    networkSecurityGroupId: nsg001.outputs.networkSecurityGroup
    vnetAddressPrefix: vnetAddressPrefix
    trainingSubnetPrefix: trainingSubnetPrefix
    scoringSubnetPrefix: scoringSubnetPrefix
    azureBastionSubnetPrefix: azureBastionSubnetPrefix
  }
}

module storage001 'modules/storage.bicep' = {
  name: 'st${name}${environment}001'
  dependsOn: [
    vnet001
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    storageName: 'st${name}001'
    storageSkuName: 'Standard_LRS'
    subnetId: '${vnet001.outputs.virtualNetworkId}/subnets/training-subnet'
    virtualNetworkId: '${vnet001.outputs.virtualNetworkId}'
  }
}

// Resources
module keyvault001 'modules/keyvault.bicep' = {
  name: 'kv-${name}-001'
  dependsOn: [
    vnet001
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    keyvaultName: 'kv-${name}-${environment}-001'
    subnetId: '${vnet001.outputs.virtualNetworkId}/subnets/training-subnet'
    virtualNetworkId: '${vnet001.outputs.virtualNetworkId}'
  }
}

module containerRegistry001 'modules/containerregistry.bicep' = {
  name: 'cr${name}${environment}001'
  dependsOn: [
    vnet001
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    containerRegistryName: '${name}-containerregistry001'
    subnetId: '${vnet001.outputs.virtualNetworkId}/subnets/training-subnet'
    virtualNetworkId: '${vnet001.outputs.virtualNetworkId}'
  }
}

module applicationInsights001 'modules/applicationinsights.bicep' = {
  name: '${name}-applicationInsights001'
  dependsOn: [
    vnet001
  ]
  scope: resourceGroup()
  params: {
    location: location
    tags: tags
    applicationInsightsName: '${name}-insights001'
  }
}

module machineLearning001 'modules/machinelearning.bicep' = {
  name: '${name}-machineLearning001'
  dependsOn: [
    keyvault001
    containerRegistry001
    applicationInsights001
    storage001
  ]
  scope: resourceGroup()
  params: {
    location: location
    prefix: name
    tags: tags
    machineLearningName: '${name}-ws'
    applicationInsightsId: applicationInsights001.outputs.applicationInsightsId
    containerRegistryId: containerRegistry001.outputs.containerRegistryId
    keyVaultId: keyvault001.outputs.keyvaultId
    storageAccountId: storage001.outputs.storageId
    subnetId: '${vnet001.outputs.virtualNetworkId}/subnets/training-subnet'
    computeSubnetId: '${vnet001.outputs.virtualNetworkId}/subnets/training-subnet'
    aksSubnetId: '${vnet001.outputs.virtualNetworkId}/subnets/scoring-subnet'
    virtualNetworkId: '${vnet001.outputs.virtualNetworkId}'
  }
}

module dsvm001 'modules/dsvmjumpbox.bicep' = {
  name: '${name}-dsvm001'
  scope: resourceGroup()
  params: {
    location: location
    virtualMachineName: name
    subnetId: '${vnet001.outputs.virtualNetworkId}/subnets/training-subnet'
    adminUsername: dsvmJumpboxUsername
    adminPassword: dsvmJumpboxPassword
    networkSecurityGroupId: nsg001.outputs.networkSecurityGroup
  }
}
