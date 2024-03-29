targetScope='resourceGroup'

/*
 * Input parameters
*/

@description('The name of the API Management resource to be created.')
param apiminstances array

@description('The email address of the publisher of the APIM resource.')
@minLength(1)
param publisherEmail string = 'apim@contoso.com'

@description('Company name of the publisher of the APIM resource.')
@minLength(1)
param publisherName string = 'Contoso'

@description('The pricing tier of the APIM resource.')
param skuName string = 'Developer'

@description('The instance size of the APIM resource.')
param capacity int = 1

@description('Location for Azure resources.')
param location string = resourceGroup().location

param resourceSuffix string

param myLogger string = 'mylogger'

param ehName string

param ehconn string



resource eh 'Microsoft.EventHub/namespaces/eventhubs@2022-01-01-preview' existing ={
  name: ehName
}


/*
 * Resources
*/

resource apimName_resource 'Microsoft.ApiManagement/service@2020-12-01' = [for instance in apiminstances: {

  name: 'apim-${resourceSuffix}-${instance}'
  location: location
  sku:{
    capacity: capacity
    name: skuName
  }
  properties:{
    virtualNetworkType: 'External'
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}]

resource logger 'Microsoft.ApiManagement/service/loggers@2021-01-01-preview' = [for i in range (0, length(apiminstances)): {
  name: '${myLogger}-${apiminstances[i]}'
  properties: {
    loggerType: 'azureEventHub'
    credentials: {
      connectionString: ehconn
      name: eh.name
    }
  }
  parent: apimName_resource[i]
}]





























