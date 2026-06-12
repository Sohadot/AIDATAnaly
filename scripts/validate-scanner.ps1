# validate-scanner.ps1
# Sprint 6 acceptance checks for Transition Scanner v1.
# Governed by: SCANNER_MODEL.md v1.0, PAGE_BLUEPRINTS.md §16-17, INTERFACE_GOVERNANCE.md v1.0.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()
$passes = @()

function Pass([string]$msg) { $script:passes += $msg; Write-Host "  PASS  $msg" }
function Fail([string]$msg) { $script:failures += $msg; Write-Host "  FAIL  $msg" }

Write-Host "=== AIDAtanaly Scanner Validation ==="

$scannerHtmlPath = Join-Path $root 'scanner/index.html'
$jsPath = Join-Path $root 'assets/js/scanner.js'
$modelPath = Join-Path $root 'data/scanner-model.json'
$tfoPath = Join-Path $root 'data/tfo-failure-modes.json'

if (Test-Path $scannerHtmlPath) { Pass "/scanner/index.html exists" }
else { Fail "/scanner/index.html missing"; exit 1 }

if (Test-Path $jsPath) { Pass "assets/js/scanner.js exists" }
else { Fail "assets/js/scanner.js missing"; exit 1 }

$html = Get-Content -Raw -Encoding UTF8 -Path $scannerHtmlPath
$js = Get-Content -Raw -Encoding UTF8 -Path $jsPath
$model = Get-Content -Raw -Encoding UTF8 -Path $modelPath | ConvertFrom-Json
$tfo = Get-Content -Raw -Encoding UTF8 -Path $tfoPath | ConvertFrom-Json

$approvedTfoIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach ($fm in $tfo.failure_modes) { [void]$approvedTfoIds.Add($fm.id) }
foreach ($cx in $tfo.diagnostic_constraints) { [void]$approvedTfoIds.Add($cx.id) }

# --- Page structure and disclosures -------------------------------------------------
$requiredHeadings = @(
  'What the Scanner Measures',
  'What the Scanner Does Not Claim',
  'Evidence Confidence Notice',
  'Transition Axis',
  'Result Preview',
  'Methodology Links',
  'Report Upgrade Path'
)
$missingHeadings = $requiredHeadings | Where-Object { $html -notmatch "<h2>$_</h2>" }
if (-not $missingHeadings) { Pass "Scanner page has required blueprint headings" }
else { foreach ($h in $missingHeadings) { Fail "Scanner page missing heading: $h" } }

if ($html -match 'Scanner v1 is rules-governed' -and
    $html -match 'does not require live analytics integrations' -and
    $html -match 'does not[\s\r\n]+claim exact causality') {
  Pass "Scanner page carries mandatory disclosure (rules-governed / no exact causality)"
} else { Fail "Scanner page missing mandatory rules-governed disclosure" }

if ($html -match 'Evidence Confidence qualifies how strongly a result should be interpreted') {
  Pass "Scanner page carries Evidence Confidence qualification disclosure"
} else { Fail "Scanner page missing Evidence Confidence disclosure" }

if ($html -match 'Partial Profile') {
  Pass "Scanner page documents Partial Profile rule"
} else { Fail "Scanner page missing Partial Profile rule" }

if ($html -match 'Unscorable') {
  Pass "Scanner page documents Unscorable / E0 handling"
} else { Fail "Scanner page missing Unscorable documentation" }

# --- Script and dependency constraints ----------------------------------------------
if ($html -match '<script\s+src="/assets/js/scanner\.js"\s*></script>' -and
    $html -notmatch '<script[^>]+src\s*=\s*"https?://') {
  Pass "Scanner page uses only local scanner.js (no external JS)"
} else { Fail "Scanner page script tag is not the governed local scanner.js only" }

if ($html -notmatch 'google-analytics|googletagmanager|gtag\(|analytics\.js|plausible|segment\.com|mixpanel|hotjar|clarity\.ms') {
  Pass "Scanner page contains no analytics snippets"
} else { Fail "Scanner page contains analytics references" }

if ($html -notmatch '<canvas|webgl|three\.js') {
  Pass "Scanner page contains no WebGL/3D/canvas markup"
} else { Fail "Scanner page contains prohibited rendering markup" }

if ($js -notmatch 'https?://') {
  Pass "scanner.js contains no external URLs"
} else { Fail "scanner.js references external URLs" }

if ($js -notmatch 'getContext\(|webgl|three\.js|<canvas') {
  Pass "scanner.js contains no WebGL/3D/canvas API usage"
} else { Fail "scanner.js uses prohibited rendering APIs" }

# --- Data registry usage ------------------------------------------------------------
$dataRefs = @(
  '/data/scanner-model.json',
  '/data/ati-standard.json',
  '/data/tfo-failure-modes.json',
  '/data/intervention-layers.json'
)
$missingData = $dataRefs | Where-Object { $js -notmatch [regex]::Escape($_) }
if (-not $missingData) { Pass "scanner.js loads all four governed data files" }
else { foreach ($d in $missingData) { Fail "scanner.js missing fetch for $d" } }

if ($js -notmatch 'evidence_confidence_weight') {
  Pass "scanner.js does not reference evidence_confidence_weight"
} else { Fail "scanner.js references prohibited evidence_confidence_weight" }

if ($js -match 'partial' -and $js -match 'Unscorable' -and $js -match 'E0') {
  Pass "scanner.js implements Partial Profile and Unscorable handling"
} else { Fail "scanner.js missing Partial Profile / Unscorable logic" }

if ($js -match 'composite' -and $js -match 'partial') {
  Pass "scanner.js distinguishes composite score from partial profile"
} else { Fail "scanner.js missing composite vs partial branching" }

# --- TFO ID confinement in JS -------------------------------------------------------
$jsTfoIds = [regex]::Matches($js, 'tfo\.(?:t[1-4]|constraint)\.[a-z_]+') |
  ForEach-Object { $_.Value } | Sort-Object -Unique
$rogueJsIds = $jsTfoIds | Where-Object { -not $approvedTfoIds.Contains($_) }
if (-not $rogueJsIds) {
  Pass "scanner.js TFO literal IDs confined to registry ($($jsTfoIds.Count) referenced)"
} else {
  foreach ($id in $rogueJsIds) { Fail "scanner.js references unknown TFO ID: $id" }
}

# --- Canonical route links in JS output (resolved from scanner-model.json at runtime) -
if ($js -match 'canonical_routes' -and
    $js -match 'routes\.ati_standard' -and
    $js -match 'routes\.evidence_confidence' -and
    $js -match 'routes\.intervention_layers' -and
    $js -match 'routes\.tfo_overview' -and
    $js -match 'routes\.measurement_gap' -and
    $js -match 'meta\.canonical_route|vr\.route') {
  Pass "scanner.js result output resolves governed canonical routes from data"
} else { Fail "scanner.js missing canonical route resolution from scanner-model.json" }

# --- Badge separation and prohibited language ---------------------------------------
if ($js -match 'badge-evidence' -and $js -match 'badge-diagnostic' -and $js -match 'score-panel') {
  Pass "scanner.js renders separate score and evidence components"
} else { Fail "scanner.js missing separate score/evidence component rendering" }

$prohibited = @(
  'AI knows exactly',
  'increase revenue by',
  'revenue will grow',
  'guaranteed revenue',
  'industry standard'
)
$claimOk = $true
foreach ($phrase in $prohibited) {
  if ($html -match [regex]::Escape($phrase) -and $html -notmatch '\bnot\b|\bdoes not\b|\bnever\b|\bprohibit') {
    Fail "Scanner page contains prohibited phrase: $phrase"; $claimOk = $false
  }
  if ($js -match [regex]::Escape($phrase) -and $js -notmatch '\bnot\b|\bdoes not\b|\bnever\b|\bprohibit') {
    Fail "scanner.js contains prohibited phrase: $phrase"; $claimOk = $false
  }
}
if ($claimOk) { Pass "Scanner page and JS pass prohibited-claim phrase scan" }

# --- No dynamic indexable result routes ---------------------------------------------
if ($html -notmatch 'history\.pushState|location\.hash\s*=|/results/' -and
    $js -notmatch 'history\.pushState|/results/|ati-snapshot\?') {
  Pass "Scanner does not create dynamic indexable result routes"
} else { Fail "Scanner may create dynamic indexable result routes" }

if ($html -match 'Results are displayed on this page only') {
  Pass "Scanner page states results stay on-page (not indexable routes)"
} else { Fail "Scanner page missing on-page result disclosure" }

# --- Model alignment ----------------------------------------------------------------
if ($js -match 'partial_profile_rule' -or ($js -match 'Partial Profile' -and $js -match 'partial')) {
  Pass "scanner.js implements Partial Profile rule from governed data"
} else { Fail "scanner.js missing Partial Profile rule from data" }

# --- Transition health on scanner axis (Patch 12B) --------------------------------
if ($html -match 'transition-axis__vector--reference' -and
    $html -notmatch 'transition-axis__vector--strong' -and
    $html -notmatch 'transition-axis__vector--critical') {
  Pass "Scanner static axis uses reference modifiers only (no false diagnostic claim)"
} else { Fail "Scanner static axis must use --reference only, not diagnostic health modifiers" }

if ($js -match 'transition-axis__vector--reference' -and
    $js -match 'classList\.remove\("transition-axis__vector--reference"\)' -and
    $js -match 'transition-axis__vector--unscorable' -and
    $js -match 'transition-axis__vector--"\s*\+\s*classModifier') {
  Pass "scanner.js swaps reference for diagnostic health modifiers after scoring"
} else { Fail "scanner.js missing governed reference-to-diagnostic axis update" }

# --- Scanner result map (Patch 12D) -----------------------------------------------
$cssPath = Join-Path $root 'assets/css/main.css'
$css = Get-Content -Raw -Encoding UTF8 -Path $cssPath

if ($js -match 'renderTransitionHealthMap' -and $js -match 'scanner-result-map') {
  Pass "scanner.js renders Transition Health Map component"
} else { Fail "scanner.js missing Transition Health Map rendering" }

if ($js -match 'function healthModifierForVector' -and
    $js -match 'return "unscorable"' -and
    $js -match 'scanner-result-map__vector--" \+ mod') {
  Pass "scanner.js assigns health modifiers to each vector in the result map"
} else { Fail "scanner.js missing per-vector health modifier assignment in result map" }

if ($js -match 'ATI Profile: Partial' -and $js -match 'renderTransitionHealthMap\(result\)') {
  Pass "Partial Profile renders Transition Health Map"
} else { Fail "Partial Profile must render Transition Health Map" }

if ($js -match 'result\.partial' -and $js -match 'else if \(result\.composite\)') {
  Pass "Partial Profile branch prevents Composite ATI when any vector is E0"
} else { Fail "Partial Profile must gate Composite ATI behind full-profile branch" }

if ($js -match 'Composite ATI:' -and $js -match 'result\.composite') {
  Pass "Full Profile allows Composite ATI output"
} else { Fail "Full Profile composite rendering missing" }

if ($js -match 'Weakest Movement' -and $js -match 'Strongest Movement' -and $js -match 'scanner-result-map__focus') {
  Pass "scanner result highlights weakest and strongest movement"
} else { Fail "scanner result missing weakest/strongest movement sections" }

if ($js -match 'Primary Failure Mode' -and $js -match 'primaryFailureMode' -and $js -match 'canonical_route') {
  Pass "scanner result surfaces primary failure mode with canonical route"
} else { Fail "scanner result missing primary failure mode block" }

if ($js -match 'Recommended Intervention Layers' -and $js -match 'intervention-tag') {
  Pass "scanner result renders recommended intervention layers"
} else { Fail "scanner result missing intervention layer output" }

if ($js -match 'Evidence Confidence Summary' -and $js -match 'Reference Links') {
  Pass "scanner result keeps Evidence Confidence summary separate from the health map"
} else { Fail "scanner result missing Evidence Confidence summary" }

if ($js -notmatch 'class="failure-lens"') {
  Pass "scanner result does not embed Failure Lens component"
} else { Fail "scanner result must not embed Failure Lens in Sprint 12D" }

$mapClasses = @(
  '.scanner-result-map',
  '.scanner-result-map__axis',
  '.scanner-result-map__state',
  '.scanner-result-map__vector',
  '.scanner-result-map__vector--strong',
  '.scanner-result-map__vector--functional',
  '.scanner-result-map__vector--unstable',
  '.scanner-result-map__vector--constrained',
  '.scanner-result-map__vector--critical',
  '.scanner-result-map__vector--unscorable',
  '.scanner-result-map__label',
  '.scanner-result-map__summary',
  '.scanner-result-map__focus'
)
$missingMapClasses = $mapClasses | Where-Object { $css -notmatch [regex]::Escape($_) }
if (-not $missingMapClasses) {
  Pass "Scanner result map CSS classes defined in main.css"
} else {
  foreach ($m in $missingMapClasses) { Fail "Scanner result map class missing in main.css: $m" }
}

if ($css -match 'SCANNER RESULT MAP' -and $css -notmatch '\.scanner-result-map[\s\S]{0,2500}--evidence-') {
  Pass "Scanner result map styling does not use Evidence Confidence variables"
} else { Fail "Scanner result map must not reference evidence color tokens" }

# --- Summary ------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 } else { exit 0 }
