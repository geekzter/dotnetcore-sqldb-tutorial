#!/usr/bin/env pwsh

<# 
.SYNOPSIS 
    Run designated container image locally
 
.EXAMPLE
    ./run_container.ps1 -Workspace test -Destroy
#> 
#Requires -Version 7

param (
    [parameter(Mandatory=$false)][string]$Image="ewdev.azurecr.io/vdc/aspnet-core-sqldb:latest",
    [parameter(Mandatory=$false)][string]$HostingEnvironment="Development",
    [parameter(Mandatory=$false)][string]$ConnectionString=$env:ConnectionStrings:MyDbConnection,
    [parameter(Mandatory=$false)][int]$HttpPort=8080
)

if (!$ConnectionString) {
    $appSettingsPath = Join-Path (Split-Path -parent -Path $MyInvocation.MyCommand.Path) "appsettings.${HostingEnvironment}.json"
    if (!(Test-Path $appSettingsPath)) {
        Write-Error "$appSettingsPath does not exist, can't determine connection string. Aborting."
        exit
    }
    $appSettings = Get-Content $appSettingsPath | ConvertFrom-Json
    Write-Debug $appSettings
    $ConnectionString = $appSettings.ConnectionStrings.MyDbConnection
    if (!$ConnectionString) {
        Write-Error "Could not determine connection string"
        exit
    }
}

$Name = $Image -replace "\W",""

docker run -d -p ${HttpPort}:80 --name $Name -e ASPNETCORE_ENVIRONMENT=$HostingEnvironment -e ConnectionStrings:MyDbConnection=$ConnectionString $Image
