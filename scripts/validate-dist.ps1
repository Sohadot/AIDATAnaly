# validate-dist.ps1
# Sprint 11 — validates dist/ as the governed deployment package (pre-indexation activation).
# Governed by: PUBLIC_RELEASE_PLAN.md (PUB-REL-001), scripts/README.md.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$distRoot = Join-Path $root 'dist'
$failures = @()
$passes = @()

function Pass([string]$msg) { $script:passes += $msg; Write-Host "  PASS  $msg" }
function Fail([string]$msg) { $script:failures += $msg; Write-Host "  FAIL  $msg" }

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

Write-Host '=== AIDAtanaly Dist Package Validation (Sprint 11) ==='

if (-not (Test-Path $distRoot)) {
  Fail 'dist/ missing (run scripts/build-dist.ps1)'
  Write-Host ''
  Write-Host "=== Summary: 0 passed, $($failures.Count) failed ==="
  exit 1
}
Pass 'dist/ exists'

$forbiddenDirs = @(
  'scripts',
  'preview',
  (Join-Path 'governance' 'decisions')
)
foreach ($rel in $forbiddenDirs) {
  $path = Join-Path $distRoot $rel
  if (Test-Path $path) { Fail "forbidden directory present in dist: $rel" }
  else { Pass "dist excludes $rel" }
}

$forbiddenFiles = @()
Get-ChildItem -Path $distRoot -Recurse -File | ForEach-Object {
  $rel = $_.FullName.Substring($distRoot.Length).Replace('\', '/')
  if ($_.Name -eq '.gitkeep') { $forbiddenFiles += $rel }
  if ($_.Extension -eq '.md') { $forbiddenFiles += $rel }
}

if (-not $forbiddenFiles) {
  Pass 'forbidden deployment files = 0 (no .md or .gitkeep in dist)'
} else {
  foreach ($f in $forbiddenFiles) { Fail "forbidden deployment file in dist: $f" }
}

$requiredTop = @(
  'index.html',
  'sitemap.xml',
  'robots.txt',
  'assets/css/main.css',
  'assets/js/scanner.js',
  'data/ati-standard.json',
  'data/ati-vectors.json',
  'data/tfo-failure-modes.json',
  'data/intervention-layers.json',
  'data/scanner-model.json',
  'governance/index.html'
)
foreach ($rel in $requiredTop) {
  $path = Join-Path $distRoot ($rel -replace '/', '\')
  if (Test-Path $path) { Pass "required artifact present: $rel" }
  else { Fail "required artifact missing: $rel" }
}

$launchRoutes = Get-LaunchRoutes (Join-Path $root 'ROUTE_MAP.md')
$pageRoutes = @($launchRoutes | Where-Object { $_ -notmatch '\.json$' })
$missingRoutes = @()
foreach ($route in $pageRoutes) {
  if (-not (Test-Path (Get-PagePath $route $distRoot))) { $missingRoutes += $route }
}
if ($missingRoutes.Count -eq 0 -and $pageRoutes.Count -eq 41) {
  Pass 'dist Required Launch routes = 41/41'
} else {
  Fail "dist routes = $($pageRoutes.Count - $missingRoutes.Count)/41; missing: $($missingRoutes -join ', ')"
}

$sitemapPath = Join-Path $distRoot 'sitemap.xml'
if (Test-Path $sitemapPath) {
  $sitemap = Get-Content -Raw -Encoding UTF8 -Path $sitemapPath
  $locs = @([regex]::Matches($sitemap, '<loc>([^<]+)</loc>') | ForEach-Object { $_.Groups[1].Value })
  if ($locs.Count -eq 41) { Pass 'dist sitemap route count = 41' }
  else { Fail "dist sitemap route count = $($locs.Count) (expected 41)" }
}

$robotsPath = Join-Path $distRoot 'robots.txt'
if (Test-Path $robotsPath) {
  $robots = Get-Content -Raw -Encoding UTF8 -Path $robotsPath
  if ($robots -match '(?m)^Disallow:\s*/\s*$') {
    Pass 'dist robots.txt Disallow root (pre-activation package)'
  } else { Fail 'dist robots.txt must keep Disallow root before indexation activation' }
  if ($robots -match '(?m)^Sitemap:\s*https://') {
    Fail 'dist robots.txt must not declare active Sitemap before indexation activation'
  } else { Pass 'dist robots.txt has no active Sitemap directive (pre-activation)' }
}

$pages = @{}
foreach ($route in $pageRoutes) {
  $pagePath = Get-PagePath $route $distRoot
  if (Test-Path $pagePath) {
    $pages[$route] = Get-Content -Raw -Encoding UTF8 -Path $pagePath
  }
}
$noindexMissing = @($pages.Keys | Where-Object {
  $pages[$_] -notmatch '<meta\s+name="robots"\s+content="noindex"'
})
if (-not $noindexMissing) {
  Pass 'dist pages retain noindex (indexation not yet activated)'
} else {
  foreach ($n in $noindexMissing) { Fail "dist [$n] missing noindex before activation step" }
}

if ((Test-Path (Join-Path $distRoot 'governance\index.html')) -and -not (Test-Path (Join-Path $distRoot 'governance\decisions'))) {
  Pass 'dist /governance/ page present without decision log directory'
}

Write-Host ''
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 }
exit 0
