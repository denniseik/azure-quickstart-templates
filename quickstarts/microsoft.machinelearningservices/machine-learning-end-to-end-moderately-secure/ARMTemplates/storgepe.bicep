param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net'
param virtualNetworks_test_vnet_externalid string = '/subscriptions/e2e9abe9-3dfb-4b8c-8537-56999d5a2081/resourceGroups/sec-test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet'

resource privateDnsZones_privatelink_blob_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2018-09-01' = {
  name: privateDnsZones_privatelink_blob_core_windows_net_name
  location: 'global'
  properties: {
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_testsanr 'Microsoft.Network/privateDnsZones/A@2018-09-01' = {
  name: '${privateDnsZones_privatelink_blob_core_windows_net_name_resource.name}/testsanr'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '196.24.0.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_blob_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2018-09-01' = {
  name: '${privateDnsZones_privatelink_blob_core_windows_net_name_resource.name}/@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_fk6o3lpe54co6 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
  name: '${privateDnsZones_privatelink_blob_core_windows_net_name_resource.name}/fk6o3lpe54co6'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_test_vnet_externalid
    }
  }
}
