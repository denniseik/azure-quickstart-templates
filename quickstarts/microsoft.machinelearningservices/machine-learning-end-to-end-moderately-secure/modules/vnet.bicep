// This template is used to create a Virtual Network.
targetScope = 'resourceGroup'

// Parameters
param location string
param tags object
param virtualNetworkName string
param networkSecurityGroupId string
param vnetAddressPrefix string
param trainingSubnetPrefix string
param scoringSubnetPrefix string
param azureBastionSubnetPrefix string

// Resources
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        empty(vnetAddressPrefix) ? '192.168.0.0/16' : vnetAddressPrefix
      ]
    }
    subnets: [
      {
        id: 'training-subnet'
        properties: {
          addressPrefix: empty(trainingSubnetPrefix) ? '192.168.0.0/24' : trainingSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
            }
            {
              service: 'Microsoft.ContainerRegistry'
            }
            {
              service: 'Microsoft.Storage'
            }
          ]
          networkSecurityGroup: {
            id: networkSecurityGroupId
          }
        }
        name: 'training-subnet'
      }
      {
        id: 'scoring-subnet'
        properties: {
          addressPrefix: empty(scoringSubnetPrefix) ? '192.168.2.0/23' : scoringSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
            }
            {
              service: 'Microsoft.ContainerRegistry'
            }
            {
              service: 'Microsoft.Storage'
            }
          ]
          networkSecurityGroup: {
            id: networkSecurityGroupId
          }
        }
        name: 'scoring-subnet'
      }
      {
        id: 'AzureBastionSubnet'
        properties: {
          addressPrefix: empty(azureBastionSubnetPrefix) ? '192.168.250.0/27' : azureBastionSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.KeyVault'
            }
            {
              service: 'Microsoft.ContainerRegistry'
            }
            {
              service: 'Microsoft.Storage'
            }
          ]
        }
        name: 'AzureBastionSubnet'
      }
    ]
  }
}

resource publicIpAddressForBastion 'Microsoft.Network/publicIpAddresses@2020-08-01' = {
  name: 'bastion-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2019-04-01' = {
  name: 'bation-jumpbox'
  dependsOn: [
    virtualNetwork
    publicIpAddressForBastion
    ]
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: '${virtualNetwork.id}/subnets/AzureBastionSubnet'
          }
          publicIPAddress: {
            id: publicIpAddressForBastion.id
          }
        }
      }
    ]
  }
}

// Outputs
output virtualNetworkId string = virtualNetwork.id
