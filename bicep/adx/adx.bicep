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
    name: 'Standard_E2ads_v5'
    tier: 'Standard'
    capacity: 2
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
      minimum: 2
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
  parent: adx

  // For remaining properties, see clusters/databases objects
}
