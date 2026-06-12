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

# --- 10. Transition Axis responsive (Patch 12A) ---------------------------------
if ($css -match '\.transition-axis\s*\{[^}]*flex-direction:\s*column') {
  Pass "Transition Axis defaults to vertical column (mobile-first grammar)"
} else { Fail "Transition Axis missing vertical mobile-first column layout" }

if ($css -match '@media\s*\(\s*min-width:\s*64rem\s*\)[\s\S]{0,1200}\.transition-axis[\s\S]{0,300}flex-direction:\s*row') {
  Pass "Horizontal axis activates at 64rem (no squeeze on narrow viewports)"
} else { Fail "Transition Axis horizontal breakpoint missing or below 64rem" }

$vectorLabelBase = [regex]::Match($css, '\.transition-axis__vector-label\s*\{[^}]+\}').Value
if ($vectorLabelBase -match 'white-space:\s*normal') {
  Pass "Vector labels wrap on narrow viewports (overlap prevention)"
} else { Fail "Vector labels do not allow wrapping on narrow viewports" }

if ($css -match '\.transition-axis__state[\s\S]{0,500}font-weight:\s*500' -and
    $css -match '\.transition-axis__vector-label[\s\S]{0,500}font-weight:\s*700') {
  Pass "States are quiet; vector labels carry stronger visual weight"
} else { Fail "Transition Axis state/vector visual hierarchy not enforced" }

if ($css -match '\.transition-axis__vector-code' -and $css -match '\.transition-axis__vector-name') {
  Pass "Structured transition labels supported (T-code and name grammar)"
} else { Fail "Transition Axis missing structured label classes" }

$previewPath = Join-Path $root 'preview/index.html'
if (Test-Path $previewPath) {
  $preview = Get-Content -Raw -Encoding UTF8 -Path $previewPath
  if ($preview -match 'transition-axis__vector-code' -and $preview -match 'Signal Conversion') {
    Pass "Preview demonstrates vertical transition grammar with full T1-T4 names"
  } else { Fail "Preview missing vertical transition grammar demo" }
} else { Fail "preview/index.html missing (Patch 12A axis demo)" }

# --- 11. Preview page: noindex and readable without JavaScript ------------------
if (Test-Path $previewPath) {
  if (-not $preview) { $preview = Get-Content -Raw -Encoding UTF8 -Path $previewPath }
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

# --- 12. Transition health visual language (Patch 12B) --------------------------
$healthModifiers = @(
  'transition-axis__vector--reference',
  'transition-axis__vector--strong',
  'transition-axis__vector--functional',
  'transition-axis__vector--unstable',
  'transition-axis__vector--constrained',
  'transition-axis__vector--critical',
  'transition-axis__vector--unscorable'
)
$missingHealth = $healthModifiers | Where-Object { $css -notmatch [regex]::Escape(".${_}") }
if (-not $missingHealth) {
  Pass "All transition health modifiers defined (reference + five diagnostic + unscorable)"
} else {
  foreach ($m in $missingHealth) { Fail "Transition health modifier missing: $m" }
}

$axisSection = ($sections | Where-Object { $_ -match '^\s*TRANSITION AXIS' } | Select-Object -First 1)
if ($axisSection) {
  if ($axisSection -match '\.transition-axis__vector--unscorable::before[\s\S]{0,400}--line-strong' -and
      $axisSection -notmatch '\.transition-axis__vector--unscorable::before[\s\S]{0,400}--diag-') {
    Pass "Unscorable vector line uses neutral tones only (no diagnostic scale on line)"
  } else { Fail "Unscorable vector line must use neutral tones, not diagnostic scale" }

  if ($axisSection -notmatch '--evidence-') {
    Pass "Transition health line rules do not reference Evidence Confidence variables"
  } else { Fail "Transition health line rules reference Evidence Confidence variables" }

  if ($axisSection -match 'border-style:\s*(dashed|dotted)' -and
      $axisSection -match '\.transition-axis__vector--(?:unstable|constrained|critical)[\s\S]{0,300}opacity:') {
    Pass "Health meaning uses continuity patterns, opacity, and label treatment (not color alone)"
  } else { Fail "Transition health visual language must not rely on color alone" }
} else { Fail "TRANSITION AXIS section marker not found for Patch 12B checks" }

if (Test-Path $previewPath) {
  if (-not $preview) { $preview = Get-Content -Raw -Encoding UTF8 -Path $previewPath }
  $previewAxisDemos = @(
    'Reference Axis',
    'Strong Axis',
    'Functional Axis',
    'Unstable Axis',
    'Constrained Axis',
    'Critical Axis',
    'Unscorable Axis',
    'Mixed Diagnostic Axis'
  )
  $missingDemos = $previewAxisDemos | Where-Object { $preview -notmatch [regex]::Escape($_) }
  if (-not $missingDemos) {
    Pass "Preview renders all transition health axis demonstrations"
  } else {
    foreach ($d in $missingDemos) { Fail "Preview missing axis demo: $d" }
  }
}

# --- 13. Motion durations within governed range ----------------------------------
$durations = [regex]::Matches($css, '--motion-(?:fast|base|slow):\s*(\d+)ms') | ForEach-Object { [int]$_.Groups[1].Value }
$outOfRange = $durations | Where-Object { $_ -lt 200 -or $_ -gt 600 }
if ($durations.Count -gt 0 -and -not $outOfRange) {
  Pass "Interface motion tokens within governed 200-600ms range"
} else { Fail "Motion duration tokens out of governed range: $($outOfRange -join ', ')" }

# --- 14. scanner.js implements governed v1 logic ---------------------------------
if ($js -match '/data/scanner-model\.json' -and
    $js -match '/data/tfo-failure-modes\.json' -and
    $js -match 'Unscorable' -and
    $js -match 'partial' -and
    $js -notmatch 'https?://' -and
    $js -notmatch 'evidence_confidence_weight') {
  Pass "scanner.js implements governed Transition Scanner v1 from /data/ registry"
} else { Fail "scanner.js missing governed scanner v1 implementation" }

# --- 15. Failure Lens component (Patch 12C) -------------------------------------
$lensCssPath = Join-Path $root 'assets/css/failure-lens.css'
if ((Test-Path $lensCssPath) -and (Get-Item $lensCssPath).Length -gt 200) {
  Pass "assets/css/failure-lens.css exists and is substantive"
} else { Fail "assets/css/failure-lens.css missing or empty" }

$lensCss = if (Test-Path $lensCssPath) { Get-Content -Raw -Encoding UTF8 -Path $lensCssPath } else { '' }
if ($lensCss -notmatch '@import\s+url\(\s*["'']?https?://' -and $lensCss -notmatch 'https?://') {
  Pass "failure-lens.css has no external imports or URLs"
} else { Fail "failure-lens.css references external resources" }

if ($lensCss -notmatch '--evidence-' -and $lensCss -notmatch 'badge-evidence' -and $lensCss -notmatch 'score-panel') {
  Pass "failure-lens.css excludes evidence colors and scoring surfaces"
} else { Fail "failure-lens.css must not define evidence or scoring styling" }

if ($lensCss -notmatch 'webgl|getContext\(|<canvas|linear-gradient\([^v]') {
  Pass "failure-lens.css avoids prohibited rendering and decorative gradients"
} else { Fail "failure-lens.css contains prohibited visual patterns" }

if ($lensCss -match '\.failure-lens' -and $lensCss -match 'var\(--') {
  Pass "failure-lens.css uses governed tokens from main.css"
} else { Fail "failure-lens.css must use main.css design tokens" }

$lensPages = Get-ChildItem -Path $root -Recurse -Filter 'index.html' -File |
  Where-Object {
    $_.FullName -match '\\(vectors|failure-modes)\\' -or $_.FullName -match '\\preview\\'
  }
$lensLinkFailures = @()
foreach ($lp in $lensPages) {
  $pc = Get-Content -Raw -Encoding UTF8 -Path $lp.FullName
  if ($pc -match 'class="failure-lens"' -and $pc -notmatch 'failure-lens\.css') {
    $lensLinkFailures += $lp.FullName.Substring($root.Length).TrimStart('\')
  }
}
if (-not $lensLinkFailures) {
  Pass "All pages using .failure-lens link failure-lens.css"
} else {
  foreach ($f in $lensLinkFailures) { Fail "Page uses .failure-lens but omits failure-lens.css: $f" }
}

$homePath = Join-Path $root 'index.html'
$homeHtml = Get-Content -Raw -Encoding UTF8 -Path $homePath
if ($homeHtml -notmatch 'failure-lens\.css' -and $homeHtml -notmatch 'class="failure-lens"') {
  Pass "Homepage does not load unused failure-lens.css"
} else { Fail "Homepage must not link failure-lens.css without using the component" }

if (Test-Path $previewPath) {
  if (-not $preview) { $preview = Get-Content -Raw -Encoding UTF8 -Path $previewPath }
  if ($preview -match 'class="failure-lens"' -and $preview -match 'failure-lens\.css') {
    Pass "Preview demonstrates Failure Lens with dedicated stylesheet"
  } else { Fail "Preview missing Failure Lens demo or stylesheet link" }
}

# --- Summary ----------------------------------------------------------------------
Write-Host ""
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 } else { exit 0 }
