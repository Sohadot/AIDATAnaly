# build-dist.ps1
# Sprint 11 — builds dist/ as the governed public website deployment package.
# Governed by: PUBLIC_RELEASE_PLAN.md (PUB-REL-001), scripts/README.md.
#
# dist/ contains public website artifacts only. Repository governance files are excluded.
# Indexation activation (noindex removal, robots Allow) is NOT performed by this script.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$distRoot = Join-Path $root 'dist'

function Get-LaunchRoutes {
  param([string]$RouteMapPath)
  $lines = Get-Content -Encoding UTF8 -Path $RouteMapPath
  return @($lines | ForEach-Object { $_.Trim() } |
    Where-Object { $_ -match '^/[a-z0-9\-/\.]*$' } | Sort-Object -Unique)
}

function Get-PagePath {
  param([string]$Route, [string]$Root)
  if ($Route -eq '/') { return Join-Path $Root 'index.html' }
  $rel = ($Route.Trim('/') -replace '/', '\') + '\index.html'
  return Join-Path $Root $rel
}

function Copy-PublicFile {
  param(
    [string]$SourceFile,
    [string]$DestFile
  )
  if (-not (Test-Path $SourceFile)) {
    throw "Missing source file for dist build: $SourceFile"
  }
  $destDir = Split-Path -Parent $DestFile
  if ($destDir -and -not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
  }
  Copy-Item -Path $SourceFile -Destination $DestFile -Force
}

function Copy-PublicTree {
  param(
    [string]$SourceDir,
    [string]$DestDir
  )
  if (-not (Test-Path $SourceDir)) {
    throw "Missing source directory for dist build: $SourceDir"
  }
  if (-not (Test-Path $DestDir)) {
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
  }
  Get-ChildItem -Path $SourceDir -Recurse -File | ForEach-Object {
    if ($_.Name -eq '.gitkeep') { return }
    if ($_.Extension -eq '.md') { return }
    $rel = $_.FullName.Substring($SourceDir.Length).TrimStart('\')
    if ($rel -match '(?i)^decisions\\') { return }
    if ($rel -match '(?i)\\decisions\\') { return }
    $target = Join-Path $DestDir $rel
    Copy-PublicFile -SourceFile $_.FullName -DestFile $target
  }
}

Write-Host '=== AIDAtanaly Dist Build (Sprint 11) ==='

$sitemapScript = Join-Path $PSScriptRoot 'generate-sitemap.ps1'
& $sitemapScript
$genExit = $LASTEXITCODE
if ($null -eq $genExit) { $genExit = 0 }
if ($genExit -ne 0) { throw 'Sitemap generation failed before dist build' }

if (Test-Path $distRoot) {
  Remove-Item -Path $distRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $distRoot -Force | Out-Null

Copy-PublicFile -SourceFile (Join-Path $root 'index.html') -DestFile (Join-Path $distRoot 'index.html')

$publicDirs = @(
  'aida-transition-analytics',
  'transition-intelligence',
  'measurement-grammar',
  'aida-transition-index',
  'evidence-confidence',
  'intervention-layers',
  'vectors',
  'transition-failure-ontology',
  'failure-modes',
  'scanner',
  'reports',
  'methodology',
  'sources',
  'privacy',
  'terms',
  'assets',
  'data'
)

foreach ($dir in $publicDirs) {
  Copy-PublicTree -SourceDir (Join-Path $root $dir) -DestDir (Join-Path $distRoot $dir)
}

$govDist = Join-Path $distRoot 'governance'
New-Item -ItemType Directory -Path $govDist -Force | Out-Null
Copy-PublicFile -SourceFile (Join-Path $root 'governance\index.html') -DestFile (Join-Path $govDist 'index.html')

Copy-PublicFile -SourceFile (Join-Path $root 'sitemap.xml') -DestFile (Join-Path $distRoot 'sitemap.xml')
Copy-PublicFile -SourceFile (Join-Path $root 'robots.txt') -DestFile (Join-Path $distRoot 'robots.txt')

$launchRoutes = Get-LaunchRoutes (Join-Path $root 'ROUTE_MAP.md')
$pageRoutes = @($launchRoutes | Where-Object { $_ -notmatch '\.json$' })
$missing = @()
foreach ($route in $pageRoutes) {
  $distPage = Get-PagePath $route $distRoot
  if (-not (Test-Path $distPage)) { $missing += $route }
}

if ($missing.Count -gt 0) {
  throw "dist build missing Required Launch pages: $($missing -join ', ')"
}

$fileCount = (Get-ChildItem -Path $distRoot -Recurse -File).Count
Write-Host "  OK    Wrote $distRoot ($($pageRoutes.Count) routes, $fileCount files)"
Write-Host '  INFO  dist mirrors current repository indexation posture (no modification here)'
Write-Host '=== Done ==='
