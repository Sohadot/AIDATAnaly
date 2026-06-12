# deploy-dist.ps1
# Sprint 11 Phase 2 — deploy dist/ only to gh-pages (public website branch).
# Governed by: PUBLIC_RELEASE_PLAN.md (PUB-REL-001).

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$distRoot = Join-Path $root 'dist'

if (-not (Test-Path $distRoot)) {
  Write-Error 'dist/ missing. Run scripts/build-dist.ps1 after indexation activation.'
}

Write-Host '=== AIDAtanaly Dist Deploy (gh-pages) ==='

$remote = git -C $root remote get-url origin 2>$null
if (-not $remote) { Write-Error 'No git remote origin configured' }

$stageDir = Join-Path $env:TEMP ('aidatanaly-dist-deploy-' + [guid]::NewGuid().ToString('n'))
New-Item -ItemType Directory -Path $stageDir -Force | Out-Null

try {
  Copy-Item -Path (Join-Path $distRoot '*') -Destination $stageDir -Recurse -Force
  Push-Location $stageDir
  git init | Out-Null
  git add -A
  git -c user.email='deploy@aidatanaly.com' -c user.name='AIDAtanaly Deploy' commit -m 'Deploy public website from governed dist package' | Out-Null
  git branch -M gh-pages
  git push -f $remote HEAD:gh-pages
  Write-Host "  OK    Deployed dist/ to gh-pages on $remote"
} finally {
  Pop-Location
  if (Test-Path $stageDir) { Remove-Item -Path $stageDir -Recurse -Force -ErrorAction SilentlyContinue }
}

Write-Host '=== Done ==='
