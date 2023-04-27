param location string 
param containerName string = 'databricks'
param directoryName string = 'checkpoints\\TechoramaTst1KustoEvents'
param adlsName string 

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: adlsName
  kind: 'StorageV2'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    isHnsEnabled: true
  }

  resource container 'blobServices@2022-09-01' = {
    name: 'default'

    resource container 'containers@2022-09-01' = {
      name: containerName
    }
  }
}
/*
resource createDirectory 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'createDirectory'
  kind: 'AzureCLI'
  location: location
  properties:{
    azCliVersion: '2.42.0'
    retentionInterval: 'P1D'
    arguments: '\'${storageAccount.name}\' \'${containerName}\' \'${directoryName}\''
    scriptContent: 'az storage fs directory create --account-name $1 -f $2 -n $3 --auth-mode key'
    environmentVariables: [
      {
        name: 'AZURE_STORAGE_KEY'
        secureValue: storageAccount.listKeys().keys[0].value
      }
    ]
  }
}
*/
