param(
  [Parameter(Position = 0)]
  [string]$Pipeline
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$pipelinesRoot = Join-Path $root "pipelines"
$cursor = Join-Path $HOME ".cursor"

function Show-Usage {
  Write-Host "Usage: .\install.ps1 <pipeline-name>"
  Write-Host ""
  Write-Host "Available pipelines:"
  if (Test-Path $pipelinesRoot) {
    Get-ChildItem $pipelinesRoot -Directory | ForEach-Object { Write-Host ("  - " + $_.Name) }
  } else {
    Write-Host "  (none — create pipelines/<name>/)"
  }
}

if (-not $Pipeline) {
  Show-Usage
  exit 1
}

$src = Join-Path $pipelinesRoot $Pipeline
if (-not (Test-Path $src)) {
  Write-Error "Pipeline not found: $src"
  Show-Usage
  exit 1
}

$parts = @("agents", "commands", "rules")
foreach ($part in $parts) {
  $from = Join-Path $src $part
  if (-not (Test-Path $from)) { continue }
  $to = Join-Path $cursor $part
  New-Item -ItemType Directory -Force -Path $to | Out-Null
  Copy-Item (Join-Path $from "*") $to -Recurse -Force
  Write-Host "installed $Pipeline/$part -> $to"
}

$pluginsLocal = Join-Path $src "plugins\local"
if (Test-Path $pluginsLocal) {
  $toPlugins = Join-Path $cursor "plugins\local"
  New-Item -ItemType Directory -Force -Path $toPlugins | Out-Null
  Get-ChildItem $pluginsLocal -Directory | ForEach-Object {
    $dest = Join-Path $toPlugins $_.Name
    if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
    Copy-Item $_.FullName $dest -Recurse -Force
    Write-Host "installed $Pipeline/plugins/local/$($_.Name) -> $dest"
  }
}

Write-Host ""
Write-Host "Done: pipeline '$Pipeline' applied to $cursor"
Write-Host "Reload Cursor window, then try /php-js-pipeline (for php-js)."
