targetScope='resourceGroup'

@description('The resourcegroup for all resources.')
param ResourceGroup string
param environment string
var location = resourceGroup().location
param storageAccountName string


var resourceSuffix = '${environment}-${location}-contoso001'

// Resource Names
param apiminstances array
var ehName = 'eh-${resourceSuffix}'
var appNameLA = 'appnamela-${resourceSuffix}'
var appNameCI = 'appnameci-${resourceSuffix}'

module ehModule 'eventhub/eventhub.bicep'  = {
  name: 'ehDeploy'
  scope: resourceGroup(ResourceGroup)
  params: {
    ehName: ehName
    location: location
  }
  
}

module functionlaModule 'functions/function.bicep'  = {
  name: 'funclaDeploy'
  scope: resourceGroup(ResourceGroup)
  params: {
    appNameLA: appNameLA
    appNameCI: appNameCI
    location: location
    storageAccountName: storageAccountName
    ehconn: ehModule.outputs.conn
  }
  dependsOn:[ehModule]
}

module apimModule 'apim/apim.bicep'  = {
  name: 'apimDeploy'
  scope: resourceGroup(ResourceGroup)
  params: {
    apiminstances: apiminstances
    location: location
    resourceSuffix: resourceSuffix
    ehName: ehName
    ehconn:ehModule.outputs.conn
  }
  dependsOn:[ehModule]
}