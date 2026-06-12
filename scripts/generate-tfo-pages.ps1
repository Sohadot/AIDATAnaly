# generate-tfo-pages.ps1
# Generates TFO overview and failure mode pages from data/tfo-failure-modes.json
# with AI Instrumentation extracted from TFO_ONTOLOGY.md.
# Governed by: PAGE_BLUEPRINTS.md §13–§15, IMPLEMENTATION_PLAN.md Sprint 5.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$tfoJson = Get-Content -Raw -Encoding UTF8 -Path (Join-Path $root 'data/tfo-failure-modes.json') | ConvertFrom-Json
$layersJson = Get-Content -Raw -Encoding UTF8 -Path (Join-Path $root 'data/intervention-layers.json') | ConvertFrom-Json
$ontologyText = Get-Content -Raw -Encoding UTF8 -Path (Join-Path $root 'TFO_ONTOLOGY.md')

function Escape-Html([string]$s) {
  if (-not $s) { return '' }
  return ($s -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;' -replace '"', '&quot;')
}

$vectorRoutes = @{
  'ati.vector.t1' = @{ path = '/vectors/attention-to-interest/'; label = 'T1 - Attention to Interest (Signal Conversion)' }
  'ati.vector.t2' = @{ path = '/vectors/interest-to-desire/'; label = 'T2 - Interest to Desire (Intent Formation)' }
  'ati.vector.t3' = @{ path = '/vectors/desire-to-action/'; label = 'T3 - Desire to Action (Conversion Friction)' }
  'ati.vector.t4' = @{ path = '/vectors/action-to-loyalty/'; label = 'T4 - Action to Loyalty (Retention Extension)' }
}

$dimLabels = @{
  'ati.dimension.d1' = 'D1 - Signal Quality'
  'ati.dimension.d2' = 'D2 - Movement Probability'
  'ati.dimension.d3' = 'D3 - Transition Velocity'
  'ati.dimension.d4' = 'D4 - Friction Resilience'
  'ati.dimension.d5' = 'D5 - Drop-Off Resilience'
  'ati.dimension.d6' = 'D6 - Commercial Consequence'
  'ati.dimension.d7' = 'D7 - Intervention Clarity'
}

$layerNames = @{}
foreach ($l in $layersJson.layers) { $layerNames[$l.id] = $l.name }

$idToEntry = @{}
foreach ($fm in $tfoJson.failure_modes) { $idToEntry[$fm.id] = $fm }
foreach ($cx in $tfoJson.diagnostic_constraints) { $idToEntry[$cx.id] = $cx }

function Get-AiInstrumentation([string]$stableId) {
  $escaped = [regex]::Escape($stableId)
  $pattern = '(?s)\*\*Stable ID:\*\* ``' + $escaped + '``.*?\*\*AI Instrumentation\*\*\s*\r?\n\r?\nAI may assist by:\s*\r?\n\r?\n((?:- .+\r?\n)+)'
  if ($ontologyText -match $pattern) {
    return $Matches[1].Trim()
  }
  if ($stableId -eq 'tfo.constraint.measurement_gap') {
    return @"
- identifying missing signals,
- mapping disconnected measurement systems,
- detecting unsupported claims,
- suggesting which events or data sources must be captured.
"@.Trim()
  }
  return "- Assisting pattern detection within governed scanner rules`n- Supporting evidence classification without replacing measurement"
}

function Get-ListHtml($items) {
  $lis = ($items | ForEach-Object { "            <li>$(Escape-Html $_)</li>" }) -join "`n"
  return "<ul>`n$lis`n          </ul>"
}

function Get-InterventionHtml($entry) {
  $tags = ($entry.intervention_layers | ForEach-Object {
    $name = $layerNames[$_]
    if ($name) { "          <span class=`"intervention-tag`">$(Escape-Html $name)</span>" }
  }) -join "`n"
  $notes = ''
  if ($entry.contextual_intervention_notes) {
    $noteLis = ($entry.contextual_intervention_notes | ForEach-Object { "            <li>$(Escape-Html $_)</li>" }) -join "`n"
    $notes = "`n          <ul>`n$noteLis`n          </ul>"
  }
  return "$tags$notes"
}

function Get-ScoringImpactHtml($entry) {
  if (-not $entry.scoring_impact -or @($entry.scoring_impact).Count -eq 0) {
    $notes = if ($entry.scoring_impact_notes) { ($entry.scoring_impact_notes -join ' ') } else { '' }
    return "<p>$(Escape-Html $notes)</p>"
  }
  $dims = ($entry.scoring_impact | ForEach-Object {
    if ($dimLabels.ContainsKey($_)) { $dimLabels[$_] } else { $_ }
  })
  $html = "<p>$($entry.name) primarily weakens:</p>`n          <ul>`n"
  $html += ($dims | ForEach-Object { "            <li>$(Escape-Html $_)</li>" }) -join "`n"
  $html += "`n          </ul>"
  if ($entry.scoring_impact_notes) {
    $html += "`n          <p class=`"utility-muted`">$(Escape-Html ($entry.scoring_impact_notes -join ' '))</p>"
  }
  return $html
}

function Get-WhyItMatters([object]$entry, [bool]$isConstraint) {
  if ($isConstraint) {
    return 'Without reliable measurement, ATI cannot distinguish weak movement from unmeasured movement. Measurement Gap is the governed name for that uncertainty; it limits how strongly any other diagnosis should be interpreted.'
  }
  $vec = $entry.primary_vector
  switch ($vec) {
    'ati.vector.t1' { return "Weakness on $($entry.transition) prevents the funnel from building qualified curiosity. $($entry.name) is one of the governed ways that break manifests, not as vague underperformance, but as a named, locatable failure class." }
    'ati.vector.t2' { return "When $($entry.transition) fails, engagement does not become commercial desire. $($entry.name) names a specific pattern of that failure so correction can target the right intervention layer." }
    'ati.vector.t3' { return "Intent that never becomes action is direct revenue loss. $($entry.name) locates the break on $($entry.transition) so teams do not misattribute a T3 problem to traffic or content alone." }
    'ati.vector.t4' { return "First conversion without continuity leaves lifetime value unrealized. $($entry.name) describes how $($entry.transition) fails after the transaction, a break most acquisition-focused reporting never names." }
    default { return "This failure mode names a governed pattern of weak movement on $($entry.transition)." }
  }
}

function Get-EvidenceHtml([object]$entry, [bool]$isConstraint) {
  if ($isConstraint) {
    return @"
        <p><strong>Measurement Gap limits diagnostic confidence. It does not automatically prove that the transition is broken.</strong></p>
        <p>Measurement Gap affects Evidence Confidence, not the ATI score directly. When evidence is absent (E0), no numeric vector score should be issued. When evidence is self-reported only (E1), scores must use provisional language.</p>
        <p><strong>If a vector is E0, Scanner v1 must not issue a numeric vector score, and if one or more vectors are E0, Scanner v1 must issue a Partial Profile rather than a clean composite ATI score.</strong></p>
"@
  }
  return @"
        <p>Diagnosis of $($entry.name) requires the detection signals listed on this page to be observable, not assumed. When evidence is E1 Self-Reported, scanner output must describe the finding as provisional. When evidence is E0 Absent, the parent vector may be Unscorable rather than scored.</p>
        <p>Stronger evidence levels permit stronger language but never imply guaranteed causality or revenue outcomes. See <a href="/evidence-confidence/">Evidence Confidence</a>.</p>
"@
}

function Get-ScannerLanguageHtml([object]$entry, [bool]$isConstraint) {
  $name = Escape-Html $entry.name
  if ($isConstraint) {
    return @"
        <p><strong>Allowed:</strong> &ldquo;Measurement Gap limits the confidence of this diagnosis.&rdquo;</p>
        <p><strong>Allowed:</strong> &ldquo;T4: Unscorable / E0 Absent Evidence.&rdquo;</p>
        <p><strong>Prohibited:</strong> &ldquo;No data means your funnel is broken.&rdquo;</p>
        <p><strong>Prohibited:</strong> &ldquo;Fixing measurement guarantees conversion growth.&rdquo;</p>
"@
  }
  $transition = Escape-Html $entry.transition
  return @"
        <p><strong>Allowed:</strong> &ldquo;The likely failure mode is $name.&rdquo;</p>
        <p><strong>Allowed:</strong> &ldquo;This failure mode may indicate weak movement on $transition.&rdquo;</p>
        <p><strong>Allowed:</strong> &ldquo;This diagnosis is based on E1 Self-Reported Evidence and should be treated as provisional.&rdquo;</p>
        <p><strong>Prohibited:</strong> &ldquo;This failure mode proves why revenue is falling.&rdquo;</p>
        <p><strong>Prohibited:</strong> &ldquo;Fixing this failure mode guarantees conversion growth.&rdquo;</p>
"@
}

function Write-FailureModePage([object]$entry, [bool]$isConstraint) {
  $route = $entry.canonical_route.TrimEnd('/')
  $slug = $route -replace '^/failure-modes/', ''
  $outDir = Join-Path $root ("failure-modes\$slug")
  New-Item -ItemType Directory -Force -Path $outDir | Out-Null
  $outPath = Join-Path $outDir 'index.html'

  $name = Escape-Html $entry.name
  $stableId = Escape-Html $entry.id
  $canonical = "https://aidatanaly.com$($entry.canonical_route)"
  $descText = $entry.definition
  if ($descText.Length -gt 155) { $descText = $descText.Substring(0, 155).Trim() + '...' }
  $desc = Escape-Html $descText

  $blockClass = if ($isConstraint) { ' dossier-block--constraint' } else { '' }
  $metaRows = if ($isConstraint) {
    @"
          <dt>Stable ID</dt><dd><span class="stable-id-chip">$stableId</span></dd>
          <dt>Primary Classification</dt><dd>Diagnostic Constraint</dd>
          <dt>Applies Across</dt><dd>T1, T2, T3, T4 (all transition vectors)</dd>
          <dt>Canonical Route</dt><dd><span class="utility-mono">$(Escape-Html $entry.canonical_route)</span></dd>
"@
  } else {
    $vec = $vectorRoutes[$entry.primary_vector]
    @"
          <dt>Stable ID</dt><dd><span class="stable-id-chip">$stableId</span></dd>
          <dt>Primary Vector</dt><dd><a href="$($vec.path)">$(Escape-Html $vec.label)</a></dd>
          <dt>Transition Name</dt><dd>$(Escape-Html $entry.transition)</dd>
          <dt>Canonical Route</dt><dd><span class="utility-mono">$(Escape-Html $entry.canonical_route)</span></dd>
          <dt>Diagnostic Class</dt><dd>$(Escape-Html $entry.diagnostic_class)</dd>
"@
  }

  $relatedLinks = ($entry.related_failure_modes | ForEach-Object {
    $rel = $idToEntry[$_]
    if ($rel) {
      $rn = Escape-Html $rel.name
      $rr = Escape-Html $rel.canonical_route
      "          <li><a href=`"$rr`">$rn</a> <span class=`"stable-id-chip`">$(Escape-Html $_)</span></li>"
    }
  }) -join "`n"

  $aiBullets = Get-AiInstrumentation $entry.id
  $aiHtml = ($aiBullets -split "`n" | Where-Object { $_.Trim() } | ForEach-Object {
    $t = $_.TrimStart('- ').Trim()
    "            <li>$(Escape-Html $t)</li>"
  }) -join "`n"

  $whyHeading = if ($isConstraint) { 'Why It Matters' } else { 'Why It Matters' }
  $pageClass = if ($isConstraint) { 'Diagnostic Constraint Page' } else { 'Failure Mode Page' }

  $parentVectorLink = if (-not $isConstraint) {
    $v = $vectorRoutes[$entry.primary_vector]
    "          <li><a href=`"$($v.path)`">Parent vector</a><span class=`"reference-links__route`">$($v.path)</span></li>`n"
  } else {
    ($vectorRoutes.GetEnumerator() | Sort-Object { $_.Key } | ForEach-Object {
      "          <li><a href=`"$($_.Value.path)`">$(Escape-Html $_.Value.label)</a><span class=`"reference-links__route`">$($_.Value.path)</span></li>"
    }) -join "`n"
    "`n"
  }

  $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$name - TFO Diagnostic $(if ($isConstraint) { 'Constraint' } else { 'Dossier' }) | AIDAtanaly</title>
  <meta name="description" content="$desc">
  <link rel="canonical" href="$canonical">
  <meta name="robots" content="noindex">
  <link rel="stylesheet" href="/assets/css/main.css">
  <!--
  Path: $($entry.canonical_route)
  Page Class: $pageClass
  Route Status: Required Launch
  Primary Governed Document: TFO_ONTOLOGY.md (v1.0)
  Machine-Readable Mapping: /data/tfo-failure-modes.json ($($entry.id))
  -->
</head>
<body>
  <a class="utility-skip-link" href="#main">Skip to content</a>
  <div class="layout-page">
    <header class="layout-site-header">
      <a class="layout-site-header__brand" href="/">AIDAtanaly</a>
      <nav class="layout-nav" aria-label="Primary">
        <a href="/aida-transition-analytics/">Category</a>
        <a href="/aida-transition-index/">ATI Standard</a>
        <a href="/transition-failure-ontology/" aria-current="page">Failure Ontology</a>
        <a href="/scanner/">Scanner</a>
        <a href="/methodology/">Methodology</a>
      </nav>
    </header>
    <main id="main">
      <article class="dossier-block$blockClass">
        <header class="layout-header dossier-block__header">
          <p class="layout-section__kicker">$(if ($isConstraint) { 'Diagnostic constraint' } else { 'Failure mode dossier' })</p>
          <h1>$name</h1>
        </header>
        <dl class="layout-prose">
$metaRows
        </dl>
      </article>

      <section class="layout-section">
        <h2>Definition</h2>
        <p>$(Escape-Html $entry.definition)</p>
      </section>

      <section class="layout-section">
        <h2>Core Diagnostic Question</h2>
        <p class="vector-card__question">$(Escape-Html $entry.core_diagnostic_question)</p>
      </section>

      <section class="layout-section">
        <h2>$whyHeading</h2>
        <p>$(Escape-Html (Get-WhyItMatters $entry $isConstraint))</p>
      </section>

      <section class="layout-section">
        <h2>Symptoms</h2>
        $(Get-ListHtml $entry.symptoms)
      </section>

      <section class="layout-section">
        <h2>Detection Signals</h2>
        $(Get-ListHtml $entry.detection_signals)
      </section>

      <section class="layout-section">
        <h2>Scoring Impact</h2>
        $(Get-ScoringImpactHtml $entry)
      </section>

      <section class="layout-section">
        <h2>Evidence Confidence Considerations</h2>
        $(Get-EvidenceHtml $entry $isConstraint)
      </section>

      <section class="layout-section">
        <h2>AI Instrumentation</h2>
        <p>AI may assist by:</p>
        <ul>
$aiHtml
        </ul>
        <p class="utility-muted">AI instrumentation supports classification and evidence review within governed scanner rules. It does not replace measurement or issue revenue guarantees.</p>
      </section>

      <section class="layout-section">
        <h2>Intervention Layers</h2>
        $(Get-InterventionHtml $entry)
        <p>See <a href="/intervention-layers/">Intervention Layers</a> for the full registry.</p>
      </section>

      <section class="layout-section">
        <h2>Related Failure Modes</h2>
        <ul>
$relatedLinks
        </ul>
      </section>

      <section class="layout-section">
        <h2>Scanner Output Language</h2>
        $(Get-ScannerLanguageHtml $entry $isConstraint)
      </section>

      <section class="layout-section">
        <h2>Internal Links</h2>
        <nav class="reference-links" aria-label="Governed references">
          <ul class="reference-links__list">
$parentVectorLink            <li><a href="/aida-transition-index/">AIDA Transition Index</a><span class="reference-links__route">/aida-transition-index/</span></li>
            <li><a href="/transition-failure-ontology/">Transition Failure Ontology</a><span class="reference-links__route">/transition-failure-ontology/</span></li>
            <li><a href="/scanner/">Transition Scanner</a><span class="reference-links__route">/scanner/</span></li>
            <li><a href="/evidence-confidence/">Evidence Confidence</a><span class="reference-links__route">/evidence-confidence/</span></li>
            <li><a href="/intervention-layers/">Intervention Layers</a><span class="reference-links__route">/intervention-layers/</span></li>
            <li><a href="/methodology/">Methodology</a><span class="reference-links__route">/methodology/</span></li>
            <li><a href="/governance/">Governance</a><span class="reference-links__route">/governance/</span></li>
          </ul>
        </nav>
      </section>

      <section class="layout-section">
        <h2>Version Notes</h2>
        <p>TFO Ontology v1.0. Stable ID <span class="stable-id-chip">$stableId</span> is fixed by
          <span class="utility-mono">TFO_ONTOLOGY.md</span> and mirrored in
          <span class="utility-mono">/data/tfo-failure-modes.json</span>.</p>
      </section>
    </main>
    <footer class="layout-footer">
      <nav class="layout-nav" aria-label="Trust">
        <a href="/governance/">Governance</a>
        <a href="/sources/">Sources</a>
        <a href="/privacy/">Privacy</a>
        <a href="/terms/">Terms</a>
      </nav>
      <p>AIDAtanaly.com - a Sohadot Sovereign Asset. Stages are states. Value lives in transitions.</p>
    </footer>
  </div>
</body>
</html>
"@

  [System.IO.File]::WriteAllText($outPath, $html, [System.Text.UTF8Encoding]::new($false))
  Write-Host "  wrote $outPath"
}

# --- Generate failure mode pages ------------------------------------------------
foreach ($fm in $tfoJson.failure_modes) { Write-FailureModePage $fm $false }
foreach ($cx in $tfoJson.diagnostic_constraints) { Write-FailureModePage $cx $true }

# --- Generate TFO overview ------------------------------------------------------
function Get-FmLinkLi($fm) {
  $n = Escape-Html $fm.name
  $r = Escape-Html $fm.canonical_route
  $id = Escape-Html $fm.id
  return "            <li><a href=`"$r`">$n</a> <span class=`"stable-id-chip`">$id</span></li>"
}

$t1f = $tfoJson.failure_modes | Where-Object { $_.primary_vector -eq 'ati.vector.t1' }
$t2f = $tfoJson.failure_modes | Where-Object { $_.primary_vector -eq 'ati.vector.t2' }
$t3f = $tfoJson.failure_modes | Where-Object { $_.primary_vector -eq 'ati.vector.t3' }
$t4f = $tfoJson.failure_modes | Where-Object { $_.primary_vector -eq 'ati.vector.t4' }
$mg = $tfoJson.diagnostic_constraints[0]

$allIndex = @()
foreach ($fm in $tfoJson.failure_modes) { $allIndex += Get-FmLinkLi $fm }
$allIndex += Get-FmLinkLi $mg

$overviewDir = Join-Path $root 'transition-failure-ontology'
New-Item -ItemType Directory -Force -Path $overviewDir | Out-Null

$overviewHtml = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Transition Failure Ontology (TFO) - Governed Failure Taxonomy | AIDAtanaly</title>
  <meta name="description" content="The Transition Failure Ontology classifies how funnel movement fails across T1-T4: 21 governed failure modes, one diagnostic constraint, stable IDs, and canonical routes.">
  <link rel="canonical" href="https://aidatanaly.com/transition-failure-ontology/">
  <meta name="robots" content="noindex">
  <link rel="stylesheet" href="/assets/css/main.css">
  <!--
  Route ID: AIDA-TFO-001
  Path: /transition-failure-ontology/
  Page Class: Ontology Page
  Route Status: Required Launch
  Primary Governed Document: TFO_ONTOLOGY.md (v1.0)
  Machine-Readable Mapping: /data/tfo-failure-modes.json
  -->
</head>
<body>
  <a class="utility-skip-link" href="#main">Skip to content</a>
  <div class="layout-page">
    <header class="layout-site-header">
      <a class="layout-site-header__brand" href="/">AIDAtanaly</a>
      <nav class="layout-nav" aria-label="Primary">
        <a href="/aida-transition-analytics/">Category</a>
        <a href="/aida-transition-index/">ATI Standard</a>
        <a href="/transition-failure-ontology/" aria-current="page">Failure Ontology</a>
        <a href="/scanner/">Scanner</a>
        <a href="/methodology/">Methodology</a>
      </nav>
    </header>
    <main id="main">
      <header class="layout-header">
        <p class="layout-section__kicker">Ontology - TFO v1.0</p>
        <h1>Transition Failure Ontology</h1>
        <p class="layout-prose">When the <a href="/aida-transition-index/">AIDA Transition Index</a> finds
          weak movement, the Transition Failure Ontology names <em>how</em> it fails: with stable IDs,
          canonical routes, and governed intervention mappings.</p>
      </header>

      <section class="layout-section">
        <h2>Definition</h2>
        <p>The Transition Failure Ontology (TFO) is a closed taxonomy of 21 failure modes across the
          four ATI transition vectors, plus one cross-vector diagnostic constraint
          (<span class="stable-id-chip">tfo.constraint.measurement_gap</span>). Each entry is a
          diagnostic dossier, not marketing advice.</p>
        <table>
          <thead><tr><th scope="col">System</th><th scope="col">Question</th></tr></thead>
          <tbody>
            <tr><td><a href="/aida-transition-index/">ATI</a></td><td><strong>How strong is the movement?</strong></td></tr>
            <tr><td>TFO</td><td><strong>What class of movement failure is present?</strong></td></tr>
          </tbody>
        </table>
      </section>

      <section class="layout-section">
        <h2>Why Failure Needs an Ontology</h2>
        <p>Unnamed failure produces generic fixes. TFO replaces &ldquo;the funnel is weak&rdquo; with
          governed identities such as <span class="stable-id-chip">tfo.t3.process_friction</span> or
          <span class="stable-id-chip">tfo.t2.value_ambiguity</span>, each linking to a parent vector,
          detection signals, and approved intervention layers.</p>
      </section>

      <section class="layout-section">
        <h2>Relationship to ATI</h2>
        <p>ATI scores transition health on T1&#8211;T4. TFO classifies the failure pattern when a vector
          is weak. A low T2 score might map to Comparison Stall, Value Ambiguity, or Passive Engagement,
          each with different intervention layers. ATI does not replace TFO; it triggers it.</p>
      </section>

      <section class="layout-section">
        <h2>T1 Failure Modes</h2>
        <p><a href="/vectors/attention-to-interest/">T1 - Attention to Interest</a></p>
        <ul>
$($t1f | ForEach-Object { Get-FmLinkLi $_ } | Out-String)
        </ul>
      </section>

      <section class="layout-section">
        <h2>T2 Failure Modes</h2>
        <p><a href="/vectors/interest-to-desire/">T2 - Interest to Desire</a></p>
        <ul>
$($t2f | ForEach-Object { Get-FmLinkLi $_ } | Out-String)
        </ul>
      </section>

      <section class="layout-section">
        <h2>T3 Failure Modes</h2>
        <p><a href="/vectors/desire-to-action/">T3 - Desire to Action</a></p>
        <ul>
$($t3f | ForEach-Object { Get-FmLinkLi $_ } | Out-String)
        </ul>
      </section>

      <section class="layout-section">
        <h2>T4 Failure Modes</h2>
        <p><a href="/vectors/action-to-loyalty/">T4 - Action to Loyalty</a></p>
        <ul>
$($t4f | ForEach-Object { Get-FmLinkLi $_ } | Out-String)
        </ul>
      </section>

      <section class="layout-section">
        <h2>Measurement Gap</h2>
        <article class="dossier-block dossier-block--constraint">
          <p><strong>Not a normal failure mode.</strong> Measurement Gap is a diagnostic constraint that
            limits Evidence Confidence when movement cannot be measured clearly.</p>
          <p><a href="/failure-modes/measurement-gap/">Measurement Gap</a>
            <span class="stable-id-chip">tfo.constraint.measurement_gap</span></p>
        </article>
      </section>

      <section class="layout-section">
        <h2>How Scanner Uses TFO</h2>
        <p>The <a href="/scanner/">Transition Scanner</a> names failure modes using TFO IDs only. It assigns
          a primary failure mode per weak vector (plus up to two secondary modes), links each name to its
          canonical dossier page, and respects Evidence Confidence, including Unscorable output when E0
          applies.</p>
      </section>

      <section class="layout-section">
        <h2>Intervention Layer Relationship</h2>
        <p>Every failure mode maps to approved <a href="/intervention-layers/">intervention layers</a>.
          Scanner recommendations stay at class level unless evidence supports tactical specificity.</p>
      </section>

      <section class="layout-section">
        <h2>Public Claim Limits</h2>
        <p>AIDAtanaly introduces the Transition Failure Ontology; it is not described as an adopted
          industry standard. Failure mode diagnosis does not prove revenue causality and does not
          promise outcomes. See <a href="/governance/">governance</a>.</p>
      </section>

      <section class="layout-section">
        <h2>Full Failure Mode Index</h2>
        <ul>
$($allIndex -join "`n")
        </ul>
      </section>

      <nav class="reference-links" aria-label="Governed references">
        <p class="reference-links__heading">Related reference pages</p>
        <ul class="reference-links__list">
          <li><a href="/aida-transition-index/">AIDA Transition Index</a><span class="reference-links__route">/aida-transition-index/</span></li>
          <li><a href="/vectors/attention-to-interest/">T1 vector</a></li>
          <li><a href="/vectors/interest-to-desire/">T2 vector</a></li>
          <li><a href="/vectors/desire-to-action/">T3 vector</a></li>
          <li><a href="/vectors/action-to-loyalty/">T4 vector</a></li>
          <li><a href="/scanner/">Transition Scanner</a><span class="reference-links__route">/scanner/</span></li>
          <li><a href="/evidence-confidence/">Evidence Confidence</a><span class="reference-links__route">/evidence-confidence/</span></li>
          <li><a href="/intervention-layers/">Intervention Layers</a><span class="reference-links__route">/intervention-layers/</span></li>
          <li><a href="/methodology/">Methodology</a><span class="reference-links__route">/methodology/</span></li>
          <li><a href="/governance/">Governance</a><span class="reference-links__route">/governance/</span></li>
        </ul>
      </nav>
    </main>
    <footer class="layout-footer">
      <nav class="layout-nav" aria-label="Trust">
        <a href="/governance/">Governance</a>
        <a href="/sources/">Sources</a>
        <a href="/privacy/">Privacy</a>
        <a href="/terms/">Terms</a>
      </nav>
      <p>AIDAtanaly.com - a Sohadot Sovereign Asset. Stages are states. Value lives in transitions.</p>
    </footer>
  </div>
</body>
</html>
"@

$overviewPath = Join-Path $overviewDir 'index.html'
[System.IO.File]::WriteAllText($overviewPath, $overviewHtml, [System.Text.UTF8Encoding]::new($false))
Write-Host "  wrote $overviewPath"
Write-Host "Done: $($tfoJson.failure_modes.Count) failure modes + $($tfoJson.diagnostic_constraints.Count) constraint + overview"
