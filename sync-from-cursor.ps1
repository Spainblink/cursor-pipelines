param(
  [Parameter(Position = 0)]
  [string]$Pipeline
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$pipelinesRoot = Join-Path $root "pipelines"
$cursor = Join-Path $HOME ".cursor"

function Show-Usage {
  Write-Host "Usage: .\sync-from-cursor.ps1 <pipeline-name>"
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

$dest = Join-Path $pipelinesRoot $Pipeline
if (-not (Test-Path $dest)) {
  Write-Error "Pipeline not found: $dest"
  Show-Usage
  exit 1
}

# Sync owned files under agents/commands/rules (by names already in the pipeline)
foreach ($part in @("agents", "commands", "rules")) {
  $owned = Join-Path $dest $part
  if (-not (Test-Path $owned)) { continue }
  $fromRoot = Join-Path $cursor $part
  Get-ChildItem $owned -File -Recurse | ForEach-Object {
    $rel = $_.FullName.Substring($owned.Length).TrimStart("\", "/")
    $srcFile = Join-Path $fromRoot $rel
    if (Test-Path $srcFile) {
      Copy-Item $srcFile $_.FullName -Force
      Write-Host "synced $part/$rel <- $srcFile"
    } else {
      Write-Warning "missing in Cursor, skip: $part/$rel"
    }
  }
}

# Sync plugin dirs owned by this pipeline
$pluginsOwned = Join-Path $dest "plugins\local"
if (Test-Path $pluginsOwned) {
  Get-ChildItem $pluginsOwned -Directory | ForEach-Object {
    $name = $_.Name
    $srcPlugin = Join-Path $cursor "plugins\local\$name"
    if (-not (Test-Path $srcPlugin)) {
      Write-Warning "missing plugin in Cursor, skip: $name"
      return
    }
    Remove-Item $_.FullName -Recurse -Force
    Copy-Item $srcPlugin $_.FullName -Recurse -Force
    Write-Host "synced plugins/local/$name <- $srcPlugin"
  }
}

Write-Host ""
Write-Host "Done: Cursor -> pipelines/$Pipeline"
Write-Host "Review git status and commit with your personal account."
