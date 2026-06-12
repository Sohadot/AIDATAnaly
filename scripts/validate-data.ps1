# validate-data.ps1
# Sprint 1 acceptance checks for the AIDAtanaly /data/ registry.
# Governed by: IMPLEMENTATION_PLAN.md (IMPL-PLAN-001), Sprint 1 acceptance criteria.
# Validates /data/*.json against TFO_ONTOLOGY.md and ROUTE_MAP.md as sources of truth.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$failures = @()
$passes = @()

function Pass([string]$msg) { $script:passes += $msg; Write-Host "  PASS  $msg" }
function Fail([string]$msg) { $script:failures += $msg; Write-Host "  FAIL  $msg" }

Write-Host "=== AIDAtanaly Data Registry Validation ==="

# --- 1. JSON parse checks -------------------------------------------------
$dataFiles = @(
  'data/ati-standard.json',
  'data/ati-vectors.json',
  'data/tfo-failure-modes.json',
  'data/intervention-layers.json',
  'data/scanner-model.json'
)
$json = @{}
$rawText = @{}
foreach ($f in $dataFiles) {
  $path = Join-Path $root $f
  try {
    $raw = Get-Content -Raw -Encoding UTF8 -Path $path
    $rawText[$f] = $raw
    $json[$f] = $raw | ConvertFrom-Json
    Pass "$f parses cleanly"
  } catch {
    Fail "$f failed to parse: $($_.Exception.Message)"
  }
}
if ($failures.Count -gt 0) { Write-Host "Aborting: parse failures."; exit 1 }

$atiStd   = $json['data/ati-standard.json']
$atiVec   = $json['data/ati-vectors.json']
$tfo      = $json['data/tfo-failure-modes.json']
$layers   = $json['data/intervention-layers.json']
$scanner  = $json['data/scanner-model.json']

# --- 2. D1-D7 weights total 100% ------------------------------------------
foreach ($pair in @(
  @{ name = 'ati-standard.json'; dims = $atiStd.dimensions },
  @{ name = 'scanner-model.json'; dims = $scanner.dimensions }
)) {
  $sum = ($pair.dims | Measure-Object -Property weight -Sum).Sum
  if ([math]::Abs($sum - 1.0) -lt 0.0001 -and $pair.dims.Count -eq 7) {
    Pass "$($pair.name): D1-D7 weights total 100% (7 dimensions)"
  } else {
    Fail "$($pair.name): D1-D7 weights total $sum across $($pair.dims.Count) dimensions"
  }
}

# --- 3. Vector weights total 100% ------------------------------------------
foreach ($pair in @(
  @{ name = 'ati-standard.json'; w = $atiStd.vector_weighting.weights },
  @{ name = 'scanner-model.json'; w = $scanner.vector_weights }
)) {
  $sum = ($pair.w | Measure-Object -Property weight -Sum).Sum
  if ([math]::Abs($sum - 1.0) -lt 0.0001 -and $pair.w.Count -eq 4) {
    Pass "$($pair.name): T1-T4 vector weights total 100% (4 vectors)"
  } else {
    Fail "$($pair.name): vector weights total $sum across $($pair.w.Count) vectors"
  }
}

# --- 4. TFO registry: 21 failure modes + 1 constraint ----------------------
$fmCount = @($tfo.failure_modes).Count
$cxCount = @($tfo.diagnostic_constraints).Count
if ($fmCount -eq 21) { Pass "tfo-failure-modes.json: 21 failure modes present" }
else { Fail "tfo-failure-modes.json: expected 21 failure modes, found $fmCount" }
if ($cxCount -eq 1 -and $tfo.diagnostic_constraints[0].id -eq 'tfo.constraint.measurement_gap') {
  Pass "tfo-failure-modes.json: measurement_gap constraint present"
} else { Fail "tfo-failure-modes.json: measurement_gap constraint missing or malformed" }

# --- 5. Every tfo.* ID matches TFO_ONTOLOGY.md ------------------------------
$ontologyText = Get-Content -Raw -Encoding UTF8 -Path (Join-Path $root 'TFO_ONTOLOGY.md')
$ontologyIds = [regex]::Matches($ontologyText, 'tfo\.(?:t[1-4]|constraint)\.[a-z_]+') |
  ForEach-Object { $_.Value } | Sort-Object -Unique
$jsonIds = @($tfo.failure_modes | ForEach-Object { $_.id }) + @($tfo.diagnostic_constraints | ForEach-Object { $_.id }) |
  Sort-Object -Unique

$missingInJson = $ontologyIds | Where-Object { $jsonIds -notcontains $_ }
$extraInJson   = $jsonIds | Where-Object { $ontologyIds -notcontains $_ }
if (-not $missingInJson -and -not $extraInJson) {
  Pass "tfo-failure-modes.json: ID set exactly matches TFO_ONTOLOGY.md ($($jsonIds.Count) IDs)"
} else {
  if ($missingInJson) { Fail "IDs in TFO_ONTOLOGY.md missing from JSON: $($missingInJson -join ', ')" }
  if ($extraInJson)   { Fail "IDs in JSON not found in TFO_ONTOLOGY.md: $($extraInJson -join ', ')" }
}

# --- 6. No failure mode reference outside TFO registry ----------------------
$refFiles = @('data/ati-vectors.json', 'data/scanner-model.json', 'data/tfo-failure-modes.json')
$badRefs = @()
foreach ($f in $refFiles) {
  $refs = [regex]::Matches($rawText[$f], '"(tfo\.(?:t[1-4]|constraint)\.[a-z_]+)"') |
    ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
  foreach ($r in $refs) {
    if ($jsonIds -notcontains $r) { $badRefs += "$f -> $r" }
  }
}
if (-not $badRefs) { Pass "All tfo.* references across data files resolve to the TFO registry" }
else { foreach ($b in $badRefs) { Fail "Unregistered failure mode reference: $b" } }

# --- 7. Every canonical_route matches ROUTE_MAP.md --------------------------
$routeMapText = Get-Content -Encoding UTF8 -Path (Join-Path $root 'ROUTE_MAP.md')
$launchRoutes = $routeMapText | ForEach-Object { $_.Trim() } |
  Where-Object { $_ -match '^/[a-z0-9\-/\.]*$' } | Sort-Object -Unique
if ($launchRoutes.Count -eq 41) { Pass "ROUTE_MAP.md: extracted 41 Required Launch routes" }
else { Fail "ROUTE_MAP.md: expected 41 launch routes, extracted $($launchRoutes.Count)" }

$badRoutes = @()
foreach ($f in $dataFiles) {
  $routes = [regex]::Matches($rawText[$f], '"(/[a-z0-9\-/\.{}]*)"') |
    ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
  foreach ($r in $routes) {
    if ($r -match '\{') { continue } # templates like /failure-modes/{slug}/
    if ($r -match '^/data/') { continue } # deferred data endpoints, governed by ROUTE_MAP section 11
    if ($launchRoutes -notcontains $r) { $badRoutes += "$f -> $r" }
  }
}
if (-not $badRoutes) { Pass "All canonical routes in data files exist in ROUTE_MAP.md launch set" }
else { foreach ($b in $badRoutes) { Fail "Route outside ROUTE_MAP launch set: $b" } }

# --- 8. Intervention layers: exactly 10, approved only ----------------------
$approved = @(
  'Audience Intervention','Message Intervention','Offer Intervention','Proof Intervention',
  'UX Intervention','Pricing Intervention','Timing Intervention','Attribution Intervention',
  'Lifecycle Intervention','Sales-Assist Intervention'
)
$layerNames = @($layers.layers | ForEach-Object { $_.name })
$layerIds = @($layers.layers | ForEach-Object { $_.id })
if ($layerNames.Count -eq 10 -and -not ($approved | Where-Object { $layerNames -notcontains $_ })) {
  Pass "intervention-layers.json: exactly the 10 approved layers"
} else {
  Fail "intervention-layers.json: layer set mismatch (found: $($layerNames -join '; '))"
}

# --- 9. Channel Intervention / Measurement Governance not standalone --------
foreach ($label in @('Channel Intervention', 'Measurement Governance')) {
  if ($layerNames -contains $label) {
    Fail "'$label' must not be a standalone layer"
  } else {
    $mapping = $layers.contextual_mappings | Where-Object { $_.label -eq $label }
    if ($mapping -and $mapping.is_standalone_layer -eq $false -and @($mapping.parent_layers).Count -ge 1) {
      Pass "'$label' is a contextual mapping with parent layer(s): $($mapping.parent_layers -join ', ')"
    } else {
      Fail "'$label' contextual mapping missing or malformed"
    }
  }
}

# --- 10. Intervention references resolve to registry ------------------------
$intRefs = [regex]::Matches($rawText['data/tfo-failure-modes.json'], '"(intervention\.[a-z_]+)"') |
  ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
$badInt = $intRefs | Where-Object { $layerIds -notcontains $_ -and $_ -ne 'intervention.layers' }
if (-not $badInt) { Pass "All intervention layer references in TFO registry resolve to approved layers" }
else { foreach ($b in $badInt) { Fail "Unapproved intervention reference: $b" } }

# --- 11. Partial Profile rule present ---------------------------------------
foreach ($pair in @(
  @{ name = 'ati-standard.json'; obj = $atiStd.partial_profile_rule },
  @{ name = 'scanner-model.json'; obj = $scanner.partial_profile_rule }
)) {
  if ($pair.obj -and $pair.obj.statement) { Pass "$($pair.name): Partial Profile rule present" }
  else { Fail "$($pair.name): Partial Profile rule missing" }
}

# --- 12. No evidence_confidence_weight anywhere ------------------------------
$violations = @()
foreach ($f in $dataFiles) {
  if ($rawText[$f] -match 'evidence_confidence_weight') { $violations += $f }
}
if (-not $violations) { Pass "No 'evidence_confidence_weight' exists in any data file" }
else { foreach ($v in $violations) { Fail "'evidence_confidence_weight' found in $v" } }

# --- 13. Evidence Confidence is not a score component ------------------------
if ($atiStd.evidence_confidence.is_score_component -eq $false -and
    $scanner.evidence_confidence_rules.is_score_component -eq $false) {
  Pass "Evidence Confidence flagged as non-score-component in both files"
} else {
  Fail "Evidence Confidence is_score_component flag missing or true"
}

# --- 14. Diagnostic thresholds match between files ----------------------------
$mismatch = @()
foreach ($t in $scanner.diagnostic_thresholds) {
  $ref = $atiStd.diagnostic_classes | Where-Object { $_.name -eq $t.name }
  if (-not $ref -or $ref.min_score -ne $t.min_score -or $ref.max_score -ne $t.max_score) {
    $mismatch += $t.name
  }
}
if (-not $mismatch -and @($scanner.diagnostic_thresholds).Count -eq 5) {
  Pass "Diagnostic class thresholds match between ati-standard and scanner-model (5 classes)"
} else {
  Fail "Diagnostic threshold mismatch: $($mismatch -join ', ')"
}

# --- 15. Vector failure_mode_ids coverage -------------------------------------
$vecFmIds = @($atiVec.vectors | ForEach-Object { $_.failure_mode_ids }) | Sort-Object -Unique
$registryFmIds = @($tfo.failure_modes | ForEach-Object { $_.id }) | Sort-Object -Unique
$missingFromVectors = $registryFmIds | Where-Object { $vecFmIds -notcontains $_ }
if (-not $missingFromVectors -and $vecFmIds.Count -eq 21) {
  Pass "ati-vectors.json: all 21 failure modes assigned across T1-T4"
} else {
  Fail "ati-vectors.json: failure mode coverage mismatch (missing: $($missingFromVectors -join ', '))"
}

# --- Summary -------------------------------------------------------------------
Write-Host ""
Write-Host "=== Summary: $($passes.Count) passed, $($failures.Count) failed ==="
if ($failures.Count -gt 0) { exit 1 } else { exit 0 }
