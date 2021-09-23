@description('Specifies the name of the Azure Machine Learning Workspace which will contain this compute.')
param workspaceName string

@description('Specifies the name of the Azure Machine Learning Compute cluster.')
param computeName string

@description('The name of the aks cluster to attach the compute target to.')
param clusterName string

@description('The location of the Azure Machine Learning Workspace.')
param location string

resource workspaceName_computeName 'Microsoft.MachineLearningServices/workspaces/computes@2021-01-01' = {
  name: '${workspaceName}/${computeName}'
  location: location
  properties: {
    computeType: 'AKS'
    resourceId: resourceId('Microsoft.ContainerService/managedClusters', clusterName)
  }
}
