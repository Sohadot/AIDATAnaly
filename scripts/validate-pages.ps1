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

  # readable without JavaScript (scanner page may use local enhancement script only)
  if ($html -match '<script') {
    if ($route -eq '/scanner/') {
      if ($html -match '<script\s+src="/assets/js/scanner\.js"\s*></script>' -and
          ($html -replace '<script\s+src="/assets/js/scanner\.js"\s*></script>', '') -notmatch '<script') {
        # governed local scanner script only
      } else {
        Fail "$label must use only /assets/js/scanner.js (no inline or external scripts)"; $pageOk = $false
      }
    } else {
      Fail "$label contains <script>; reference pages must not require JS"; $pageOk = $false
    }
  }

  # internal links resolve to governed launch routes
  $hrefs = [regex]::Matches($html, 'href="(/[^"]*)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
  foreach ($h in $hrefs) {
    if ($h -match '^/assets/') { continue }
    if ($h -match '^/preview/|/governance/decisions/|/claims-policy/|/versioning/') {
      Fail "$label links to prohibited non-public path: $h"; $pageOk = $false
    }
    if ($launchRoutes -notcontains $h) { Fail "$label links outside the launch route set: $h"; $pageOk = $false }
  }

  # prohibited claim language (line-level: positive claims only)
  $lineNo = 0
  foreach ($line in ($html -split "`n")) {
    $lineNo++
    if ($line -match 'industry[ -]standard' -and $line -notmatch '\bno\b|\bnot\b|\bdoes not\b|\bnever\b|\bwithout\b|\badopted industry|\bas adopted industry|not industry standard|not describe them as adopted|must not describe|No industry|No adopted|false industry|Claims of standard|Claims presented as|requiring adoption') {
      Fail "$label line ${lineNo}: unqualified 'industry standard' claim"; $pageOk = $false
    }
    if ($line -match 'guarantee' -and $line -notmatch '\bno\b|\bnot\b|\bnever\b|\bwithout\b|\bprohibit|guarantee sections|guarantees, or|or guarantee sections|terms or guarantees|risk, proof, guarantee|does not promise|avoid.*guarantee|not commercial|not guarantee|not guarantees|No guaranteed|revenue guarantee|guarantee of commercial|guarantees of commercial|diagnostic references, not') {
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

if ($pages.Count -ge 35) {
  Pass "Sprint 6: $($pages.Count)/41 launch routes implemented"
} elseif ($pages.Count -ge 34) {
  Pass "Sprint 5 baseline: $($pages.Count)/41 launch routes implemented"
} else {
  Fail "Expected at least 34 implemented routes, found $($pages.Count)"
}

# --- Sprint 6: Scanner page (PAGE_BLUEPRINTS.md §16) --------------------------------
$scannerRoute = '/scanner/'
if ($pages.ContainsKey($scannerRoute)) {
  Pass "Sprint 6: $scannerRoute exists"
  $sc = $pages[$scannerRoute]

  $scannerHeadings = @(
    'What the Scanner Measures', 'What the Scanner Does Not Claim',
    'Evidence Confidence Notice', 'Transition Axis', 'Result Preview',
    'Methodology Links', 'Report Upgrade Path'
  )
  $missingScHeadings = $scannerHeadings | Where-Object { $sc -notmatch "<h2>$_</h2>" }
  if (-not $missingScHeadings) { Pass "[/scanner/] all blueprint section headings present" }
  else { foreach ($h in $missingScHeadings) { Fail "[/scanner/] missing heading: $h" } }

  if ($sc -match 'Scanner v1 is rules-governed' -and
      $sc -match 'does not require live analytics integrations' -and
      $sc -match 'does not[\s\r\n]+claim exact causality') {
    Pass "[/scanner/] mandatory scanner disclosure present"
  } else { Fail "[/scanner/] missing mandatory scanner disclosure" }

  if ($sc -match 'Evidence Confidence qualifies how strongly a result should be interpreted') {
    Pass "[/scanner/] Evidence Confidence notice present"
  } else { Fail "[/scanner/] missing Evidence Confidence notice" }

  if ($sc -match 'Partial Profile' -and $sc -match 'Unscorable') {
    Pass "[/scanner/] documents Partial Profile and Unscorable rules"
  } else { Fail "[/scanner/] missing Partial Profile or Unscorable documentation" }

  if ($sc -match '<script\s+src="/assets/js/scanner\.js"') {
    Pass "[/scanner/] links governed local scanner.js"
  } else { Fail "[/scanner/] missing local scanner.js script tag" }

  if ($sc -notmatch 'google-analytics|googletagmanager|gtag\(') {
    Pass "[/scanner/] no analytics snippets"
  } else { Fail "[/scanner/] contains analytics references" }

  $scannerRefs = @('/aida-transition-index/', '/evidence-confidence/', '/intervention-layers/',
    '/transition-failure-ontology/', '/failure-modes/measurement-gap/', '/vectors/attention-to-interest/')
  $missingScRefs = $scannerRefs | Where-Object { $sc -notmatch [regex]::Escape("href=`"$_`"") }
  if (-not $missingScRefs) { Pass "[/scanner/] links to governed ATI, TFO, Evidence, Intervention, vectors" }
  else { foreach ($m in $missingScRefs) { Fail "[/scanner/] missing reference link: $m" } }

  if ($sc -match 'Results are displayed on this page only') {
    Pass "[/scanner/] states results are not separate indexable routes"
  } else { Fail "[/scanner/] missing on-page result route disclosure" }
} else {
  Fail "Sprint 6: missing $scannerRoute"
}

$jsPath = Join-Path $root 'assets/js/scanner.js'
if (Test-Path $jsPath) {
  $js = Get-Content -Raw -Encoding UTF8 -Path $jsPath
  if ($js -match '/data/scanner-model\.json') { Pass "Sprint 6: scanner.js reads /data/scanner-model.json" }
  else { Fail "Sprint 6: scanner.js does not fetch scanner-model.json" }
  if ($js -notmatch 'evidence_confidence_weight') { Pass "Sprint 6: scanner.js has no evidence_confidence_weight" }
  else { Fail "Sprint 6: scanner.js references evidence_confidence_weight" }
  if ($js -match 'Unscorable' -and $js -match 'partial') {
    Pass "Sprint 6: scanner.js implements Unscorable and Partial Profile logic"
  } else { Fail "Sprint 6: scanner.js missing Unscorable/Partial Profile logic" }
} else {
  Fail "Sprint 6: assets/js/scanner.js missing"
}

# --- Sprint 7: Reports and trust pages -----------------------------------------------
$sprint7Routes = @(
  '/methodology/', '/governance/', '/sources/',
  '/reports/ati-snapshot/', '/privacy/', '/terms/'
)
foreach ($r in $sprint7Routes) {
  if ($pages.ContainsKey($r)) { Pass "Sprint 7: $r exists" }
  else { Fail "Sprint 7: missing trust/report page $r" }
}

if ($pages.ContainsKey('/methodology/')) {
  $m = $pages['/methodology/']
  $methHeadings = @(
    'Governing Thesis', 'Why Transitions Matter', 'How ATI Scores Movement',
    'How Evidence Confidence Works', 'How TFO Classifies Failure',
    'How Scanner v1 Produces Output', 'What the System Does Not Claim',
    'Versioning and Governance', 'Related Reference Pages'
  )
  $missingMeth = $methHeadings | Where-Object { $m -notmatch "<h2>$_</h2>" }
  if (-not $missingMeth) { Pass "[/methodology/] all required section headings present" }
  else { foreach ($h in $missingMeth) { Fail "[/methodology/] missing heading: $h" } }
  if ($m -match 'AIDAtanaly measures transition health\. It does not claim guaranteed causality or guaranteed revenue improvement') {
    Pass "[/methodology/] mandatory measurement claim restraint statement"
  } else { Fail "[/methodology/] missing mandatory claim restraint statement" }
  $methLinks = @('/aida-transition-analytics/', '/aida-transition-index/', '/evidence-confidence/',
    '/transition-failure-ontology/', '/scanner/', '/governance/', '/sources/')
  $missingMethLinks = $methLinks | Where-Object { $m -notmatch [regex]::Escape("href=`"$_`"") }
  if (-not $missingMethLinks) { Pass "[/methodology/] links to ATI, Evidence, TFO, Scanner, Governance, Sources" }
  else { foreach ($l in $missingMethLinks) { Fail "[/methodology/] missing required link: $l" } }
}

if ($pages.ContainsKey('/governance/')) {
  $g = $pages['/governance/']
  if ($g -match 'AIDAtanaly uses sequential document versioning\. Change severity is recorded in decision logs and is not encoded directly into the version number') {
    Pass "[/governance/] sequential versioning statement present"
  } else { Fail "[/governance/] missing sequential versioning statement" }
  if ($g -notmatch 'href="/governance/decisions/') {
    Pass "[/governance/] does not expose internal decision log paths as public links"
  } else { Fail "[/governance/] exposes internal governance/decisions/ as public link" }
}

if ($pages.ContainsKey('/sources/')) {
  $s = $pages['/sources/']
  if ($s -match 'AIDAtanaly may introduce governed internal standards before market adoption, but it must not describe them as adopted industry standards unless adoption evidence exists') {
    Pass "[/sources/] internal standards / adoption evidence statement present"
  } else { Fail "[/sources/] missing adoption evidence statement" }
}

if ($pages.ContainsKey('/reports/ati-snapshot/')) {
  $rpt = $pages['/reports/ati-snapshot/']
  $reportHeadings = @(
    'What the ATI Snapshot Provides', 'Who It Is For', 'What It Includes',
    'What It Does Not Claim', 'Evidence Confidence Treatment',
    'Relationship to Scanner', 'Relationship to ATI and TFO',
    'Example Output Sections', 'Trust and Limits'
  )
  $missingRpt = $reportHeadings | Where-Object { $rpt -notmatch "<h2>$_</h2>" }
  if (-not $missingRpt) { Pass "[/reports/ati-snapshot/] all required section headings present" }
  else { foreach ($h in $missingRpt) { Fail "[/reports/ati-snapshot/] missing heading: $h" } }
  $fearPatterns = @('act now', 'limited time', 'last chance', 'before it is too late', 'guaranteed revenue', 'revenue will increase')
  $fearHit = $fearPatterns | Where-Object { $rpt -match $_ -and $rpt -notmatch '\bnot\b|\bdoes not\b|\bno\b|\bwithout\b|\bprohibit' }
  if (-not $fearHit) { Pass "[/reports/ati-snapshot/] no fear-based or guarantee upsell language" }
  else { foreach ($f in $fearHit) { Fail "[/reports/ati-snapshot/] prohibited report language: $f" } }
}

if ($pages.ContainsKey('/privacy/')) {
  if ($pages['/privacy/'] -match 'The scanner should not require sensitive personal data') {
    Pass "[/privacy/] states scanner must not require sensitive personal data"
  } else { Fail "[/privacy/] missing sensitive personal data statement" }
}

if ($pages.ContainsKey('/terms/')) {
  $t = $pages['/terms/']
  if ($t -match 'Scanner outputs are diagnostic references, not guarantees of commercial outcome') {
    Pass "[/terms/] scanner no-guarantee statement present"
  } else { Fail "[/terms/] missing scanner no-guarantee statement" }
  if ($t -match '<h2>No Guarantee</h2>') { Pass "[/terms/] No Guarantee section present" }
  else { Fail "[/terms/] missing No Guarantee section" }
}

$trustRoutes = @('/methodology/', '/governance/', '/sources/', '/reports/ati-snapshot/', '/privacy/', '/terms/')
foreach ($r in $trustRoutes) {
  if (-not $pages.ContainsKey($r)) { continue }
  if ($pages[$r] -notmatch '<script') { Pass "[$r] no JavaScript required" }
  else { Fail "[$r] contains script tags; trust pages must not require JS" }
}

# --- Broken internal links among implemented pages -----------------------------------
$brokenTotal = 0
foreach ($route in ($pages.Keys | Sort-Object)) {
  $html = $pages[$route]
  $hrefs = [regex]::Matches($html, 'href="(/[^"]*)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
  foreach ($h in $hrefs) {
    if ($h -match '^/assets/') { continue }
    if (-not $pages.ContainsKey($h)) {
      Fail "[$route] broken internal link (target not implemented): $h"
      $brokenTotal++
    }
  }
}
if ($brokenTotal -eq 0) { Pass "Sprint 7: no broken internal links among $($pages.Count) implemented pages" }

$launchPageRoutes = @($launchRoutes | Where-Object { $_ -notmatch '\.json$' })
$missingLaunch = $launchPageRoutes | Where-Object { -not $pages.ContainsKey($_) }
if ($pages.Count -eq 41 -and -not $missingLaunch) {
  Pass "Sprint 7: 41/41 Required Launch routes implemented"
} else {
  Fail "Sprint 7: expected 41/41 routes, found $($pages.Count) implemented; missing: $($missingLaunch -join ', ')"
}

# --- Sprint 8: Sitemap, robots, reference graph --------------------------------------
$launchPageRoutes = @($launchRoutes | Where-Object { $_ -notmatch '\.json$' })
if ($launchPageRoutes.Count -ne 41) {
  Fail "Sprint 8: expected 41 launch page routes in ROUTE_MAP.md, found $($launchPageRoutes.Count)"
}

# Orphan detection: every route except / needs at least one inbound internal link
$inboundCount = @{}
foreach ($r in $pages.Keys) { $inboundCount[$r] = 0 }
foreach ($route in $pages.Keys) {
  $html = $pages[$route]
  $hrefs = [regex]::Matches($html, 'href="(/[^"]*)"') | ForEach-Object { $_.Groups[1].Value }
  foreach ($h in $hrefs) {
    if ($h -match '^/assets/') { continue }
    if ($pages.ContainsKey($h)) { $inboundCount[$h]++ }
  }
}
$orphans = @($pages.Keys | Where-Object { $_ -ne '/' -and $inboundCount[$_] -eq 0 })
if (-not $orphans) {
  Pass "Sprint 8: no orphan pages (all routes have inbound internal links)"
} else {
  foreach ($o in $orphans) { Fail "Sprint 8: orphan page (no inbound links): $o" }
}

# Up navigation: site header brand links to homepage
$missingUp = @($pages.Keys | Where-Object {
  $pages[$_] -notmatch 'layout-site-header__brand" href="/"'
})
if (-not $missingUp) { Pass "Sprint 8: all pages link up to / via site header" }
else { foreach ($u in $missingUp) { Fail "Sprint 8: [$u] missing site header link to /" } }

# Sideways/down: minimum internal hub linking per page
$weakLinkPages = @()
foreach ($route in ($pages.Keys | Sort-Object)) {
  $linkCount = ([regex]::Matches($pages[$route], 'href="(/[^"]*)"') |
    ForEach-Object { $_.Groups[1].Value } |
    Where-Object { $_ -notmatch '^/assets/' } | Sort-Object -Unique).Count
  if ($linkCount -lt 3) { $weakLinkPages += "$route ($linkCount links)" }
}
if (-not $weakLinkPages) { Pass "Sprint 8: all pages have minimum internal reference linking" }
else { foreach ($w in $weakLinkPages) { Fail "Sprint 8: insufficient internal links on $w" } }

# robots.txt remains non-indexed pre-launch
$robotsPath = Join-Path $root 'robots.txt'
if (Test-Path $robotsPath) {
  $robots = Get-Content -Raw -Encoding UTF8 -Path $robotsPath
  if ($robots -match '(?m)^Disallow:\s*/\s*$') {
    Pass "Sprint 8: robots.txt Disallow: / (pre-launch non-indexed)"
  } else { Fail "Sprint 8: robots.txt missing Disallow: /" }
  if ($robots -match 'Sitemap will be enabled by PUBLIC_RELEASE_PLAN\.md') {
    Pass "Sprint 8: robots.txt documents deferred sitemap activation"
  } else { Fail "Sprint 8: robots.txt missing PUBLIC_RELEASE_PLAN sitemap note" }
  if ($robots -match '(?m)^Sitemap:\s*https://') {
    Fail "Sprint 8: robots.txt must not declare an active Sitemap line pre-launch"
  } else { Pass "Sprint 8: robots.txt has no active Sitemap directive" }
} else { Fail "Sprint 8: robots.txt missing" }

# sitemap.xml governance
$sitemapPath = Join-Path $root 'sitemap.xml'
if (-not (Test-Path $sitemapPath)) {
  Fail "Sprint 8: sitemap.xml missing (run scripts/generate-sitemap.ps1)"
} else {
  Pass "Sprint 8: sitemap.xml exists"
  $sitemap = Get-Content -Raw -Encoding UTF8 -Path $sitemapPath
  $locs = @([regex]::Matches($sitemap, '<loc>([^<]+)</loc>') | ForEach-Object { $_.Groups[1].Value })
  if ($locs.Count -eq 41) {
    Pass "Sprint 8: sitemap route count = 41"
  } else {
    Fail "Sprint 8: sitemap route count = $($locs.Count) (expected 41)"
  }

  $sitemapPaths = @()
  foreach ($loc in $locs) {
    if ($loc -notmatch '^https://aidatanaly\.com') {
      Fail "Sprint 8: sitemap loc outside aidatanaly.com domain: $loc"
    }
    $path = ($loc -replace '^https://aidatanaly\.com', '')
    if ($path -eq '') { $path = '/' }
    $sitemapPaths += $path
    if ($path -ne '/' -and -not $path.EndsWith('/')) {
      Fail "Sprint 8: sitemap loc missing trailing slash: $loc"
    }
    if ($launchPageRoutes -notcontains $path) {
      Fail "Sprint 8: sitemap loc outside Required Launch set: $loc"
    }
    if (-not $pages.ContainsKey($path)) {
      Fail "Sprint 8: sitemap loc without implemented index.html: $loc"
    }
  }

  $extraSitemap = $sitemapPaths | Where-Object { $launchPageRoutes -notcontains $_ }
  if (-not $extraSitemap) { Pass "Sprint 8: extra sitemap routes = 0" }
  else { Fail "Sprint 8: extra sitemap routes: $($extraSitemap -join ', ')" }

  $missingSitemap = $launchPageRoutes | Where-Object { $sitemapPaths -notcontains $_ }
  if (-not $missingSitemap) { Pass "Sprint 8: missing required routes in sitemap = 0" }
  else { Fail "Sprint 8: missing sitemap routes: $($missingSitemap -join ', ')" }

  $forbiddenInLoc = @('/preview/', '/data/', '/assets/', '/scripts/', '/governance/decisions/', '.md')
  $badLocs = @()
  foreach ($loc in $locs) {
    $path = ($loc -replace '^https://aidatanaly\.com', '')
    if ($path -eq '') { $path = '/' }
    foreach ($seg in $forbiddenInLoc) {
      if ($path -match [regex]::Escape($seg)) { $badLocs += "$loc ($seg)" }
    }
  }
  if (-not $badLocs) {
    Pass "Sprint 8: sitemap loc URLs exclude preview, data, assets, scripts, decisions, and markdown"
  } else {
    foreach ($b in $badLocs) { Fail "Sprint 8: sitemap loc contains forbidden segment: $b" }
  }
}

if ($pages.Count -eq 41) { Pass "Sprint 8: implemented route count = 41" }
else { Fail "Sprint 8: implemented route count = $($pages.Count) (expected 41)" }

$noindexMissing = @($pages.Keys | Where-Object { $pages[$_] -notmatch '<meta\s+name="robots"\s+content="noindex"' })
if (-not $noindexMissing) { Pass "Sprint 8: all pages retain pre-launch noindex" }
else { foreach ($n in $noindexMissing) { Fail "Sprint 8: [$n] missing noindex meta" } }

# --- Summary --------------------------------------------------------------------------
Write-Host ""
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 } else { exit 0 }
