# quality-gate.ps1
# Sprint 9 — governed pre-release quality gate (private preview ready, not public indexed).
# Governed by: IMPLEMENTATION_PLAN.md Sprint 9, scripts/README.md.
#
# Runs all validators in order, regenerates sitemap, re-validates pages, and prints
# a single release posture report. Does NOT remove noindex or enable public indexing.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$scriptsDir = $PSScriptRoot

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

function Get-SiteMetrics {
  param([string]$Root)

  $launchRoutes = Get-LaunchRoutes (Join-Path $Root 'ROUTE_MAP.md')
  $launchPageRoutes = @($launchRoutes | Where-Object { $_ -notmatch '\.json$' })

  $pages = @{}
  foreach ($route in $launchPageRoutes) {
    $pagePath = Get-PagePath $route $Root
    if (Test-Path $pagePath) {
      $pages[$route] = Get-Content -Raw -Encoding UTF8 -Path $pagePath
    }
  }

  $brokenLinks = 0
  foreach ($route in $pages.Keys) {
    $hrefs = [regex]::Matches($pages[$route], 'href="(/[^"]*)"') |
      ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
    foreach ($h in $hrefs) {
      if ($h -match '^/assets/') { continue }
      if (-not $pages.ContainsKey($h)) { $brokenLinks++ }
    }
  }

  $inboundCount = @{}
  foreach ($r in $pages.Keys) { $inboundCount[$r] = 0 }
  foreach ($route in $pages.Keys) {
    $hrefs = [regex]::Matches($pages[$route], 'href="(/[^"]*)"') |
      ForEach-Object { $_.Groups[1].Value }
    foreach ($h in $hrefs) {
      if ($h -match '^/assets/') { continue }
      if ($pages.ContainsKey($h)) { $inboundCount[$h]++ }
    }
  }
  $orphanPages = @($pages.Keys | Where-Object { $_ -ne '/' -and $inboundCount[$_] -eq 0 }).Count

  $sitemapCount = 0
  $sitemapPath = Join-Path $Root 'sitemap.xml'
  if (Test-Path $sitemapPath) {
    $sitemap = Get-Content -Raw -Encoding UTF8 -Path $sitemapPath
    $sitemapCount = ([regex]::Matches($sitemap, '<loc>([^<]+)</loc>')).Count
  }

  $robotsOk = $false
  $sitemapDirectiveInactive = $true
  $robotsPath = Join-Path $Root 'robots.txt'
  if (Test-Path $robotsPath) {
    $robots = Get-Content -Raw -Encoding UTF8 -Path $robotsPath
    $robotsOk = $robots -match '(?m)^Disallow:\s*/\s*$'
    $sitemapDirectiveInactive = -not ($robots -match '(?m)^Sitemap:\s*https://')
  }

  $noindexMissing = @($pages.Keys | Where-Object {
    $pages[$_] -notmatch '<meta\s+name="robots"\s+content="noindex"'
  }).Count

  return [pscustomobject]@{
    RequiredLaunchRoutes     = $pages.Count
    RequiredLaunchTotal      = $launchPageRoutes.Count
    BrokenLinks              = $brokenLinks
    OrphanPages              = $orphanPages
    SitemapUrlCount          = $sitemapCount
    RobotsDisallowRoot       = $robotsOk
    RobotsSitemapInactive    = $sitemapDirectiveInactive
    PagesMissingNoindex      = $noindexMissing
  }
}

function Invoke-GovernedStep {
  param(
    [string]$Label,
    [string]$ScriptName
  )

  $scriptPath = Join-Path $scriptsDir $ScriptName
  if (-not (Test-Path $scriptPath)) {
    Write-Host ""
    Write-Host "=== Step: $Label ($ScriptName) ==="
    Write-Host "  FAIL  Script not found: $scriptPath"
    return $false
  }

  Write-Host ""
  Write-Host "=== Step: $Label ($ScriptName) ==="
  & $scriptPath
  $exitCode = $LASTEXITCODE
  if ($null -eq $exitCode) { $exitCode = 0 }

  if ($exitCode -ne 0) {
    Write-Host "  GATE  $Label FAILED (exit $exitCode)"
    return $false
  }

  Write-Host "  GATE  $Label PASSED"
  return $true
}

Write-Host '=== AIDAtanaly Pre-Release Quality Gate (Sprint 9) ==='
Write-Host '  INFO  Private preview posture only - noindex and Disallow root must remain'
Write-Host ""

$dataOk = Invoke-GovernedStep -Label 'Data' -ScriptName 'validate-data.ps1'
$interfaceOk = Invoke-GovernedStep -Label 'Interface' -ScriptName 'validate-interface.ps1'
$scannerOk = Invoke-GovernedStep -Label 'Scanner' -ScriptName 'validate-scanner.ps1'
$pagesOk1 = Invoke-GovernedStep -Label 'Pages (pre-sitemap)' -ScriptName 'validate-pages.ps1'
$sitemapOk = Invoke-GovernedStep -Label 'Sitemap generation' -ScriptName 'generate-sitemap.ps1'
$pagesOk2 = Invoke-GovernedStep -Label 'Pages (post-sitemap)' -ScriptName 'validate-pages.ps1'

$pagesOk = $pagesOk1 -and $pagesOk2
$metrics = Get-SiteMetrics -Root $root

$indexationOk = $metrics.RobotsDisallowRoot -and
  $metrics.RobotsSitemapInactive -and
  ($metrics.PagesMissingNoindex -eq 0)

$sitemapChecksOk = $sitemapOk -and ($metrics.SitemapUrlCount -eq 41)

$stepResults = @{
  Data      = $dataOk
  Interface = $interfaceOk
  Scanner   = $scannerOk
  Pages     = $pagesOk
  Sitemap   = $sitemapChecksOk
}

$overallOk = ($stepResults.Values | Where-Object { -not $_ }).Count -eq 0 -and $indexationOk

function Format-StepResult([bool]$Ok) { if ($Ok) { 'PASS' } else { 'FAIL' } }

Write-Host ""
Write-Host "=== Quality Gate Report ==="
Write-Host ""
Write-Host ("Quality Gate: {0}" -f (Format-StepResult $overallOk))
Write-Host ("Data: {0}" -f (Format-StepResult $stepResults.Data))
Write-Host ("Interface: {0}" -f (Format-StepResult $stepResults.Interface))
Write-Host ("Scanner: {0}" -f (Format-StepResult $stepResults.Scanner))
Write-Host ("Pages: {0}" -f (Format-StepResult $stepResults.Pages))
Write-Host ('Sitemap: {0}' -f (Format-StepResult $stepResults.Sitemap))
Write-Host "Indexation posture: NON-INDEXED"
Write-Host ("Required Launch Routes: {0}/{1}" -f $metrics.RequiredLaunchRoutes, $metrics.RequiredLaunchTotal)
Write-Host ("Broken Links: {0}" -f $metrics.BrokenLinks)
Write-Host ("Orphan Pages: {0}" -f $metrics.OrphanPages)
Write-Host ""

if (-not $indexationOk) {
  Write-Host '  FAIL  Indexation posture violated (noindex, Disallow root, or inactive sitemap directive required)'
  if (-not $metrics.RobotsDisallowRoot) { Write-Host '        robots.txt must keep Disallow: /' }
  if (-not $metrics.RobotsSitemapInactive) { Write-Host '        robots.txt must not declare an active Sitemap line' }
  if ($metrics.PagesMissingNoindex -gt 0) {
    Write-Host "        $($metrics.PagesMissingNoindex) page(s) missing noindex meta"
  }
}

Write-Host '=== End Quality Gate ==='

if (-not $overallOk) { exit 1 }
exit 0
