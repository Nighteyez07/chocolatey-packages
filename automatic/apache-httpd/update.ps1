Import-Module Chocolatey-AU

$releases = 'https://www.apachelounge.com/download/'

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_GetLatest {
  $downloadPage = Invoke-WebRequest -Uri $releases -UseBasicParsing

  # File name casing differs between architectures (Win64-VS18 vs win32-vs18), -match is case-insensitive
  $re = '/httpd-(?<version>[\d\.]+)-\d+-win(32|64)-vs\d+\.zip$'
  $links = $downloadPage.Links | Where-Object href -Match $re | ForEach-Object { [uri]::new([uri]$releases, $_.href).AbsoluteUri }

  $url32 = $links | Where-Object { $_ -match '-win32-' } | Select-Object -First 1
  $url64 = $links | Where-Object { $_ -match '-win64-' } | Select-Object -First 1

  if (!$url32 -or !$url64) {
    throw "Unable to find both 32bit and 64bit downloads on $releases. Please check the update script."
  }

  $version32 = if ($url32 -match $re) { $Matches.version }
  $version64 = if ($url64 -match $re) { $Matches.version }

  if ($version32 -ne $version64) {
    throw "32bit and 64bit version do not match. Please check the update script."
  }

  return @{
    Url32   = $url32
    Url64   = $url64
    Version = $version32
  }
}

function global:au_SearchReplace {
  return @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*file\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    ".\legal\VERIFICATION.txt"      = @{
      "(?i)(listed on\s*)\<.*\>" = "`${1}<$releases>"
      "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL32)>"
      "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.URL64)>"
      "(?i)(checksum type:).*"   = "`${1} $($Latest.ChecksumType32)"
      "(?i)(checksum32:).*"      = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"      = "`${1} $($Latest.Checksum64)"
    }
  }
}

update -ChecksumFor None
