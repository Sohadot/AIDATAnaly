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
    if ($line -match 'guarantee' -and $line -notmatch '\bno\b|\bnot\b|\bnever\b|\bwithout\b|\bprohibit|guarantee sections|guarantees, or|or guarantee sections|terms or guarantees') {
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

# --- Sprint 4: Vector page checks (PAGE_BLUEPRINTS.md §12) -------------------------
$vectorPages = @{
  '/vectors/attention-to-interest/' = @(
    '/failure-modes/attention-noise/', '/failure-modes/vanity-reach/',
    '/failure-modes/audience-mismatch/', '/failure-modes/signal-decay/', '/failure-modes/message-blur/'
  )
  '/vectors/interest-to-desire/' = @(
    '/failure-modes/passive-engagement/', '/failure-modes/comparison-stall/',
    '/failure-modes/preference-dilution/', '/failure-modes/intent-evaporation/', '/failure-modes/value-ambiguity/'
  )
  '/vectors/desire-to-action/' = @(
    '/failure-modes/process-friction/', '/failure-modes/trust-deficit/', '/failure-modes/price-shock/',
    '/failure-modes/decision-delay/', '/failure-modes/complexity-wall/', '/failure-modes/objection-residue/'
  )
  '/vectors/action-to-loyalty/' = @(
    '/failure-modes/one-transaction-funnel/', '/failure-modes/silent-churn/',
    '/failure-modes/loyalty-blindness/', '/failure-modes/advocacy-vacuum/', '/failure-modes/lifecycle-disconnect/'
  )
}
$vectorHubLinks = @('/aida-transition-index/', '/transition-failure-ontology/', '/scanner/',
  '/evidence-confidence/', '/intervention-layers/')

foreach ($route in ($vectorPages.Keys | Sort-Object)) {
  if (-not $pages.ContainsKey($route)) { Fail "Sprint 4 vector page missing: $route" }
  else { Pass "Sprint 4 vector page exists: $route" }
}

foreach ($route in ($vectorPages.Keys | Sort-Object)) {
  if (-not $pages.ContainsKey($route)) { continue }
  $html = $pages[$route]
  $missingHub = $vectorHubLinks | Where-Object { $html -notmatch [regex]::Escape("href=`"$_`"") }
  if (-not $missingHub) { Pass "[$route] links to ATI, TFO, Scanner, Evidence, Intervention" }
  else { foreach ($m in $missingHub) { Fail "[$route] missing hub link: $m" } }

  $allowed = $vectorPages[$route]
  $linked = [regex]::Matches($html, 'href="(/failure-modes/[^"]+)"') |
    ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
  $extra = $linked | Where-Object { $allowed -notcontains $_ }
  if (-not $extra) { Pass "[$route] links only to its own failure modes ($($linked.Count) routes)" }
  else { foreach ($e in $extra) { Fail "[$route] links to failure mode outside its vector: $e" } }

  $missingFm = $allowed | Where-Object { $html -notmatch [regex]::Escape("href=`"$_`"") }
  if (-not $missingFm) { Pass "[$route] links to all $($allowed.Count) governed failure modes" }
  else { foreach ($m in $missingFm) { Fail "[$route] missing failure mode link: $m" } }
}

$t2Sentence = 'Preference and intent are sub-signals inside T2, not separate transition vectors.'
if ($pages.ContainsKey('/vectors/interest-to-desire/') -and
    $pages['/vectors/interest-to-desire/'] -match [regex]::Escape($t2Sentence)) {
  Pass "[/vectors/interest-to-desire/] carries the T2 sub-signals governing sentence"
} else { Fail "[/vectors/interest-to-desire/] missing T2 sub-signals governing sentence" }

$t4Sentence = 'AIDAtanaly extends AIDA beyond Action because action without continuity is incomplete movement intelligence.'
if ($pages.ContainsKey('/vectors/action-to-loyalty/') -and
    $pages['/vectors/action-to-loyalty/'] -match [regex]::Escape($t4Sentence)) {
  Pass "[/vectors/action-to-loyalty/] carries the T4 continuity governing sentence"
} else { Fail "[/vectors/action-to-loyalty/] missing T4 continuity governing sentence" }

# --- Sprint 5: TFO overview + failure mode pages (PAGE_BLUEPRINTS.md §13–§14) -----
$tfoJson = Get-Content -Raw -Encoding UTF8 -Path (Join-Path $root 'data/tfo-failure-modes.json') | ConvertFrom-Json

$vectorRouteById = @{
  'ati.vector.t1' = '/vectors/attention-to-interest/'
  'ati.vector.t2' = '/vectors/interest-to-desire/'
  'ati.vector.t3' = '/vectors/desire-to-action/'
  'ati.vector.t4' = '/vectors/action-to-loyalty/'
}

$registryByRoute = @{}
$approvedTfoIds = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
foreach ($fm in $tfoJson.failure_modes) {
  $registryByRoute[$fm.canonical_route] = $fm
  [void]$approvedTfoIds.Add($fm.id)
}
foreach ($cx in $tfoJson.diagnostic_constraints) {
  $registryByRoute[$cx.canonical_route] = $cx
  [void]$approvedTfoIds.Add($cx.id)
}

$tfoOverviewRoute = '/transition-failure-ontology/'
$allTfoRoutes = @($tfoJson.failure_modes | ForEach-Object { $_.canonical_route }) +
  @($tfoJson.diagnostic_constraints | ForEach-Object { $_.canonical_route })

$fmHubLinks = @('/aida-transition-index/', '/transition-failure-ontology/', '/scanner/',
  '/evidence-confidence/', '/intervention-layers/')

$requiredDossierSections = @(
  'Definition', 'Core Diagnostic Question', 'Why It Matters', 'Symptoms',
  'Detection Signals', 'Scoring Impact', 'Evidence Confidence Considerations',
  'AI Instrumentation', 'Intervention Layers', 'Related Failure Modes',
  'Scanner Output Language', 'Internal Links', 'Version Notes'
)

if ($pages.ContainsKey($tfoOverviewRoute)) {
  Pass "Sprint 5: $tfoOverviewRoute exists"
} else {
  Fail "Sprint 5: missing $tfoOverviewRoute"
}

foreach ($r in ($allTfoRoutes | Sort-Object)) {
  if ($pages.ContainsKey($r)) { Pass "Sprint 5: $r exists" }
  else { Fail "Sprint 5: missing failure/constraint page $r" }
}

$implementedFmRoutes = @($pages.Keys | Where-Object { $_ -match '^/failure-modes/' } | Sort-Object)
$extraFmRoutes = $implementedFmRoutes | Where-Object { $allTfoRoutes -notcontains $_ }
if (-not $extraFmRoutes) {
  Pass "Sprint 5: no failure mode routes outside TFO registry ($($implementedFmRoutes.Count) routes)"
} else {
  foreach ($e in $extraFmRoutes) { Fail "Sprint 5: unregistered failure mode route: $e" }
}

foreach ($r in ($allTfoRoutes | Sort-Object)) {
  if (-not $pages.ContainsKey($r)) { continue }
  $html = $pages[$r]
  $entry = $registryByRoute[$r]
  $label = "[$r]"
  $isConstraint = $entry.PSObject.Properties.Name -contains 'primary_classification'

  if ($html -match [regex]::Escape($entry.id)) {
    Pass "$label stable ID matches JSON ($($entry.id))"
  } else {
    Fail "$label stable ID missing or mismatched (expected $($entry.id))"
  }

  $expectedCanonical = "https://aidatanaly.com$($entry.canonical_route)"
  if ($html -match [regex]::Escape("href=`"$expectedCanonical`"")) {
    Pass "$label canonical URL matches JSON route"
  } else {
    Fail "$label canonical URL missing or mismatched (expected $expectedCanonical)"
  }

  if ($html -match [regex]::Escape($entry.canonical_route)) {
    Pass "$label canonical route path present in body"
  } else {
    Fail "$label canonical route path missing in body ($($entry.canonical_route))"
  }

  $missingSections = $requiredDossierSections | Where-Object { $html -notmatch "<h2>$_</h2>" }
  if (-not $missingSections) {
    Pass "$label all section 14.3 dossier headings present"
  } else {
    foreach ($s in $missingSections) { Fail "$label missing section heading: $s" }
  }

  if (-not $isConstraint) {
    $expectedParent = $vectorRouteById[$entry.primary_vector]
    if ($expectedParent -and $html -match [regex]::Escape("href=`"$expectedParent`"")) {
      Pass "$label links to parent vector $expectedParent"
    } else {
      Fail "$label missing parent vector link (expected $expectedParent)"
    }
    if ($html -match 'Primary Classification') {
      Fail "$label uses constraint metadata on a normal failure mode page"
    }
  } else {
    if ($html -match 'Primary Classification' -and $html -match 'Diagnostic Constraint') {
      Pass "$label classified as diagnostic constraint"
    } else {
      Fail "$label missing constraint classification metadata"
    }
    if ($html -match 'dossier-block--constraint') {
      Pass "$label uses constraint dossier styling"
    } else {
      Fail "$label missing dossier-block--constraint class"
    }
    $missingVectors = $vectorRouteById.Values | Where-Object { $html -notmatch [regex]::Escape("href=`"$_`"") }
    if (-not $missingVectors) {
      Pass "$label links to all four vector pages"
    } else {
      foreach ($v in $missingVectors) { Fail "$label missing vector link: $v" }
    }
  }

  $missingHub = $fmHubLinks | Where-Object { $html -notmatch [regex]::Escape("href=`"$_`"") }
  if (-not $missingHub) {
    Pass "$label links to ATI, TFO, Scanner, Evidence, Intervention"
  } else {
    foreach ($m in $missingHub) { Fail "$label missing hub link: $m" }
  }

  $foundIds = [regex]::Matches($html, 'tfo\.(?:t[1-4]|constraint)\.[a-z_]+') |
    ForEach-Object { $_.Value } | Sort-Object -Unique
  $rogueIds = $foundIds | Where-Object { -not $approvedTfoIds.Contains($_) }
  if (-not $rogueIds) {
    Pass "$label TFO IDs confined to registry ($($foundIds.Count) referenced)"
  } else {
    foreach ($id in $rogueIds) { Fail "$label unknown TFO ID outside registry: $id" }
  }
}

$mgRoute = '/failure-modes/measurement-gap/'
if ($pages.ContainsKey($mgRoute)) {
  $mg = $pages[$mgRoute]
  if ($mg -match 'Measurement Gap limits diagnostic confidence\. It does not automatically prove that the transition is broken') {
    Pass "[/failure-modes/measurement-gap/] mandatory confidence limitation statement"
  } else {
    Fail "[/failure-modes/measurement-gap/] missing mandatory confidence limitation statement"
  }
  if ($mg -match 'Partial Profile rather than a clean composite ATI score') {
    Pass "[/failure-modes/measurement-gap/] E0 / Partial Profile scanner rule present"
  } else {
    Fail "[/failure-modes/measurement-gap/] missing E0 / Partial Profile scanner rule"
  }
}

if ($pages.ContainsKey($tfoOverviewRoute)) {
  $ov = $pages[$tfoOverviewRoute]
  if ($ov -match 'How strong is the movement\?') {
    Pass "[/transition-failure-ontology/] states ATI diagnostic question"
  } else {
    Fail "[/transition-failure-ontology/] missing ATI question (How strong is the movement?)"
  }
  if ($ov -match 'What class of movement failure is present\?') {
    Pass "[/transition-failure-ontology/] states TFO diagnostic question"
  } else {
    Fail "[/transition-failure-ontology/] missing TFO question (What class of movement failure is present?)"
  }
  $missingOvFmLinks = $allTfoRoutes | Where-Object { $ov -notmatch [regex]::Escape("href=`"$_`"") }
  if (-not $missingOvFmLinks) {
    Pass "[/transition-failure-ontology/] links to all 22 failure/constraint dossier pages"
  } else {
    foreach ($m in $missingOvFmLinks) { Fail "[/transition-failure-ontology/] missing dossier link: $m" }
  }
  $overviewVectorLinks = @('/vectors/attention-to-interest/', '/vectors/interest-to-desire/',
    '/vectors/desire-to-action/', '/vectors/action-to-loyalty/')
  $missingOvVectors = $overviewVectorLinks | Where-Object { $ov -notmatch [regex]::Escape("href=`"$_`"") }
  if (-not $missingOvVectors) {
    Pass "[/transition-failure-ontology/] links to all four vector pages"
  } else {
    foreach ($v in $missingOvVectors) { Fail "[/transition-failure-ontology/] missing vector link: $v" }
  }
}

if ($pages.Count -ge 34) {
  Pass "Sprint 5: $($pages.Count)/41 launch routes implemented"
} else {
  Fail "Sprint 5: expected at least 34 implemented routes, found $($pages.Count)"
}

# --- Summary --------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 } else { exit 0 }
