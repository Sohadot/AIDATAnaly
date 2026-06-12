# activate-indexation.ps1
# Sprint 11 Phase 2 — governed indexation activation (41 launch routes only).
# Governed by: PUBLIC_RELEASE_PLAN.md (PUB-REL-001).
#
# Removes page-level noindex from Required Launch routes and activates robots.txt.
# Does not modify preview/, scripts/, governance/decisions/, or *.md repository files.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

function Get-LaunchPageRoutes {
  param([string]$RouteMapPath)
  $lines = Get-Content -Encoding UTF8 -Path $RouteMapPath
  return @($lines | ForEach-Object { $_.Trim() } |
    Where-Object { $_ -match '^/[a-z0-9\-/\.]*$' -and $_ -notmatch '\.json$' } | Sort-Object -Unique)
}

function Get-PagePath {
  param([string]$Route, [string]$Root)
  if ($Route -eq '/') { return Join-Path $Root 'index.html' }
  $rel = ($Route.Trim('/') -replace '/', '\') + '\index.html'
  return Join-Path $Root $rel
}

Write-Host '=== AIDAtanaly Indexation Activation (Sprint 11 Phase 2) ==='

$routes = Get-LaunchPageRoutes (Join-Path $root 'ROUTE_MAP.md')
if ($routes.Count -ne 41) {
  Write-Error "Expected 41 Required Launch page routes, found $($routes.Count)"
}

$noindexMetaPattern = '(?m)^\s*<meta\s+name="robots"\s+content="noindex">\s*\r?\n'
$updated = 0
foreach ($route in $routes) {
  $pagePath = Get-PagePath $route $root
  if (-not (Test-Path $pagePath)) {
    Write-Error "Missing page for activation: $route ($pagePath)"
  }
  $html = Get-Content -Raw -Encoding UTF8 -Path $pagePath
  if ($html -notmatch '<meta\s+name="robots"\s+content="noindex"') {
    Write-Error "[$route] expected pre-activation noindex meta before removal"
  }
  $newHtml = [regex]::Replace($html, $noindexMetaPattern, '', 1)
  if ($newHtml -eq $html) {
    Write-Error "[$route] failed to remove noindex meta tag"
  }
  if ($route -eq '/privacy/') {
    $newHtml = $newHtml.Replace(
      'This pre-launch page carries <code>noindex</code> until release gates are cleared.',
      'Public pages are indexable after governed release activation; scanner inputs remain optional and must not require sensitive personal data.'
    )
  }
  [System.IO.File]::WriteAllText($pagePath, $newHtml, [System.Text.UTF8Encoding]::new($false))
  $updated++
  Write-Host "  OK    Removed noindex from $route"
}

$robotsPath = Join-Path $root 'robots.txt'
$robotsContent = @'
# AIDAtanaly.com — robots policy
# Phase: public indexed reference release (active)
# Governed by: PUBLIC_RELEASE_PLAN.md (PUB-REL-001)
#
# Repository governance artifacts remain outside the public website deployment package.

User-agent: *
Allow: /

Sitemap: https://aidatanaly.com/sitemap.xml
'@
[System.IO.File]::WriteAllText($robotsPath, $robotsContent.TrimEnd() + "`r`n", [System.Text.UTF8Encoding]::new($false))
Write-Host '  OK    Activated robots.txt (Allow + Sitemap)'

Write-Host "  INFO  Updated $updated/41 launch routes; preview/ and repository artifacts untouched"
Write-Host '=== Done ==='
