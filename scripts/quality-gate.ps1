# quality-gate.ps1
# Sprint 9+ — governed pre-release quality gate and Sprint 10 private preview checks.
# Governed by: IMPLEMENTATION_PLAN.md Sprint 9-10, scripts/README.md.
#
# Runs all validators in order, regenerates sitemap, re-validates pages, and prints
# a single release posture report. Does NOT remove noindex or enable public indexing.

param(
  [switch]$PrivatePreview,
  [switch]$ReleasePackage
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$scriptsDir = $PSScriptRoot

function Get-LaunchRoutes {
  param([string]$RouteMapPath)
  $lines = Get-Content -Encoding UTF8 -Path $RouteMapPath
  return @($lines | ForEach-Object { $_.Trim() } |
    Where-Object { $_ -match '^/[a-z0-9\-/\.]*$' } | Sort-Object -Unique)
}

function Get-PagePath {
  param([string]$Route, [string]$Root)
  if ($Route -eq '/') { return Join-Path $Root 'index.html' }
  $rel = ($Route.Trim('/') -replace '/', '\') + '\index.html'
  return Join-Path $Root $rel
}

function Get-SiteMetrics {
  param([string]$Root)

  $launchRoutes = Get-LaunchRoutes (Join-Path $Root 'ROUTE_MAP.md')
  $launchPageRoutes = @($launchRoutes | Where-Object { $_ -notmatch '\.json$' })

  $pages = @{}
  foreach ($route in $launchPageRoutes) {
    $pagePath = Get-PagePath $route $Root
    if (Test-Path $pagePath) {
      $pages[$route] = Get-Content -Raw -Encoding UTF8 -Path $pagePath
    }
  }

  $brokenLinks = 0
  foreach ($route in $pages.Keys) {
    $hrefs = [regex]::Matches($pages[$route], 'href="(/[^"]*)"') |
      ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
    foreach ($h in $hrefs) {
      if ($h -match '^/assets/') { continue }
      if (-not $pages.ContainsKey($h)) { $brokenLinks++ }
    }
  }

  $inboundCount = @{}
  foreach ($r in $pages.Keys) { $inboundCount[$r] = 0 }
  foreach ($route in $pages.Keys) {
    $hrefs = [regex]::Matches($pages[$route], 'href="(/[^"]*)"') |
      ForEach-Object { $_.Groups[1].Value }
    foreach ($h in $hrefs) {
      if ($h -match '^/assets/') { continue }
      if ($pages.ContainsKey($h)) { $inboundCount[$h]++ }
    }
  }
  $orphanPages = @($pages.Keys | Where-Object { $_ -ne '/' -and $inboundCount[$_] -eq 0 }).Count

  $sitemapCount = 0
  $sitemapPath = Join-Path $Root 'sitemap.xml'
  if (Test-Path $sitemapPath) {
    $sitemap = Get-Content -Raw -Encoding UTF8 -Path $sitemapPath
    $sitemapCount = ([regex]::Matches($sitemap, '<loc>([^<]+)</loc>')).Count
  }

  $robotsOk = $false
  $sitemapDirectiveInactive = $true
  $robotsPath = Join-Path $Root 'robots.txt'
  if (Test-Path $robotsPath) {
    $robots = Get-Content -Raw -Encoding UTF8 -Path $robotsPath
    $robotsOk = $robots -match '(?m)^Disallow:\s*/\s*$'
    $sitemapDirectiveInactive = -not ($robots -match '(?m)^Sitemap:\s*https://')
  }

  $noindexMissing = @($pages.Keys | Where-Object {
    $pages[$_] -notmatch '<meta\s+name="robots"\s+content="noindex"'
  }).Count

  return [pscustomobject]@{
    RequiredLaunchRoutes     = $pages.Count
    RequiredLaunchTotal      = $launchPageRoutes.Count
    BrokenLinks              = $brokenLinks
    OrphanPages              = $orphanPages
    SitemapUrlCount          = $sitemapCount
    RobotsDisallowRoot       = $robotsOk
    RobotsSitemapInactive    = $sitemapDirectiveInactive
    PagesMissingNoindex      = $noindexMissing
  }
}

function Invoke-GovernedStep {
  param(
    [string]$Label,
    [string]$ScriptName
  )

  $scriptPath = Join-Path $scriptsDir $ScriptName
  if (-not (Test-Path $scriptPath)) {
    Write-Host ""
    Write-Host "=== Step: $Label ($ScriptName) ==="
    Write-Host "  FAIL  Script not found: $scriptPath"
    return $false
  }

  Write-Host ""
  Write-Host "=== Step: $Label ($ScriptName) ==="
  & $scriptPath
  $exitCode = $LASTEXITCODE
  if ($null -eq $exitCode) { $exitCode = 0 }

  if ($exitCode -ne 0) {
    Write-Host "  GATE  $Label FAILED (exit $exitCode)"
    return $false
  }

  Write-Host "  GATE  $Label PASSED"
  return $true
}

function Get-PythonExecutable {
  $candidates = @()
  foreach ($name in @('python3', 'python', 'py')) {
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd) { $candidates += $cmd.Source }
  }
  $localPython = Join-Path $env:LOCALAPPDATA 'Python\bin\python3.exe'
  if (Test-Path $localPython) { $candidates += $localPython }

  foreach ($candidate in ($candidates | Select-Object -Unique)) {
    try {
      $version = & $candidate --version 2>&1
      if ($LASTEXITCODE -eq 0 -and "$version" -match 'Python 3') {
        return $candidate
      }
    } catch { continue }
  }
  return $null
}

function Wait-PreviewServer {
  param(
    [string]$BaseUrl,
    [int]$TimeoutSec = 15
  )
  $deadline = (Get-Date).AddSeconds($TimeoutSec)
  while ((Get-Date) -lt $deadline) {
    try {
      $resp = Invoke-WebRequest -Uri $BaseUrl -UseBasicParsing -TimeoutSec 2
      if ($resp.StatusCode -eq 200) { return $true }
    } catch { Start-Sleep -Milliseconds 500 }
  }
  return $false
}

function Start-PreviewServer {
  param(
    [string]$Root,
    [int]$Port = 8000,
    [string]$PythonExe
  )
  $existing = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
  if ($existing) {
    return @{ Job = $null; Port = $Port; Started = $false; AlreadyRunning = $true }
  }
  $job = Start-Job -ScriptBlock {
    param($RootPath, $Py, $ListenPort)
    Set-Location $RootPath
    & $Py -m http.server $ListenPort
  } -ArgumentList $Root, $PythonExe, $Port
  $ready = Wait-PreviewServer -BaseUrl "http://localhost:$Port/"
  if (-not $ready) {
    Stop-PreviewServer -ServerInfo @{ Job = $job }
    throw "Preview server did not become ready on port $Port"
  }
  return @{ Job = $job; Port = $Port; Started = $true; AlreadyRunning = $false }
}

function Stop-PreviewServer {
  param($ServerInfo)
  if ($ServerInfo -and $ServerInfo.Job) {
    Stop-Job -Job $ServerInfo.Job -ErrorAction SilentlyContinue
    Remove-Job -Job $ServerInfo.Job -Force -ErrorAction SilentlyContinue
  }
}

function Test-PrivatePreviewRoutes {
  param(
    [string]$BaseUrl,
    [string]$Root
  )

  $routes = @(
    '/',
    '/aida-transition-index/',
    '/evidence-confidence/',
    '/transition-failure-ontology/',
    '/vectors/interest-to-desire/',
    '/failure-modes/measurement-gap/',
    '/scanner/',
    '/methodology/',
    '/governance/',
    '/sources/',
    '/reports/ati-snapshot/',
    '/privacy/',
    '/terms/'
  )

  $failures = @()
  foreach ($route in $routes) {
    $url = if ($route -eq '/') { "$BaseUrl/" } else { "$BaseUrl$route" }

    try {
      $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 15
      if ($resp.StatusCode -ne 200) {
        $failures += "$route HTTP $($resp.StatusCode)"
        Write-Host "  FAIL  [$route] HTTP $($resp.StatusCode)"
        continue
      }
      $html = $resp.Content
      $h1Count = ([regex]::Matches($html, '<h1[\s>]')).Count
      if ($h1Count -ne 1) {
        $failures += "$route h1 count $h1Count"
        Write-Host "  FAIL  [$route] expected 1 h1, found $h1Count"
        continue
      }
      if ($html -notmatch '<meta\s+name="robots"\s+content="noindex"') {
        $failures += "$route missing noindex"
        Write-Host "  FAIL  [$route] missing noindex"
        continue
      }
      $expectedCanonical = "https://aidatanaly.com$route"
      if ($html -notmatch [regex]::Escape("<link rel=`"canonical`" href=`"$expectedCanonical`"")) {
        $failures += "$route canonical mismatch"
        Write-Host "  FAIL  [$route] canonical mismatch"
        continue
      }
      if ($html -notmatch 'href="/assets/css/main\.css"') {
        $failures += "$route missing governed stylesheet"
        Write-Host "  FAIL  [$route] missing /assets/css/main.css"
        continue
      }
      Write-Host "  PASS  [$route] served with h1, noindex, canonical, css"
    } catch {
      $failures += "$route unreachable"
      Write-Host "  FAIL  [$route] $($_.Exception.Message)"
    }
  }

  try {
    $data = Invoke-WebRequest -Uri "$BaseUrl/data/scanner-model.json" -UseBasicParsing -TimeoutSec 10
    if ($data.StatusCode -eq 200) { Write-Host '  PASS  [/data/scanner-model.json] served for scanner' }
    else { $failures += 'scanner data JSON unavailable'; Write-Host '  FAIL  [/data/scanner-model.json] not served' }
  } catch {
    $failures += 'scanner data JSON unreachable'
    Write-Host "  FAIL  [/data/scanner-model.json] $($_.Exception.Message)"
  }

  return @{
    Ok = ($failures.Count -eq 0)
    Failures = $failures
  }
}

function Get-PreviewScannerScenarioScript {
  return @'
#!/usr/bin/env python3
from __future__ import annotations
import json, sys
from pathlib import Path
ROOT = Path(sys.argv[1]).resolve()
DATA = ROOT / "data"
VECTOR_EVIDENCE = {"ati.vector.t1": ["ev.analytics"], "ati.vector.t2": ["ev.analytics", "ev.crm_or_leads"], "ati.vector.t3": ["ev.conversion_tracking"], "ati.vector.t4": ["ev.retention"]}
def load_json(name):
    with open(DATA / name, encoding="utf-8") as f: return json.load(f)
def score_from_answer(value, answer_scale):
    for entry in answer_scale:
        if entry["value"] == value: return entry["score_equivalent"]
    return 0
def average(nums): return sum(nums) / len(nums) if nums else 0
def diagnostic_for(score, thresholds):
    for t in thresholds:
        if t["min_score"] <= score <= t["max_score"]: return t
    return thresholds[-1]
def build_tfo_by_id(tfo):
    by_id = {}
    for fm in tfo.get("failure_modes", []): by_id[fm["id"]] = fm
    for cx in tfo.get("diagnostic_constraints", []): by_id[cx["id"]] = cx
    return by_id
def build_vector_meta(ati_vectors): return {v["vector_id"]: v for v in ati_vectors.get("vectors", [])}
def get_evidence_answer(answers, qid):
    val = answers.get(qid, 0); return val if isinstance(val, int) else 0
def has_required_evidence(answers, vector_id):
    return any(get_evidence_answer(answers, k) >= 2 for k in VECTOR_EVIDENCE.get(vector_id, []))
def compute_baseline_evidence(answers):
    keys = ["ev.analytics", "ev.conversion_tracking", "ev.crm_or_leads", "ev.retention", "ev.source_linkage", "ev.time_window"]
    scores = [get_evidence_answer(answers, k) for k in keys]; avg = average(scores)
    multi = get_evidence_answer(answers, "ev.source_linkage") >= 3 and get_evidence_answer(answers, "ev.time_window") >= 3
    if avg == 0: return {"code": "E0", "name": "Absent Evidence"}
    if avg <= 1: return {"code": "E1", "name": "Self-Reported Evidence"}
    if avg <= 2 and not multi: return {"code": "E2", "name": "Observable Evidence"}
    if multi and avg < 3.5: return {"code": "E3", "name": "Multi-Source Evidence"}
    if avg >= 3.5 and get_evidence_answer(answers, "ev.time_window") >= 3: return {"code": "E4", "name": "Validated Evidence"}
    return {"code": "E2", "name": "Observable Evidence"}
def assign_vector_evidence(answers, vector_model, scanner):
    values = [answers.get(q["id"], 0) for q in vector_model["questions"]]
    if all(v == 0 for v in values) or not has_required_evidence(answers, vector_model["vector_id"]):
        return {"code": "E0", "name": "Absent Evidence", "unscorable": True}
    baseline = compute_baseline_evidence(answers)
    if baseline["code"] == "E0": return {"code": "E0", "name": "Absent Evidence", "unscorable": True}
    avg_vector = average([score_from_answer(v, scanner["answer_scale"]) for v in values]) / 100
    if avg_vector <= 0.25 and get_evidence_answer(answers, "ev.analytics") <= 1:
        return {"code": "E1", "name": "Self-Reported Evidence", "unscorable": False}
    return {"code": baseline["code"], "name": baseline["name"], "unscorable": False}
def compute_vector_score(answers, vector_model, scanner):
    dim_scores = {}
    for q in vector_model["questions"]:
        val = answers.get(q["id"])
        if not isinstance(val, int): continue
        dim_scores.setdefault(q["dimension"], []).append(score_from_answer(val, scanner["answer_scale"]))
    total = 0.0
    for d in scanner["dimensions"]:
        scores = dim_scores.get(d["id"], []); total += (average(scores) if scores else 0) * d["weight"]
    return round(total)
def pattern_strength(fm_id, vector_model, answers, scanner):
    relevant = [q for q in vector_model["questions"] if fm_id in (q.get("failure_mode_signals") or [])]
    if not relevant: return 0
    weakness = [100 if not isinstance(answers.get(q["id"]), int) else 100 - score_from_answer(answers[q["id"]], scanner["answer_scale"]) for q in relevant]
    return round(average(weakness))
def assign_failure_modes(answers, vector_model, vector_score, evidence, scanner, tfo_by_id):
    levels = scanner["failure_mode_assignment"]["pattern_strength_levels"]
    ranked = sorted([{"id": tr["id"], "strength": pattern_strength(tr["id"], vector_model, answers, scanner)} for tr in (vector_model.get("failure_mode_triggers") or []) if tr["id"] in tfo_by_id], key=lambda r: r["strength"], reverse=True)
    if evidence["code"] == "E0":
        gap = tfo_by_id.get("tfo.constraint.measurement_gap")
        if gap: return {"primary": gap, "secondary": [tfo_by_id[r["id"]] for r in ranked[:2] if r["id"] in tfo_by_id]}
    def level_for(strength):
        for lvl in levels:
            if lvl["min"] <= strength <= lvl["max"]: return lvl
        return None
    likely = [r for r in ranked if level_for(r["strength"]) and level_for(r["strength"])["assignment"] not in ("not_assigned", "weak_signal")]
    if not likely and vector_score < 70:
        likely = [r for r in ranked if level_for(r["strength"]) and level_for(r["strength"])["assignment"] != "not_assigned"]
    return {"primary": tfo_by_id[likely[0]["id"]] if likely else None, "secondary": [tfo_by_id[r["id"]] for r in likely[1:3] if r["id"] in tfo_by_id]}
def collect_interventions(failure_modes, layer_by_id):
    names, seen = [], set()
    for fm in failure_modes:
        if not fm: continue
        for layer_id in fm.get("intervention_layers") or []:
            if layer_id not in seen:
                seen.add(layer_id); layer = layer_by_id.get(layer_id)
                if layer: names.append(layer)
    return names
def compute_results(answers, scanner, ati_vectors, tfo, layers):
    tfo_by_id = build_tfo_by_id(tfo); layer_by_id = {l["id"]: l for l in layers.get("layers", [])}; vector_meta = build_vector_meta(ati_vectors); thresholds = scanner["diagnostic_thresholds"]
    vector_results = []
    for vm in scanner["vector_question_models"]:
        meta = vector_meta.get(vm["vector_id"], {}); evidence = assign_vector_evidence(answers, vm, scanner); score = None if evidence["unscorable"] else compute_vector_score(answers, vm, scanner)
        diag = None if score is None else diagnostic_for(score, thresholds); fm = assign_failure_modes(answers, vm, score or 0, evidence, scanner, tfo_by_id)
        vector_results.append({"code": meta.get("code", vm["vector_id"]), "score": score, "evidence": evidence, "diagnostic": diag, "failure_modes": fm})
    scorable = [vr for vr in vector_results if not vr["evidence"]["unscorable"] and vr["score"] is not None]
    unscorable = [vr for vr in vector_results if vr["evidence"]["unscorable"]]; partial = len(unscorable) > 0; composite = None
    if not partial and len(scorable) == 4:
        composite_score = round(average([vr["score"] for vr in scorable])); composite = {"score": composite_score, "diagnostic": diagnostic_for(composite_score, thresholds)}
    ranked = sorted(scorable, key=lambda vr: vr["score"]); weakest = ranked[0] if ranked else None; strongest = ranked[-1] if ranked else None
    all_fm = []
    for vr in vector_results:
        if vr["failure_modes"].get("primary"): all_fm.append(vr["failure_modes"]["primary"])
        all_fm.extend(vr["failure_modes"].get("secondary") or [])
    unique_fm, seen_ids = [], set()
    for fm in all_fm:
        if fm and fm["id"] not in seen_ids: seen_ids.add(fm["id"]); unique_fm.append(fm)
    return {"partial": partial, "composite": composite, "scorable": scorable, "unscorable": unscorable, "weakest": weakest, "strongest": strongest, "failure_modes": unique_fm, "interventions": collect_interventions(unique_fm, layer_by_id), "baseline_evidence": compute_baseline_evidence(answers), "vector_results": vector_results}
def all_question_ids(scanner):
    ids = [q["id"] for q in scanner.get("context_questions", [])] + [q["id"] for q in scanner.get("evidence_questions", [])]
    for vm in scanner["vector_question_models"]:
        ids.extend(q["id"] for q in vm["questions"])
    return ids
def build_answers(scanner, evidence=None, vector_values=None, weak_vectors=None):
    answers = {qid: 2 for qid in all_question_ids(scanner)}
    if evidence: answers.update(evidence)
    if vector_values is not None:
        for vm in scanner["vector_question_models"]:
            val = vector_values.get(vm["vector_id"], 4) if isinstance(vector_values, dict) else vector_values
            for q in vm["questions"]: answers[q["id"]] = val
    if weak_vectors:
        for vm in scanner["vector_question_models"]:
            if vm["vector_id"] in weak_vectors:
                for q in vm["questions"]: answers[q["id"]] = 0
    return answers
def main():
    scanner = load_json("scanner-model.json"); ati_vectors = load_json("ati-vectors.json"); tfo = load_json("tfo-failure-modes.json"); layers = load_json("intervention-layers.json"); failures = []
    r1 = compute_results(build_answers(scanner, evidence={"ev.analytics": 4, "ev.conversion_tracking": 4, "ev.crm_or_leads": 4, "ev.retention": 4, "ev.source_linkage": 4, "ev.time_window": 4}, vector_values=4), scanner, ati_vectors, tfo, layers)
    if r1["partial"] or not r1["composite"]: failures.append("Scenario 1: expected full composite profile")
    print("PASS  Scenario 1 Full Scorable Profile")
    r2 = compute_results(build_answers(scanner, evidence={"ev.analytics": 4, "ev.conversion_tracking": 4, "ev.crm_or_leads": 4, "ev.retention": 0, "ev.source_linkage": 4, "ev.time_window": 4}, vector_values=4), scanner, ati_vectors, tfo, layers)
    if not r2["partial"] or r2["composite"]: failures.append("Scenario 2: expected partial profile without composite")
    print("PASS  Scenario 2 Partial Profile")
    r3 = compute_results(build_answers(scanner, evidence={"ev.analytics": 3, "ev.conversion_tracking": 3, "ev.crm_or_leads": 3, "ev.retention": 3, "ev.source_linkage": 3, "ev.time_window": 3}, vector_values=4, weak_vectors={"ati.vector.t2", "ati.vector.t3"}), scanner, ati_vectors, tfo, layers)
    fm_routes = {fm["canonical_route"] for fm in r3["failure_modes"] if fm.get("canonical_route")}
    expected_any = {"/failure-modes/comparison-stall/", "/failure-modes/value-ambiguity/", "/failure-modes/process-friction/", "/failure-modes/trust-deficit/"}
    if not (fm_routes & expected_any): failures.append("Scenario 3: missing expected T2/T3 failure mode routes")
    for route in fm_routes:
        page = ROOT / route.strip("/").replace("/", "\\") / "index.html"
        if not page.exists(): failures.append(f"Scenario 3: missing page for {route}")
    print("PASS  Scenario 3 Weak Transition Diagnosis")
    if failures:
        for f in failures: print(f"FAIL  {f}", file=sys.stderr)
        return 1
    print("=== Scanner scenario tests: 3 passed, 0 failed ==="); return 0
if __name__ == "__main__": sys.exit(main())
'@
}

function Invoke-PreviewScannerScenarios {
  param(
    [string]$Root,
    [string]$PythonExe
  )

  $scriptBody = Get-PreviewScannerScenarioScript
  $tempPy = Join-Path $env:TEMP 'aidatanaly-preview-scanner-scenarios.py'
  [System.IO.File]::WriteAllText($tempPy, $scriptBody, [System.Text.UTF8Encoding]::new($false))
  & $PythonExe $tempPy $Root | Out-Null
  $exitCode = $LASTEXITCODE
  if ($null -eq $exitCode) { $exitCode = 0 }
  return [bool]($exitCode -eq 0)
}

function Invoke-PrivatePreviewChecks {
  param([string]$Root)

  Write-Host ''
  Write-Host '=== Sprint 10 Private Preview Checks ==='

  $pythonExe = Get-PythonExecutable
  if (-not $pythonExe) {
    Write-Host '  FAIL  Python 3 not found (required for local preview server and scanner scenarios)'
    return @{
      Ok = $false
      RoutesOk = $false
      ScannerManualOk = $false
      BlockingIssues = 1
    }
  }

  Write-Host "  INFO  Using Python: $pythonExe"
  $server = Start-PreviewServer -Root $Root -Port 8000 -PythonExe $pythonExe
  $baseUrl = 'http://localhost:8000'

  try {
    Write-Host ''
    Write-Host '--- Manual route review (HTTP) ---'
    $routeResult = Test-PrivatePreviewRoutes -BaseUrl $baseUrl -Root $Root

    Write-Host ''
    Write-Host '--- Scanner scenario tests ---'
    $scenarioOk = Invoke-PreviewScannerScenarios -Root $Root -PythonExe $pythonExe
    if ($scenarioOk) { Write-Host '  GATE  Scanner Manual Tests PASSED' }
    else { Write-Host '  GATE  Scanner Manual Tests FAILED' }

    $blocking = @()
    if (-not $routeResult.Ok) { $blocking += $routeResult.Failures }
    if (-not $scenarioOk) { $blocking += 'scanner scenario validation failed' }

    return @{
      Ok = ($routeResult.Ok -and $scenarioOk)
      RoutesOk = $routeResult.Ok
      ScannerManualOk = $scenarioOk
      BlockingIssues = $blocking.Count
      ServerStarted = $server.Started
    }
  } finally {
    if ($server.Started) { Stop-PreviewServer -ServerInfo $server }
  }
}

Write-Host '=== AIDAtanaly Pre-Release Quality Gate (Sprint 9) ==='
Write-Host '  INFO  Private preview posture only - noindex and Disallow root must remain'
Write-Host ""

$dataOk = Invoke-GovernedStep -Label 'Data' -ScriptName 'validate-data.ps1'
$interfaceOk = Invoke-GovernedStep -Label 'Interface' -ScriptName 'validate-interface.ps1'
$scannerOk = Invoke-GovernedStep -Label 'Scanner' -ScriptName 'validate-scanner.ps1'
$pagesOk1 = Invoke-GovernedStep -Label 'Pages (pre-sitemap)' -ScriptName 'validate-pages.ps1'
$sitemapOk = Invoke-GovernedStep -Label 'Sitemap generation' -ScriptName 'generate-sitemap.ps1'
$pagesOk2 = Invoke-GovernedStep -Label 'Pages (post-sitemap)' -ScriptName 'validate-pages.ps1'

$pagesOk = $pagesOk1 -and $pagesOk2
$metrics = Get-SiteMetrics -Root $root

$indexationOk = $metrics.RobotsDisallowRoot -and
  $metrics.RobotsSitemapInactive -and
  ($metrics.PagesMissingNoindex -eq 0)

$sitemapChecksOk = $sitemapOk -and ($metrics.SitemapUrlCount -eq 41)

$stepResults = @{
  Data      = $dataOk
  Interface = $interfaceOk
  Scanner   = $scannerOk
  Pages     = $pagesOk
  Sitemap   = $sitemapChecksOk
}

$overallOk = ($stepResults.Values | Where-Object { -not $_ }).Count -eq 0 -and $indexationOk

function Format-StepResult([bool]$Ok) { if ($Ok) { 'PASS' } else { 'FAIL' } }

Write-Host ""
Write-Host "=== Quality Gate Report ==="
Write-Host ""
Write-Host ("Quality Gate: {0}" -f (Format-StepResult $overallOk))
Write-Host ("Data: {0}" -f (Format-StepResult $stepResults.Data))
Write-Host ("Interface: {0}" -f (Format-StepResult $stepResults.Interface))
Write-Host ("Scanner: {0}" -f (Format-StepResult $stepResults.Scanner))
Write-Host ("Pages: {0}" -f (Format-StepResult $stepResults.Pages))
Write-Host ('Sitemap: {0}' -f (Format-StepResult $stepResults.Sitemap))
Write-Host "Indexation posture: NON-INDEXED"
Write-Host ("Required Launch Routes: {0}/{1}" -f $metrics.RequiredLaunchRoutes, $metrics.RequiredLaunchTotal)
Write-Host ("Broken Links: {0}" -f $metrics.BrokenLinks)
Write-Host ("Orphan Pages: {0}" -f $metrics.OrphanPages)
Write-Host ""

if (-not $indexationOk) {
  Write-Host '  FAIL  Indexation posture violated (noindex, Disallow root, or inactive sitemap directive required)'
  if (-not $metrics.RobotsDisallowRoot) { Write-Host '        robots.txt must keep Disallow: /' }
  if (-not $metrics.RobotsSitemapInactive) { Write-Host '        robots.txt must not declare an active Sitemap line' }
  if ($metrics.PagesMissingNoindex -gt 0) {
    Write-Host "        $($metrics.PagesMissingNoindex) page(s) missing noindex meta"
  }
}

Write-Host '=== End Quality Gate ==='

$previewOk = $true
$scannerManualOk = $true
$blockingIssues = 0

if ($PrivatePreview) {
  $preview = Invoke-PrivatePreviewChecks -Root $root
  $previewOk = $preview.Ok
  $scannerManualOk = $preview.ScannerManualOk
  $blockingIssues = $preview.BlockingIssues

  Write-Host ''
  Write-Host '=== Private Preview Report ==='
  Write-Host ''
  $privatePreviewPass = $overallOk -and $previewOk
  Write-Host ("Private Preview: {0}" -f (Format-StepResult $privatePreviewPass))
  Write-Host ("Quality Gate: {0}" -f (Format-StepResult $overallOk))
  Write-Host ("Scanner Manual Tests: {0}" -f (Format-StepResult $scannerManualOk))
  Write-Host 'Indexation Posture: NON-INDEXED'
  Write-Host ("Blocking Issues: {0}" -f $blockingIssues)
  Write-Host ''
  Write-Host '=== End Private Preview ==='

  if (-not $privatePreviewPass) { exit 1 }
}

$releasePackageOk = $true
$distOk = $true
$forbiddenDeploymentFiles = 0

if ($ReleasePackage) {
  Write-Host ''
  Write-Host '=== Sprint 11 Release Package Gate (pre-indexation) ==='
  Write-Host '  INFO  Indexation not activated in this gate; noindex and Disallow root preserved'

  $distBuildOk = Invoke-GovernedStep -Label 'Dist build' -ScriptName 'build-dist.ps1'
  $distValidateOk = Invoke-GovernedStep -Label 'Dist validation' -ScriptName 'validate-dist.ps1'
  $distOk = $distBuildOk -and $distValidateOk
  $releasePackageOk = $overallOk -and $distOk

  if (Test-Path (Join-Path $root 'dist')) {
    $forbiddenDeploymentFiles = @(
      Get-ChildItem -Path (Join-Path $root 'dist') -Recurse -File |
        Where-Object { $_.Extension -eq '.md' -or $_.Name -eq '.gitkeep' }
    ).Count
    foreach ($badDir in @('scripts', 'preview', (Join-Path 'governance' 'decisions'))) {
      if (Test-Path (Join-Path $root (Join-Path 'dist' $badDir))) { $forbiddenDeploymentFiles++ }
    }
  } else {
    $forbiddenDeploymentFiles = -1
  }

  Write-Host ''
  Write-Host '=== Release Package Report ==='
  Write-Host ''
  Write-Host ("Release Package: {0}" -f (Format-StepResult $releasePackageOk))
  Write-Host ("Quality Gate: {0}" -f (Format-StepResult $overallOk))
  Write-Host ("Dist Build: {0}" -f (Format-StepResult $distBuildOk))
  Write-Host ("Dist Validation: {0}" -f (Format-StepResult $distValidateOk))
  Write-Host 'Indexation Posture: NON-INDEXED'
  Write-Host ("Forbidden Deployment Files: {0}" -f $(if ($forbiddenDeploymentFiles -lt 0) { 'n/a' } else { $forbiddenDeploymentFiles }))
  Write-Host ''
  Write-Host '  NEXT  After this gate passes, execute Section 7 indexation activation, then final release gate'
  Write-Host '=== End Release Package ==='

  if (-not $releasePackageOk) { exit 1 }
}

if (-not $overallOk) { exit 1 }
exit 0
