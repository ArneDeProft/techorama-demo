@description('Specifies a project name that is used to generate the Event Hub name and the Namespace name.')
param ehName string

@description('Specifies the Azure location for all resources.')
param location string = resourceGroup().location

param consumerGroups array = ['thirdpartyConsumer','sentinelConsumer','generelLogsConsumer']


@description('Specifies the messaging tier for Event Hub Namespace.')
@allowed([
  'Basic'
  'Standard'
])
param eventHubSku string = 'Standard'

var eventHubNamespaceName = '${ehName}ns'
var eventHubName = ehName

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' = {
  name: eventHubNamespaceName
  location: location
  sku: {
    name: eventHubSku
    tier: eventHubSku
    capacity: 1
  }
  properties: {
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
  }
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2021-11-01' = {
  parent: eventHubNamespace
  name: eventHubName
  properties: {
    messageRetentionInDays: 7
    partitionCount: 1
  }
}

resource consumerGroup 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2021-06-01-preview' = [for group in consumerGroups: {
  name: '${group}'
  parent: eventHub
}]

resource eventHubAuthorizationRule 'Microsoft.EventHub/namespaces/authorizationRules@2021-06-01-preview' = {
  name: 'eventHubAuthorizationRule'
  parent: eventHubNamespace
  properties: {
    rights: [
      'Listen'
      'Send'
    ]
  }
}

resource eventHubAuthorizationRuleDatabricks 'Microsoft.EventHub/namespaces/eventhubs/authorizationRules@2022-01-01-preview' = {
  name: 'eventHubAuthorizationRuleDatabricks'
  parent: eventHub
  properties: {
    rights: [
      'Listen'
    ]
  }
}


var eventHubNamespaceConnectionString = listKeys(eventHubAuthorizationRule.id, eventHubAuthorizationRule.apiVersion).primaryConnectionString
output conn string = eventHubNamespaceConnectionString

