# validate-brand.ps1
# Sprint 13D — brand spelling and evidence hygiene checks (BRAND-001).
# Governed by: governance/decisions/DECISION_BRAND_SPELLING_1_0_RATIFICATION.md,
#              external/EXTERNAL_PUBLICATION_POLICY.md

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()
$passes = @()

function Pass([string]$msg) { $script:passes += $msg; Write-Host "  PASS  $msg" }
function Fail([string]$msg) { $script:failures += $msg; Write-Host "  FAIL  $msg" }

Write-Host '=== AIDATAnaly Brand and Evidence Hygiene Validation ==='

$canonical = 'AIDATAnaly'
# Legacy spelling constructed at runtime so this validator never contains it literally
$legacy = 'AIDA' + 'tanaly'
$allowRel = @('governance/decisions/DECISION_BRAND_SPELLING_1_0_RATIFICATION.md')

$textExt = @('.md', '.html', '.txt', '.json', '.js', '.css', '.ps1', '.py', '.xml', '.yml')
$files = Get-ChildItem -Path $root -Recurse -File | Where-Object {
  $_.FullName -notmatch '[\\/](\.git|dist|node_modules)([\\/]|$)' -and
  $textExt -contains $_.Extension -and
  $_.FullName -ne $PSCommandPath
}

# --- 1. Legacy spelling must not appear outside the BRAND-001 decision log -----
$legacyHits = @()
foreach ($f in $files) {
  $rel = $f.FullName.Substring($root.Length).TrimStart('\', '/').Replace('\', '/')
  if ($allowRel -contains $rel) { continue }
  $raw = Get-Content -Raw -Encoding UTF8 -Path $f.FullName
  if ($raw.Contains($legacy)) { $legacyHits += $rel }
}
if (-not $legacyHits) { Pass 'legacy brand spelling absent outside BRAND-001 decision log' }
else { foreach ($h in $legacyHits) { Fail "legacy brand spelling present: $h" } }

# --- 2. Canonical spelling present where the brand is introduced ---------------
foreach ($rel in @('README.md', 'llms.txt')) {
  $p = Join-Path $root $rel
  if ((Test-Path $p) -and ((Get-Content -Raw -Encoding UTF8 -Path $p).Contains($canonical))) {
    Pass "canonical brand spelling present in $rel"
  } else { Fail "canonical brand spelling missing in $rel" }
}

# --- 3. Canonical URL stays lowercase -------------------------------------------
$llms = Get-Content -Raw -Encoding UTF8 -Path (Join-Path $root 'llms.txt')
if ($llms.Contains('https://aidatanaly.com/')) { Pass 'canonical lowercase URL present in llms.txt' }
else { Fail 'llms.txt missing canonical lowercase URL' }

$recasedUrl = @()
foreach ($f in $files) {
  $raw = Get-Content -Raw -Encoding UTF8 -Path $f.FullName
  if ($raw.Contains('//' + $canonical)) {
    $recasedUrl += $f.FullName.Substring($root.Length).TrimStart('\', '/')
  }
}
if (-not $recasedUrl) { Pass 'no re-cased brand URLs (URLs remain lowercase)' }
else { foreach ($h in $recasedUrl) { Fail "re-cased brand URL found: $h" } }

# --- 4. Evidence hygiene: no engagement metrics stored in the repository --------
$metricPattern = '(?i)\b\d+\s+(likes?|impressions?|reactions?|retweets?|reposts?|followers?|upvotes?)\b'
$metricHits = @()
foreach ($f in ($files | Where-Object { $_.Extension -in @('.md', '.html', '.txt') })) {
  $raw = Get-Content -Raw -Encoding UTF8 -Path $f.FullName
  if ($raw -match $metricPattern) {
    $metricHits += $f.FullName.Substring($root.Length).TrimStart('\', '/')
  }
}
if (-not $metricHits) { Pass 'no social engagement metrics stored in repository' }
else { foreach ($h in $metricHits) { Fail "engagement metric text found: $h" } }

# --- 5. Evidence hygiene: no social post links without a governance decision ----
$socialPattern = 'https?://(www\.)?(linkedin\.com|x\.com|twitter\.com)/'
$socialHits = @()
foreach ($f in $files) {
  $raw = Get-Content -Raw -Encoding UTF8 -Path $f.FullName
  if ($raw -match $socialPattern) {
    $socialHits += $f.FullName.Substring($root.Length).TrimStart('\', '/')
  }
}
if (-not $socialHits) { Pass 'no social platform links stored in repository' }
else { foreach ($h in $socialHits) { Fail "social platform link found (requires governance decision): $h" } }

# --- 6. Required governance policies present -------------------------------------
foreach ($rel in @(
    'governance/policies/CLAIM_BOUNDARY.md',
    'external/EXTERNAL_PUBLICATION_POLICY.md',
    'governance/decisions/DECISION_BRAND_SPELLING_1_0_RATIFICATION.md')) {
  if (Test-Path (Join-Path $root ($rel -replace '/', [IO.Path]::DirectorySeparatorChar))) {
    Pass "required policy present: $rel"
  } else { Fail "required policy missing: $rel" }
}

Write-Host ''
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 }
exit 0
