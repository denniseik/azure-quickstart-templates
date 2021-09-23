param managedClusters_exampleprivateaks_name string = 'exampleprivateaks'
param virtualNetworks_noor_vnet001_externalid string = '/subscriptions/e2e9abe9-3dfb-4b8c-8537-56999d5a2081/resourceGroups/noor-bicep-rg/providers/Microsoft.Network/virtualNetworks/noor-vnet001'
param publicIPAddresses_35da36e8_732f_4593_bfa5_df26a9017cb7_externalid string = '/subscriptions/e2e9abe9-3dfb-4b8c-8537-56999d5a2081/resourceGroups/MC_noor-aks-rg_exampleprivateaks_eastus/providers/Microsoft.Network/publicIPAddresses/35da36e8-732f-4593-bfa5-df26a9017cb7'
param userAssignedIdentities_exampleprivateaks_agentpool_externalid string = '/subscriptions/e2e9abe9-3dfb-4b8c-8537-56999d5a2081/resourceGroups/MC_noor-aks-rg_exampleprivateaks_eastus/providers/Microsoft.ManagedIdentity/userAssignedIdentities/exampleprivateaks-agentpool'

resource managedClusters_exampleprivateaks_name_resource 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: managedClusters_exampleprivateaks_name
  location: 'eastus'
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  identity: {
    principalId: 'a67861eb-c036-4761-8320-978780d9aec7'
    tenantId: '72f988bf-86f1-41af-91ab-2d7cd011db47'
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.20.7'
    dnsPrefix: 'examplepri-noor-aks-rg-e2e9ab'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        kubeletDiskType: 'OS'
        vnetSubnetID: '${virtualNetworks_noor_vnet001_externalid}/subnets/scoring-subnet'
        maxPods: 30
        type: 'VirtualMachineScaleSets'
        orchestratorVersion: '1.20.7'
        enableNodePublicIP: false
        nodeLabels: {}
        mode: 'System'
        enableEncryptionAtHost: false
        osType: 'Linux'
        osSKU: 'Ubuntu'
        enableFIPS: false
      }
    ]
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs9SfroGui50itpOmroiNIsuBlaCh1QK8dN95imornC/PyKCgo4ZpspfZ6ePoAzBmtZRGD7B5+SEpy5la5RtdAULVBCkolXFUxLOQFO8zVkLaM9SbgbRoPV68V7uHuaC52MUG26TuGekC7KzC/aDxSw2H9gcl87c+nxqOzfcqxj/G2lGPMHr2gECooDH3SihM4X1vhm+hW9LcU+N+TGvs4zrz7EGrN1ZiCoyiLNo0s810XqOP7024FE615XCS6+MZIha1xeM/mwwgsLDP1wI2yC9cMpm4An6pNzRLxIjzAMR6InlnfhbYzj6b/yBzLRT5+4QMLEQNex6fmxG4EaTjt'
          }
        ]
      }
    }
    windowsProfile: {
      adminUsername: 'azureuser'
      enableCSIProxy: true
    }
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    nodeResourceGroup: 'MC_noor-aks-rg_${managedClusters_exampleprivateaks_name}_eastus'
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
        effectiveOutboundIPs: [
          {
            id: publicIPAddresses_35da36e8_732f_4593_bfa5_df26a9017cb7_externalid
          }
        ]
      }
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
      outboundType: 'loadBalancer'
    }
    privateLinkResources: [
      {
        id: '${managedClusters_exampleprivateaks_name_resource.id}/privateLinkResources/management'
        name: 'management'
        type: 'Microsoft.ContainerService/managedClusters/privateLinkResources'
        groupId: 'management'
        requiredMembers: [
          'management'
        ]
      }
    ]
    apiServerAccessProfile: {
      enablePrivateCluster: true
      privateDNSZone: 'system'
      enablePrivateClusterPublicFQDN: true
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: userAssignedIdentities_exampleprivateaks_agentpool_externalid
        clientId: '662b0630-5a62-4dcf-937e-64f750fb1417'
        objectId: '3d218626-ea8c-491d-8c5f-d63b4b992040'
      }
    }
  }
}

resource managedClusters_exampleprivateaks_name_nodepool1 'Microsoft.ContainerService/managedClusters/agentPools@2021-05-01' = {
  parent: managedClusters_exampleprivateaks_name_resource
  name: 'nodepool1'
  properties: {
    count: 3
    vmSize: 'Standard_DS2_v2'
    osDiskSizeGB: 128
    osDiskType: 'Managed'
    kubeletDiskType: 'OS'
    vnetSubnetID: '${virtualNetworks_noor_vnet001_externalid}/subnets/scoring-subnet'
    maxPods: 30
    type: 'VirtualMachineScaleSets'
    orchestratorVersion: '1.20.7'
    enableNodePublicIP: false
    nodeLabels: {}
    mode: 'System'
    enableEncryptionAtHost: false
    osType: 'Linux'
    osSKU: 'Ubuntu'
    enableFIPS: false
  }
}