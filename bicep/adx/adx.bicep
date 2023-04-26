@description('Location for all resources.')
param location string = resourceGroup().location

@description('The name of the adx cluster to create.')
param clustername string

@description('The name of the adx database to create.')
param adxdbname string


resource adx 'Microsoft.Kusto/clusters@2022-12-29' = {
  name: clustername
  location: location
  sku: {
    capacity: 1
    name: 'Dev(No SLA)_Standard_E2a_v4'
    tier: 'standard'
  }
  identity: { 
    type: 'SystemAssigned'
  }
  properties: {
    enableAutoStop: true
    enableDiskEncryption: false
    enableDoubleEncryption: false
    enablePurge: false
    enableStreamingIngest: false
    engineType: 'V3'
    optimizedAutoscale: {
      isEnabled: true
      maximum: 2
      minimum: 1
      version: 1
    }
    publicIPType: 'ipv4'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}


resource adxdb 'Microsoft.Kusto/clusters/databases@2022-12-29' = {
  name: adxdbname
  location: location
  kind: 'ReadWrite'
  properties: {
    hotCachePeriod: '7'
    softDeletePeriod: '30'
  }
  parent: adx
  // For remaining properties, see clusters/databases objects
}
