targetScope='resourceGroup'

@description('The resourcegroup for all resources.')
param ResourceGroup string
param environment string
var location = resourceGroup().location

var resourceSuffix = '${environment}-${location}-contoso001'

// Resource Names
var apimName = 'apim-${resourceSuffix}'

module apimModule 'apim/apim.bicep'  = {
  name: 'apimDeploy'
  scope: resourceGroup(ResourceGroup)
  params: {
    apimName: apimName
    location: location
  }
}
