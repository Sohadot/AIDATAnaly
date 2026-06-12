# validate-deploy.ps1
# Sprint 12G — main-only deployment policy checks (PUB-REL-002).
# Governed by: DECISION_MAIN_ONLY_DEPLOYMENT_POLICY.md

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()
$passes = @()

function Pass([string]$msg) { $script:passes += $msg; Write-Host "  PASS  $msg" }
function Fail([string]$msg) { $script:failures += $msg; Write-Host "  FAIL  $msg" }

Write-Host '=== AIDAtanaly Main-Only Deployment Validation ==='

$decisionPath = Join-Path $root 'governance/decisions/DECISION_MAIN_ONLY_DEPLOYMENT_POLICY.md'
if (Test-Path $decisionPath) {
  Pass 'PUB-REL-002 decision log exists'
} else { Fail 'governance/decisions/DECISION_MAIN_ONLY_DEPLOYMENT_POLICY.md missing' }

$workflowPath = Join-Path $root '.github/workflows/pages.yml'
if (Test-Path $workflowPath) {
  $workflow = Get-Content -Raw -Encoding UTF8 -Path $workflowPath
  if ($workflow -match 'branches:\s*\[main\]' -or $workflow -match 'branches:\s*\[\s*main\s*\]') {
    Pass 'Pages workflow triggers on main only'
  } else { Fail 'Pages workflow must trigger on main branch' }

  if ($workflow -match 'quality-gate\.ps1.*-IndexedRelease') {
    Pass 'Pages workflow runs indexed release quality gate before publish'
  } else { Fail 'Pages workflow must run quality-gate.ps1 -IndexedRelease' }

  if ($workflow -match 'upload-pages-artifact' -and $workflow -match 'path:\s*dist') {
    Pass 'Pages workflow uploads dist/ as the artifact'
  } else { Fail 'Pages workflow must upload dist/ artifact' }

  if ($workflow -match 'deploy-pages' -and $workflow -match 'id-token:\s*write') {
    Pass 'Pages workflow uses deploy-pages with OIDC permissions'
  } else { Fail 'Pages workflow missing deploy-pages or id-token permission' }

  if ($workflow -notmatch '(?m)^[^#]*gh-pages' -and $workflow -notmatch 'HEAD:gh-pages') {
    Pass 'Pages workflow does not reference gh-pages branch deployment'
  } else { Fail 'Pages workflow must not reference gh-pages branch deployment' }
} else { Fail '.github/workflows/pages.yml missing' }

$deployScript = Join-Path $root 'scripts/deploy-dist.ps1'
if (Test-Path $deployScript) {
  $deploy = Get-Content -Raw -Encoding UTF8 -Path $deployScript
  if ($deploy -notmatch 'git push.*gh-pages' -and $deploy -notmatch 'HEAD:gh-pages') {
    Pass 'deploy-dist.ps1 does not push to gh-pages'
  } else { Fail 'deploy-dist.ps1 must not push to gh-pages (retired by PUB-REL-002)' }

  if ($deploy -match 'GitHub Actions' -or $deploy -match 'pages\.yml') {
    Pass 'deploy-dist.ps1 documents GitHub Actions deployment path'
  } else { Fail 'deploy-dist.ps1 must document GitHub Actions deployment' }
} else { Fail 'scripts/deploy-dist.ps1 missing' }

$gitignorePath = Join-Path $root '.gitignore'
if (Test-Path $gitignorePath) {
  $gitignore = Get-Content -Raw -Encoding UTF8 -Path $gitignorePath
  if ($gitignore -match '(?m)^dist/?$' -or $gitignore -match 'dist/') {
    Pass 'dist/ remains gitignored (not committed as website source)'
  } else { Fail '.gitignore must exclude dist/' }
} else { Fail '.gitignore missing' }

Write-Host ''
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 } else { exit 0 }
