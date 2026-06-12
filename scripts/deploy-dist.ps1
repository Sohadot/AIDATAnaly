# deploy-dist.ps1
# Sprint 12G — local deployment preflight (main-only / GitHub Actions).
# Governed by: DECISION_MAIN_ONLY_DEPLOYMENT_POLICY.md (PUB-REL-002).
#
# Public deployment is NOT performed by this script.
# Push to main to trigger .github/workflows/pages.yml (GitHub Pages artifact).

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$scriptsDir = $PSScriptRoot

Write-Host '=== AIDAtanaly Deploy Preflight (main-only) ==='
Write-Host '  INFO  gh-pages branch deployment is RETIRED (PUB-REL-002).'
Write-Host '  INFO  Public deploy: push to main → GitHub Actions → Pages artifact from dist/.'
Write-Host '  INFO  GitHub → Settings → Pages → Source must be GitHub Actions.'
Write-Host ''

& (Join-Path $scriptsDir 'build-dist.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& (Join-Path $scriptsDir 'validate-dist.ps1') -IndexedRelease
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& (Join-Path $scriptsDir 'validate-deploy.ps1')
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ''
Write-Host '  OK    Local dist/ package ready for GitHub Actions deployment'
Write-Host '  NEXT  git push origin main (or run workflow_dispatch on Deploy GitHub Pages)'
Write-Host '=== Done ==='
