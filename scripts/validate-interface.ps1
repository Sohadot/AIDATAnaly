# validate-interface.ps1
# Sprint 2 acceptance checks for the AIDAtanaly interface foundation.
# Governed by: INTERFACE_GOVERNANCE.md v1.0, IMPLEMENTATION_PLAN.md (IMPL-PLAN-001).

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()
$passes = @()

function Pass([string]$msg) { $script:passes += $msg; Write-Host "  PASS  $msg" }
function Fail([string]$msg) { $script:failures += $msg; Write-Host "  FAIL  $msg" }

Write-Host "=== AIDAtanaly Interface Foundation Validation ==="

# --- 1. Required asset files exist ------------------------------------------
$cssPath = Join-Path $root 'assets/css/main.css'
$jsPath  = Join-Path $root 'assets/js/scanner.js'
if ((Test-Path $cssPath) -and (Get-Item $cssPath).Length -gt 1000) {
  Pass "assets/css/main.css exists and is substantive"
} else { Fail "assets/css/main.css missing or empty" }
if (Test-Path $jsPath) { Pass "assets/js/scanner.js placeholder exists" }
else { Fail "assets/js/scanner.js missing" }

$css = Get-Content -Raw -Encoding UTF8 -Path $cssPath
$js  = Get-Content -Raw -Encoding UTF8 -Path $jsPath
$htmlFiles = Get-ChildItem -Path $root -Recurse -Filter '*.html' -File |
  Where-Object { $_.FullName -notmatch '\\(node_modules|\.git)\\' }

# --- 2. No external dependencies (JS, CSS, fonts) ----------------------------
$externalViolations = @()
foreach ($h in $htmlFiles) {
  $content = Get-Content -Raw -Encoding UTF8 -Path $h.FullName
  if ($content -match '<script[^>]+src\s*=\s*["'']https?://') { $externalViolations += "$($h.Name): external <script src>" }
  # Only resource-loading links count as dependencies; rel="canonical" is governed metadata.
  foreach ($linkTag in [regex]::Matches($content, '<link[^>]+>')) {
    if ($linkTag.Value -match 'href\s*=\s*["'']https?://' -and $linkTag.Value -notmatch 'rel\s*=\s*["'']canonical') {
      $externalViolations += "$($h.Name): external <link href>"
    }
  }
}
if ($css -match '@import\s+url\(\s*["'']?https?://') { $externalViolations += 'main.css: external @import' }
if ($css -match 'fonts\.googleapis|fonts\.gstatic|use\.typekit|cdn\.') { $externalViolations += 'main.css: external font/CDN reference' }
if ($js -match 'https?://') { $externalViolations += 'scanner.js: external URL' }
if (-not $externalViolations) { Pass "No external JS, CSS, font, or CDN dependencies" }
else { foreach ($v in $externalViolations) { Fail "External dependency: $v" } }

# --- 3. No WebGL / 3D / heavy canvas ------------------------------------------
$prohibitedTech = 'webgl|three\.js|babylon|getContext\(|<canvas'
$techViolations = @()
if ($css -match $prohibitedTech) { $techViolations += 'main.css' }
if ($js -match $prohibitedTech) { $techViolations += 'scanner.js' }
foreach ($h in $htmlFiles) {
  if ((Get-Content -Raw -Encoding UTF8 -Path $h.FullName) -match $prohibitedTech) { $techViolations += $h.Name }
}
if (-not $techViolations) { Pass "No WebGL, 3D, or canvas rendering anywhere" }
else { foreach ($v in $techViolations) { Fail "Prohibited rendering tech in: $v" } }

# --- 4. No animation libraries / prohibited motion patterns -------------------
$prohibitedLibs = 'gsap|lottie|anime\.js|animejs|swiper|slick|aos\.|scrollmagic|locomotive|parallax|particles'
$libViolations = @()
if ($css -match $prohibitedLibs) { $libViolations += 'main.css' }
if ($js -match $prohibitedLibs) { $libViolations += 'scanner.js' }
foreach ($h in $htmlFiles) {
  if ((Get-Content -Raw -Encoding UTF8 -Path $h.FullName) -match $prohibitedLibs) { $libViolations += $h.Name }
}
if (-not $libViolations) { Pass "No animation libraries or prohibited motion patterns" }
else { foreach ($v in $libViolations) { Fail "Prohibited library/pattern in: $v" } }

# --- 5. prefers-reduced-motion supported --------------------------------------
if ($css -match '@media\s*\(\s*prefers-reduced-motion\s*:\s*reduce\s*\)') {
  Pass "prefers-reduced-motion is supported with a reduce block"
} else { Fail "prefers-reduced-motion block missing in main.css" }

# --- 6. Required governed component classes exist ------------------------------
$requiredClasses = @(
  '.doctrine-statement',
  '.transition-axis',
  '.transition-axis__state',
  '.transition-axis__vector',
  '.vector-card',
  '.badge-diagnostic',
  '.badge-diagnostic--strong',
  '.badge-diagnostic--functional',
  '.badge-diagnostic--unstable',
  '.badge-diagnostic--constrained',
  '.badge-diagnostic--critical',
  '.badge-evidence',
  '.badge-evidence--e0',
  '.stable-id-chip',
  '.reference-links',
  '.evidence-unscorable',
  '.dossier-block',
  '.intervention-tag',
  '.scanner-panel',
  '.score-panel'
)
$missingClasses = $requiredClasses | Where-Object { $css -notmatch [regex]::Escape($_) }
if (-not $missingClasses) {
  Pass "All $($requiredClasses.Count) governed component classes are defined (8 Sprint 2 components + 4 preliminary bases)"
} else {
  foreach ($m in $missingClasses) { Fail "Component class missing: $m" }
}

# --- 7. Evidence styling never uses the diagnostic scale -----------------------
# Sections are delimited by '=== SECTION:' markers; the EVIDENCE section
# must not reference any --diag-* variable.
$sections = [regex]::Split($css, '/\* === SECTION:')
$evidenceSection = $sections | Where-Object { $_ -match '^\s*EVIDENCE' }
if ($evidenceSection) {
  if ($evidenceSection -notmatch '--diag-') {
    Pass "Evidence Confidence styling uses neutral tones only (no --diag-* variables in EVIDENCE section)"
  } else { Fail "EVIDENCE section references diagnostic scale variables" }
} else { Fail "EVIDENCE section marker not found in main.css" }

# --- 8. Diagnostic variables stay on diagnostic surfaces ------------------------
$diagAllowedSections = @('TOKENS', 'DIAGNOSTIC', 'TRANSITION AXIS')
$diagLeaks = @()
foreach ($s in $sections) {
  if ($s -match '^\s*([A-Z ]+?)\s*=') {
    $name = $Matches[1].Trim()
    if (($s -match '--diag-') -and ($diagAllowedSections -notcontains $name)) { $diagLeaks += $name }
  }
}
if (-not $diagLeaks) { Pass "Diagnostic scale colors appear only in TOKENS, DIAGNOSTIC, and TRANSITION AXIS sections" }
else { foreach ($l in $diagLeaks) { Fail "Diagnostic scale leaked into section: $l" } }

# --- 9. Unscorable state: explicit, non-numeric --------------------------------
if (($css -match '\.evidence-unscorable') -and ($css -match 'No numeric display')) {
  Pass "Unscorable State component defined with non-numeric, measurement-gap treatment"
} else { Fail "Unscorable State component missing or undocumented" }

# --- 10. Transition Axis is responsive ------------------------------------------
$mediaBlocks = [regex]::Matches($css, '@media\s*\(min-width:[^{]+\)')
$hasResponsiveAxis = $css -match '@media\s*\(min-width:[^)]+\)[\s\S]{0,400}\.transition-axis'
if ($hasResponsiveAxis) {
  Pass "Transition Axis is responsive (vertical mobile-first, horizontal at min-width breakpoint)"
} else { Fail "Transition Axis has no responsive breakpoint" }

# --- 11. Preview page: noindex and readable without JavaScript ------------------
$previewPath = Join-Path $root 'preview/index.html'
if (Test-Path $previewPath) {
  $preview = Get-Content -Raw -Encoding UTF8 -Path $previewPath
  if ($preview -match '<meta\s+name="robots"\s+content="noindex') { Pass "Preview page carries noindex, nofollow" }
  else { Fail "Preview page missing noindex meta" }
  if ($preview -notmatch '<script') { Pass "Preview page contains zero <script> tags: fully readable without JavaScript" }
  else { Fail "Preview page depends on JavaScript" }
  if ($preview -match 'badge-evidence' -and $preview -match 'badge-diagnostic') {
    Pass "Preview renders Evidence badge and Diagnostic badge as separate components"
  } else { Fail "Preview missing badge separation demonstration" }
  if ($preview -match 'Unscorable' -and $preview -notmatch 'T4:\s*\d') {
    Pass "E0 renders as 'Unscorable', never as a number"
  } else { Fail "E0/Unscorable rendering incorrect in preview" }
} else { Fail "preview/index.html missing" }

# --- 12. Motion durations within governed range ----------------------------------
$durations = [regex]::Matches($css, '--motion-(?:fast|base|slow):\s*(\d+)ms') | ForEach-Object { [int]$_.Groups[1].Value }
$outOfRange = $durations | Where-Object { $_ -lt 200 -or $_ -gt 600 }
if ($durations.Count -gt 0 -and -not $outOfRange) {
  Pass "Interface motion tokens within governed 200-600ms range"
} else { Fail "Motion duration tokens out of governed range: $($outOfRange -join ', ')" }

# --- 13. scanner.js contains no logic and no rule duplication --------------------
if ($js -match 'PLACEHOLDER' -and $js -notmatch 'addEventListener|fetch\(|querySelector') {
  Pass "scanner.js is a governed placeholder with no scanner logic"
} else { Fail "scanner.js contains premature logic" }

# --- Summary ----------------------------------------------------------------------
Write-Host ""
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 } else { exit 0 }
