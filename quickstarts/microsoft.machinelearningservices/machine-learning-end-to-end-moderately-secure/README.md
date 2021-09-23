# Usage

This creates the resources in this document (https://microsoft.sharepoint.com/:w:/t/Vienna/EbD553TP28JPhnYFG9kgrsMBZ3LzH6wKnmFrYIWki4WHHA) but it does not create the resource groups yet. 
Please create one resource group to test this out.

Commands:

Set to the subscription where the resource group was created
1 - az account set -s <sub-id>

Deploy the main bicep template
2- az deployment group create --resource-group <rg> --template-file .\main.bicep

