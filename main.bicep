param resourcePrefix string 
param primaryLocation string = 'eastus'
param secondaryLocation string = 'westus'

resource appServicePlan01 'Microsoft.Web/serverFarms@2018-02-01' = {
  name: '${resourcePrefix}plan01'
  location: primaryLocation
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 1
  }
  properties: {}
}

resource appService0101 'Microsoft.Web/sites@2020-06-01' = {
  name: '${resourcePrefix}app0101'
  location: primaryLocation
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan01.id
    siteConfig: {
      netFrameworkVersion: 'v5.0'
    }
  }
}

resource appService0201 'Microsoft.Web/sites@2020-06-01' = {
  name: '${resourcePrefix}app0201'
  location: primaryLocation
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan01.id
    siteConfig: {
      netFrameworkVersion: 'v5.0'
    }
  }
}

resource appServicePlan02 'Microsoft.Web/serverFarms@2018-02-01' = {
  name: '${resourcePrefix}plan02'
  location: secondaryLocation
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 1
  }
  properties: {}
}

resource appService0102 'Microsoft.Web/sites@2020-06-01' = {
  name: '${resourcePrefix}app0102'
  location: secondaryLocation
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan02.id
    siteConfig: {
      netFrameworkVersion: 'v5.0'
    }
  }
}

resource appService0202 'Microsoft.Web/sites@2020-06-01' = {
  name: '${resourcePrefix}app0202'
  location: secondaryLocation
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan02.id
    siteConfig: {
      netFrameworkVersion: 'v5.0'
    }
  }
}

resource trafficManagerAppService01 'Microsoft.Network/trafficManagerProfiles@2018-04-01' = {
  name: '${resourcePrefix}app01tf'
  location: 'global'
  properties: {
    trafficRoutingMethod: 'Performance'
    dnsConfig: {
      relativeName: '${resourcePrefix}app01tf'
    }
    monitorConfig: {
      port: 80
      protocol: 'HTTP'
      path: '/health'
    }
    endpoints: [
    {
      id: concat(resourceId('Microsoft.Network/trafficManagerProfiles', '${resourcePrefix}app01tf'), '/azureEndpoints/${resourcePrefix}app0101')
      name: '${resourcePrefix}app0101'
      type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
      properties: {
        targetResourceId: appService0101.id
        target: '${resourcePrefix}app0101.azurewebsites.net'
        endpointLocation: 'eastus'
      }
    }
    {
      id: concat(resourceId('Microsoft.Network/trafficManagerProfiles', '${resourcePrefix}app01tf'), '/azureEndpoints/${resourcePrefix}app0102')
      name: '${resourcePrefix}app0102'
      type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
      properties: {
        targetResourceId: appService0102.id
        target: '${resourcePrefix}app0102.azurewebsites.net'
        endpointLocation: 'westus'
      }
    }
    ]
  }
}

resource trafficManagerAppService02 'Microsoft.Network/trafficManagerProfiles@2018-04-01' = {
  name: '${resourcePrefix}app02tf'
  location: 'global'
  properties: {
    trafficRoutingMethod: 'Performance'
    dnsConfig: {
      relativeName: '${resourcePrefix}app02tf'
    }
    monitorConfig: {
      port: 80
      protocol: 'HTTP'
      path: '/health'
    }
    endpoints: [
    {
      id: concat(resourceId('Microsoft.Network/trafficManagerProfiles', '${resourcePrefix}app02tf'), '/azureEndpoints/${resourcePrefix}app0201')
      name: '${resourcePrefix}app0201'
      type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
      properties: {
        targetResourceId: appService0201.id
        target: '${resourcePrefix}app0201.azurewebsites.net'
        endpointLocation: 'eastus'
      }
    }
    {
      id: concat(resourceId('Microsoft.Network/trafficManagerProfiles', '${resourcePrefix}app02tf'), '/azureEndpoints/${resourcePrefix}app0202')
      name: '${resourcePrefix}app0202'
      type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
      properties: {
        targetResourceId: appService0202.id
        target: '${resourcePrefix}app0202.azurewebsites.net'
        endpointLocation: 'westus'
      }
    }
    ]
  }
}