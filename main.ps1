param(
    [ValidatePattern('^[a-zA-Z0-9]+$')]
    [Parameter(Mandatory = $true)] [String] $ResourcePrefix, 
    [String] $AppPlanResourceGroupName,    
    [String] $PrimaryAppPlanName,
    [String] $PrimaryLocation = "eastus",  
    [String] $SecondaryAppPlanName,
    [String] $SecondaryLocation = "westus",
    [String] $TemplateFile = './main.json'
)

$ErrorActionPreference = "Stop"

Write-Host "Resource Prefix                 : $($ResourcePrefix)"
Write-Host "App Plan Resource Group Name    : $($AppPlanResourceGroupName)"
Write-Host "Primary App Plan Name           : $($PrimaryAppPlanName)"
Write-Host "Primary Location                : $($PrimaryLocation)"
Write-Host "Secondary App Plan Name         : $($SecondaryAppPlanName)"
Write-Host "Secondary Location              : $($SecondaryLocation)"

$ResourceGroupName = "$($ResourcePrefix)rg"

Write-Host "Resource Group Name             : $($ResourceGroupName)"

az group create `
    -n $ResourceGroupName `
    -l $PrimaryLocation

az deployment group create `
    -g $ResourceGroupName `
    -f $TemplateFile `
    --parameters resourcePrefix=$ResourcePrefix `
    --parameters appPlanResourceGroupName=$AppPlanResourceGroupName `
    --parameters primaryAppPlanName=$PrimaryAppPlanName `
    --parameters primaryLocation=$PrimaryLocation `
    --parameters secondaryAppPlanName=$SecondaryAppPlanName `
    --parameters secondaryLocation=$SecondaryLocation