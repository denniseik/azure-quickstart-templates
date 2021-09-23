// This template is used to create AML Compute
targetScope = 'resourceGroup'

// Parameters
param location string
param tags object
param subnetId string
// Variables

resource machineLearningGpuCluster001 'Microsoft.MachineLearningServices/workspaces/computes@2021-04-01' = if (false) {
  parent: machineLearning
  name: 'gpucluster001'
  dependsOn: [
    machineLearningPrivateEndpoint
    machineLearningPrivateEndpointARecord
  ]
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    computeType: 'AmlCompute'
    computeLocation: location
    description: 'Machine Learning cluster 001'
    disableLocalAuth: true
    properties: {
      enableNodePublicIp: false
      isolatedNetwork: false
      osType: 'Linux'
      remoteLoginPortPublicAccess: 'Disabled'
      scaleSettings: {
        minNodeCount: 0
        maxNodeCount: 8
        nodeIdleTimeBeforeScaleDown: 'PT120S'
      }
      subnet: {
        id: subnetId
      }
      vmPriority: 'Dedicated'
      vmSize: 'Standard_NC6'
    }
  }
}
