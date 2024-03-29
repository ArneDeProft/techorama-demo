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
var dbwName = 'dbw-${resourceSuffix}'
var kvName = substring('kv-${resourceSuffix}-a',0,22)
var adxName = substring('adx-${resourceSuffix}',0,22)
var adlsName = substring(replace('adls${resourceSuffix}','-',''),0,23)

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: kvName
  scope: resourceGroup(subscription().subscriptionId, ResourceGroup)
}


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


module dbwModule 'databricks/databricks.bicep'  = {
  name: 'dbwDeploy'
  scope: resourceGroup(ResourceGroup)
  params: {
    workspaceName: dbwName
    location: location
  }
  
}

/*
module kvModule 'keyvault/keyvault.bicep' = {
  name: 'kvDeploy'
  scope: resourceGroup(ResourceGroup)
  params: {
    keyVaultName: kvName
    location: location
  }
  dependsOn:[dbwModule]
}
*/



module adlsModule 'adls/adls.bicep'  = {
  name: 'adlsDeploy'
  scope: resourceGroup(ResourceGroup)
  params: {
    adlsName: adlsName
    location: location
    principalId: kv.getSecret('ADBappIP')
  }
  dependsOn:[dbwModule]
}


module adxModule 'adx/adx.bicep'  = {
  name: 'adxDeploy'
  scope: resourceGroup(ResourceGroup)
  params: {
    clustername: adxName
    location: location
    adxdbname: 'techorama'
  }
  dependsOn:[ehModule]
}
