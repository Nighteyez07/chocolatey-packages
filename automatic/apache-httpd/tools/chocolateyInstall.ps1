$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
. "$toolsDir\helpers.ps1"

$pp = Get-PackageParameters

$arguments = @{
    packageName = $env:chocolateyPackageName
    file        = "$toolsDir\httpd-2.4.69-261002-win32-vs18.zip"
    file64      = "$toolsDir\httpd-2.4.69-261002-Win64-VS18.zip"
    destination = if ($pp.installLocation) { $pp.installLocation } else { $env:APPDATA }
    port        = if ($pp.Port) { $pp.Port } else { 8080 }
    serviceName = if ($pp.NoService) { $null } elseif ($pp.serviceName) { $pp.serviceName } else { 'Apache' }
}

if (-not (Assert-TcpPortIsOpen $arguments.port)) {
    throw 'Please specify a different port number...'
}

Install-Apache $arguments
