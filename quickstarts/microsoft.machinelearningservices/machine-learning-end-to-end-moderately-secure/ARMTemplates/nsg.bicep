param networkSecurityGroups_test_nsg_name string = 'test-nsg'

resource networkSecurityGroups_test_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: networkSecurityGroups_test_nsg_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'NRMS-Rule-106'
        properties: {
          description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 106
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '22'
            '3389'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'NRMS-Rule-104'
        properties: {
          description: 'Created by Azure Core Security managed policy, rule can be deleted but do not change source ips, please see aka.ms/cainsgpolicy'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'CorpNetSaw'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 104
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'NRMS-Rule-105'
        properties: {
          description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 105
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '1433'
            '1434'
            '3306'
            '4333'
            '5432'
            '6379'
            '7000'
            '7001'
            '7199'
            '9042'
            '9160'
            '9300'
            '16379'
            '26379'
            '27017'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'NRMS-Rule-108'
        properties: {
          description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 108
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '13'
            '17'
            '19'
            '53'
            '69'
            '111'
            '123'
            '512'
            '514'
            '593'
            '873'
            '1900'
            '5353'
            '11211'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'NRMS-Rule-109'
        properties: {
          description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 109
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '119'
            '137'
            '138'
            '139'
            '161'
            '162'
            '389'
            '636'
            '2049'
            '2301'
            '2381'
            '3268'
            '5800'
            '5900'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'NRMS-Rule-103'
        properties: {
          description: 'Created by Azure Core Security managed policy, rule can be deleted but do not change source ips, please see aka.ms/cainsgpolicy'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'CorpNetPublic'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 103
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'NRMS-Rule-101'
        properties: {
          description: 'Created by Azure Core Security managed policy, placeholder you can delete, please see aka.ms/cainsgpolicy'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'NRMS-Rule-107'
        properties: {
          description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 107
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: [
            '23'
            '135'
            '445'
            '5985'
            '5986'
          ]
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'BatchNodeManagement'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '29876-29877'
          sourceAddressPrefix: 'BatchNodeManagement'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 119
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource networkSecurityGroups_test_nsg_name_BatchNodeManagement 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/BatchNodeManagement'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '29876-29877'
    sourceAddressPrefix: 'BatchNodeManagement'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 119
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_test_nsg_name_NRMS_Rule_101 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/NRMS-Rule-101'
  properties: {
    description: 'Created by Azure Core Security managed policy, placeholder you can delete, please see aka.ms/cainsgpolicy'
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: 'VirtualNetwork'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 101
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_test_nsg_name_NRMS_Rule_103 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/NRMS-Rule-103'
  properties: {
    description: 'Created by Azure Core Security managed policy, rule can be deleted but do not change source ips, please see aka.ms/cainsgpolicy'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: 'CorpNetPublic'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 103
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_test_nsg_name_NRMS_Rule_104 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/NRMS-Rule-104'
  properties: {
    description: 'Created by Azure Core Security managed policy, rule can be deleted but do not change source ips, please see aka.ms/cainsgpolicy'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '*'
    sourceAddressPrefix: 'CorpNetSaw'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 104
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_test_nsg_name_NRMS_Rule_105 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/NRMS-Rule-105'
  properties: {
    description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
    protocol: '*'
    sourcePortRange: '*'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 105
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '1433'
      '1434'
      '3306'
      '4333'
      '5432'
      '6379'
      '7000'
      '7001'
      '7199'
      '9042'
      '9160'
      '9300'
      '16379'
      '26379'
      '27017'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_test_nsg_name_NRMS_Rule_106 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/NRMS-Rule-106'
  properties: {
    description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
    protocol: 'Tcp'
    sourcePortRange: '*'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 106
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '22'
      '3389'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_test_nsg_name_NRMS_Rule_107 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/NRMS-Rule-107'
  properties: {
    description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
    protocol: 'Tcp'
    sourcePortRange: '*'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 107
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '23'
      '135'
      '445'
      '5985'
      '5986'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_test_nsg_name_NRMS_Rule_108 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/NRMS-Rule-108'
  properties: {
    description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
    protocol: '*'
    sourcePortRange: '*'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 108
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '13'
      '17'
      '19'
      '53'
      '69'
      '111'
      '123'
      '512'
      '514'
      '593'
      '873'
      '1900'
      '5353'
      '11211'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource networkSecurityGroups_test_nsg_name_NRMS_Rule_109 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  name: '${networkSecurityGroups_test_nsg_name_resource.name}/NRMS-Rule-109'
  properties: {
    description: 'DO NOT DELETE - Will result in ICM Sev 2 - Azure Core Security, see aka.ms/cainsgpolicy'
    protocol: '*'
    sourcePortRange: '*'
    sourceAddressPrefix: 'Internet'
    destinationAddressPrefix: '*'
    access: 'Deny'
    priority: 109
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: [
      '119'
      '137'
      '138'
      '139'
      '161'
      '162'
      '389'
      '636'
      '2049'
      '2301'
      '2381'
      '3268'
      '5800'
      '5900'
    ]
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}