targetScope='resourceGroup'

/*
 * Input parameters
*/

@description('The name of the API Management resource to be created.')
param apimName string

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


/*
 * Resources
*/

resource apimName_resource 'Microsoft.ApiManagement/service@2020-12-01' = {
  name: apimName
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
}
