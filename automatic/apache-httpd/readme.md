# <img src="https://cdn.jsdelivr.net/gh/chocolatey-community/chocolatey-packages@2bdf6f7e33ec1a8126829fbbc87b83e4473b3634/icons/apache-httpd.png" width="48" height="48"/> [apache-httpd](https://chocolatey.org/packages/apache-httpd)

Apache HTTP Web Server for Windows.

The Apache HTTP Server Project is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

The Apache HTTP Server ("httpd") was launched in 1995 and it has been the most popular web server on the Internet since April 1996. It has celebrated its 20th birthday as a project in February 2015.

The Apache HTTP Server is a project of The Apache Software Foundation.

## Package Parameters

- `/installLocation` - Install to a different destination folder. Default: `$Env:AppData\Apache*`
- `/serviceName` - The name of the windows service which will be create. Default: `Apache`
- `/port` - The port Apache will listen to. Default: `8080`
- `/noService` - Don't install the apache httpd windows service

Example: `choco install apache-httpd --params '"/installLocation:C:\HTTPD /port:433"'`

## Notes

- This package installs the Apache HTTP Server Windows binaries built by [Apache Lounge](https://www.apachelounge.com/download/) from the official ASF sources.
- The Apache Lounge binaries do not run on Windows XP, Windows 7 or Server 2003.
- Users upgrading from a version based on the Apache Haus binaries should review their `httpd.conf`, as the bundled modules and libraries differ.
- The complete path of the package will be `$Env:AppData\Apache*`
- Apache will be installed as a service under the default name 'Apache' (can be disabled with the `/noService` install parameter)
