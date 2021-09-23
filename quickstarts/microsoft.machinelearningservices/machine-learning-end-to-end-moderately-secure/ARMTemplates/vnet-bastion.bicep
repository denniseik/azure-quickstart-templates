param location string
param extendedLocation object
param virtualNetworkName string
param resourceGroup string
param addressSpaces array
param ipv6Enabled bool
param subnetCount int
param subnet0_name string
param subnet0_addressRange string
param ddosProtectionPlanEnabled bool
param firewallEnabled bool
param bastionEnabled bool
param bastionName string
param bastionSubnetAddressSpace string
param publicIpAddressForBastion string

resource virtualNetworkName_resource 'Microsoft.Network/VirtualNetworks@2021-01-01' = {
  name: virtualNetworkName
  location: location
  extendedLocation: (empty(extendedLocation) ? json('null') : extendedLocation)
  tags: {}
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.24.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '172.24.0.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetAddressSpace
        }
      }
    ]
    enableDdosProtection: ddosProtectionPlanEnabled
  }
  dependsOn: []
}

resource publicIpAddressForBastion_resource 'Microsoft.Network/publicIpAddresses@2020-08-01' = {
  name: publicIpAddressForBastion
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionName_resource 'Microsoft.Network/bastionHosts@2019-04-01' = {
  name: bastionName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: resourceId(resourceGroup, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, 'AzureBastionSubnet')
          }
          publicIPAddress: {
            id: resourceId(resourceGroup, 'Microsoft.Network/publicIpAddresses', publicIpAddressForBastion)
          }
        }
      }
    ]
  }
  dependsOn: [
    resourceId(resourceGroup, 'Microsoft.Network/virtualNetworks', virtualNetworkName)
    resourceId(resourceGroup, 'Microsoft.Network/publicIpAddresses', publicIpAddressForBastion)
  ]
}