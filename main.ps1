param(
    [ValidatePattern('^[a-zA-Z0-9]+$')]
    [Parameter(Mandatory = $true)] [String] $ResourcePrefix,    
    [String] $PrimaryLocation = "eastus",
    [String] $SecondaryLocation = "westus",
    [String] $TemplateFile = './main.json'
)

$ErrorActionPreference = "Stop"

Write-Host "Resource Prefix             : $($ResourcePrefix)"
Write-Host "Primary Location            : $($PrimaryLocation)"
Write-Host "Secondary Location          : $($SecondaryLocation)"

$ResourceGroupName = "$($ResourcePrefix)rg"

Write-Host "Resource Group Name         : $($ResourceGroupName)"

az group create `
    -n $ResourceGroupName `
    -l $PrimaryLocation

az deployment group create `
    -g $ResourceGroupName `
    -f $TemplateFile `
    --parameters resourcePrefix=$ResourcePrefix `
    --parameters primaryLocation=$PrimaryLocation `
    --parameters secondaryLocation=$SecondaryLocation