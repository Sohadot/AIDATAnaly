# validate-pages.ps1
# Sprint 3+ acceptance checks for public reference pages.
# Governed by: PAGE_BLUEPRINTS.md v1.0 (§27 Quality Gate), ROUTE_MAP.md v1.0 (§15, §18),
# IMPLEMENTATION_PLAN.md (IMPL-PLAN-001).
# Validates every implemented public route page (index.html under a governed route).

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()
$passes = @()

function Pass([string]$msg) { $script:passes += $msg; Write-Host "  PASS  $msg" }
function Fail([string]$msg) { $script:failures += $msg; Write-Host "  FAIL  $msg" }

Write-Host "=== AIDAtanaly Public Page Validation ==="

# --- Launch route set from ROUTE_MAP.md --------------------------------------
$routeMapLines = Get-Content -Encoding UTF8 -Path (Join-Path $root 'ROUTE_MAP.md')
$launchRoutes = $routeMapLines | ForEach-Object { $_.Trim() } |
  Where-Object { $_ -match '^/[a-z0-9\-/\.]*$' } | Sort-Object -Unique

# --- Discover implemented public pages ----------------------------------------
# A public page is an index.html whose parent folder maps to a launch route.
$pages = @{}
foreach ($route in $launchRoutes) {
  if ($route -match '\.json$') { continue }
  $rel = if ($route -eq '/') { 'index.html' } else { ($route.Trim('/') -replace '/', '\') + '\index.html' }
  $full = Join-Path $root $rel
  if (Test-Path $full) {
    $pages[$route] = Get-Content -Raw -Encoding UTF8 -Path $full
  }
}
Write-Host "  INFO  Implemented public routes found: $($pages.Count)"
if ($pages.Count -eq 0) { Fail "No implemented public pages found"; exit 1 }

# --- Per-page universal checks --------------------------------------------------
$titles = @{}
$descriptions = @{}
foreach ($route in ($pages.Keys | Sort-Object)) {
  $html = $pages[$route]
  $label = "[$route]"
  $pageOk = $true

  # one H1 only
  $h1Count = ([regex]::Matches($html, '<h1[\s>]')).Count
  if ($h1Count -ne 1) { Fail "$label has $h1Count <h1> elements (must be 1)"; $pageOk = $false }

  # unique non-empty title
  $title = [regex]::Match($html, '<title>([^<]+)</title>').Groups[1].Value.Trim()
  if (-not $title) { Fail "$label missing <title>"; $pageOk = $false }
  elseif ($titles.ContainsKey($title)) { Fail "$label duplicate title with $($titles[$title])"; $pageOk = $false }
  else { $titles[$title] = $route }

  # unique non-empty meta description
  $desc = [regex]::Match($html, '<meta\s+name="description"\s+content="([^"]+)"').Groups[1].Value.Trim()
  if (-not $desc) { Fail "$label missing meta description"; $pageOk = $false }
  elseif ($descriptions.ContainsKey($desc)) { Fail "$label duplicate description with $($descriptions[$desc])"; $pageOk = $false }
  else { $descriptions[$desc] = $route }

  # canonical URL matches route
  $expectedCanonical = "https://aidatanaly.com$route"
  if ($html -notmatch [regex]::Escape("<link rel=`"canonical`" href=`"$expectedCanonical`"")) {
    Fail "$label canonical missing or not $expectedCanonical"; $pageOk = $false
  }

  # pre-launch noindex
  if ($html -notmatch '<meta\s+name="robots"\s+content="noindex"') {
    Fail "$label missing pre-launch noindex meta"; $pageOk = $false
  }

  # governed stylesheet
  if ($html -notmatch 'href="/assets/css/main\.css"') {
    Fail "$label does not link /assets/css/main.css"; $pageOk = $false
  }

  # readable without JavaScript
  if ($html -match '<script') { Fail "$label contains <script>; reference pages must not require JS"; $pageOk = $false }

  # internal links resolve to governed launch routes
  $hrefs = [regex]::Matches($html, 'href="(/[^"]*)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
  foreach ($h in $hrefs) {
    if ($h -match '^/assets/') { continue }
    if ($launchRoutes -notcontains $h) { Fail "$label links outside the launch route set: $h"; $pageOk = $false }
  }

  # prohibited claim language (line-level: positive claims only)
  $lineNo = 0
  foreach ($line in ($html -split "`n")) {
    $lineNo++
    if ($line -match 'industry[ -]standard' -and $line -notmatch '\bnot\b|\bdoes not\b|\bnever\b') {
      Fail "$label line ${lineNo}: unqualified 'industry standard' claim"; $pageOk = $false
    }
    if ($line -match 'guarantee' -and $line -notmatch '\bno\b|\bnot\b|\bnever\b|\bwithout\b|\bprohibit') {
      Fail "$label line ${lineNo}: unqualified 'guarantee' language"; $pageOk = $false
    }
    if ($line -match 'increase revenue by|revenue will (grow|increase)|AI knows exactly') {
      Fail "$label line ${lineNo}: prohibited claim phrase"; $pageOk = $false
    }
  }

  if ($pageOk) { Pass "$label universal checks (h1, title, description, canonical, noindex, css, no-js, links, claims)" }
}

# --- Required internal links per blueprint ----------------------------------------
$requiredLinks = @{
  '/' = @('/aida-transition-analytics/', '/aida-transition-index/', '/transition-failure-ontology/',
          '/scanner/', '/methodology/', '/governance/', '/vectors/attention-to-interest/',
          '/vectors/interest-to-desire/', '/vectors/desire-to-action/', '/vectors/action-to-loyalty/')
  '/aida-transition-analytics/' = @('/', '/aida-transition-index/', '/transition-failure-ontology/',
          '/scanner/', '/methodology/', '/transition-intelligence/', '/measurement-grammar/')
  '/transition-intelligence/' = @('/', '/aida-transition-index/', '/transition-failure-ontology/',
          '/scanner/', '/methodology/', '/aida-transition-analytics/', '/measurement-grammar/')
  '/measurement-grammar/' = @('/', '/aida-transition-index/', '/transition-failure-ontology/',
          '/scanner/', '/methodology/', '/aida-transition-analytics/', '/transition-intelligence/')
  '/aida-transition-index/' = @('/vectors/attention-to-interest/', '/vectors/interest-to-desire/',
          '/vectors/desire-to-action/', '/vectors/action-to-loyalty/', '/transition-failure-ontology/',
          '/evidence-confidence/', '/intervention-layers/', '/scanner/', '/methodology/', '/governance/')
  '/evidence-confidence/' = @('/aida-transition-index/', '/scanner/', '/methodology/',
          '/failure-modes/measurement-gap/', '/governance/')
  '/intervention-layers/' = @('/aida-transition-index/', '/transition-failure-ontology/',
          '/scanner/', '/methodology/', '/governance/')
}
foreach ($route in ($requiredLinks.Keys | Sort-Object)) {
  if (-not $pages.ContainsKey($route)) { continue }
  $html = $pages[$route]
  $missing = $requiredLinks[$route] | Where-Object { $html -notmatch [regex]::Escape("href=`"$_`"") }
  if (-not $missing) { Pass "[$route] all $($requiredLinks[$route].Count) blueprint-required internal links present" }
  else { foreach ($m in $missing) { Fail "[$route] missing required link: $m" } }
}

# --- Page-specific governed statements ----------------------------------------------
if ($pages.ContainsKey('/evidence-confidence/')) {
  $ec = $pages['/evidence-confidence/']
  if ($ec -match 'Evidence Confidence is\s*(<[^>]+>\s*)*not part of the ATI score') {
    Pass "[/evidence-confidence/] states 'Evidence Confidence is not part of the ATI score'"
  } else { Fail "[/evidence-confidence/] missing the mandatory separation statement" }
  $levelChecks = @('Absent Evidence', 'Self-Reported Evidence', 'Observable Evidence', 'Multi-Source Evidence', 'Validated Evidence', 'Unscorable', 'provisional', 'indicative', 'Partial Profile')
  $missingLevels = $levelChecks | Where-Object { $ec -notmatch [regex]::Escape($_) }
  if (-not $missingLevels) { Pass "[/evidence-confidence/] explains E0-E4, Unscorable, provisional/indicative language, and Partial Profile" }
  else { foreach ($m in $missingLevels) { Fail "[/evidence-confidence/] missing required concept: $m" } }
}

if ($pages.ContainsKey('/intervention-layers/')) {
  $il = $pages['/intervention-layers/']
  $layers = @('Audience Intervention','Message Intervention','Offer Intervention','Proof Intervention',
    'UX Intervention','Pricing Intervention','Timing Intervention','Attribution Intervention',
    'Lifecycle Intervention','Sales-Assist Intervention')
  $missingLayers = $layers | Where-Object { $il -notmatch [regex]::Escape($_) }
  if (-not $missingLayers) { Pass "[/intervention-layers/] defines all ten approved layers" }
  else { foreach ($m in $missingLayers) { Fail "[/intervention-layers/] missing layer: $m" } }
  if ($il -match 'Channel Intervention' -and $il -match 'Measurement Governance' -and $il -match 'not(</strong>)?\s+standalone') {
    Pass "[/intervention-layers/] clarifies Channel and Measurement Governance are not standalone layers"
  } else { Fail "[/intervention-layers/] missing contextual subcase clarification" }
}

if ($pages.ContainsKey('/')) {
  if ($pages['/'] -match 'AIDAtanaly measures the movement between Attention, Interest, Desire, Action, and Loyalty') {
    Pass "[/] carries the primary message verbatim"
  } else { Fail "[/] missing the primary message" }
}

# --- Summary --------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 } else { exit 0 }
