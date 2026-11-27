$ErrorActionPreference = "Stop"
$src = $PSScriptRoot
$dst = Join-Path $HOME ".cursor"

@(
  "agents",
  "commands",
  "rules",
  "plugins\local\global-dev-rules"
) | ForEach-Object {
  $from = Join-Path $src $_
  $to = Join-Path $dst $_
  New-Item -ItemType Directory -Force -Path $to | Out-Null
  Copy-Item (Join-Path $from "*") $to -Recurse -Force
  Write-Host "installed $_ -> $to"
}

Write-Host ""
Write-Host "Done. Reload Cursor window, then try /php-js-pipeline"
