$ErrorActionPreference = "Stop"
$dst = $PSScriptRoot
$src = Join-Path $HOME ".cursor"

@(
  "agents",
  "commands",
  "rules",
  "plugins\local\global-dev-rules"
) | ForEach-Object {
  $from = Join-Path $src $_
  $to = Join-Path $dst $_
  if (-not (Test-Path $from)) {
    Write-Warning "skip missing: $from"
    return
  }
  New-Item -ItemType Directory -Force -Path $to | Out-Null
  Copy-Item (Join-Path $from "*") $to -Recurse -Force
  Write-Host "synced $_ <- $from"
}

Write-Host ""
Write-Host "Done. Review git status and commit with your personal account."
