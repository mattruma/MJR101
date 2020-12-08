param resourcePrefix string 
param appPlanResourceGroupName string 
param primaryAppPlanName string 
param primaryLocation string = 'eastus'
param secondaryAppPlanName string
param secondaryLocation string = 'westus'

var primaryAppPlanId = resourceId(appPlanResourceGroupName, 'Microsoft.Web/serverFarms', primaryAppPlanName)

resource appService0101 'Microsoft.Web/sites@2020-06-01' = {
  name: '${resourcePrefix}app0101'
  location: primaryLocation
  kind: 'app,linux'
  properties: {
    serverFarmId: primaryAppPlanId
    siteConfig: {
      netFrameworkVersion: 'v5.0'
      linuxFxVersion: 'DOTNETCORE|5.0'
    }
  }
}

resource appService0201 'Microsoft.Web/sites@2020-06-01' = {
  name: '${resourcePrefix}app0201'
  location: primaryLocation
  kind: 'app,linux'
  properties: {
    serverFarmId: primaryAppPlanId
    siteConfig: {
      netFrameworkVersion: 'v5.0'
      linuxFxVersion: 'DOTNETCORE|5.0'
    }
  }
}

var secondaryAppPlanId = resourceId(appPlanResourceGroupName, 'Microsoft.Web/serverFarms', secondaryAppPlanName)

resource appService0102 'Microsoft.Web/sites@2020-06-01' = {
  name: '${resourcePrefix}app0102'
  location: secondaryLocation
  kind: 'app'
  properties: {
    serverFarmId: secondaryAppPlanId
    siteConfig: {
      netFrameworkVersion: 'v5.0'
      linuxFxVersion: 'DOTNETCORE|5.0'
    }
  }
}

resource appService0202 'Microsoft.Web/sites@2020-06-01' = {
  name: '${resourcePrefix}app0202'
  location: secondaryLocation
  kind: 'app'
  properties: {
    serverFarmId: secondaryAppPlanId
    siteConfig: {
      netFrameworkVersion: 'v5.0'
      linuxFxVersion: 'DOTNETCORE|5.0'
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
      ttl: 60
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
      ttl: 60
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