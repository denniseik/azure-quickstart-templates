param privateEndpoints_blob_pe_name string = 'blob-pe'
param storageAccounts_sectestsa_externalid string = '/subscriptions/e2e9abe9-3dfb-4b8c-8537-56999d5a2081/resourceGroups/sec-test-rg/providers/Microsoft.Storage/storageAccounts/sectestsa'
param virtualNetworks_primary_vnet_externalid string = '/subscriptions/e2e9abe9-3dfb-4b8c-8537-56999d5a2081/resourceGroups/security-tut-rg/providers/Microsoft.Network/virtualNetworks/primary-vnet'

resource privateEndpoints_blob_pe_name_resource 'Microsoft.Network/privateEndpoints@2020-11-01' = {
  name: privateEndpoints_blob_pe_name
  location: 'westus'
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${privateEndpoints_blob_pe_name}_3acec143-588b-4bc4-a6b2-9cef26c22016'
        properties: {
          privateLinkServiceId: storageAccounts_sectestsa_externalid
          groupIds: [
            'blob'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: '${virtualNetworks_primary_vnet_externalid}/subnets/Training'
    }
    customDnsConfigs: [
      {
        fqdn: 'sectestsa.blob.core.windows.net'
        ipAddresses: [
          '172.25.0.14'
        ]
      }
    ]
  }
}