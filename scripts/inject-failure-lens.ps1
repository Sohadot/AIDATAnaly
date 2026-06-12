# inject-failure-lens.ps1
# Sprint 12C — batch helper to wire Failure Lens into governed pages.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

$vectorMeta = [ordered]@{
  t1 = @{ long = 'T1 Signal Conversion'; name = 'Signal Conversion' }
  t2 = @{ long = 'T2 Intent Formation'; name = 'Intent Formation' }
  t3 = @{ long = 'T3 Conversion Friction'; name = 'Conversion Friction' }
  t4 = @{ long = 'T4 Retention Extension'; name = 'Retention Extension' }
}

function Get-VectorLi {
  param([string]$Id, [string]$Focus, [string]$CalloutLabel, [switch]$Constraint)

  $short = $Id.ToUpper()
  $label = if ($Id -eq $Focus -and -not $Constraint) { $vectorMeta[$Id].long } else { $short }
  $classes = 'transition-axis__vector transition-axis__vector--reference'
  if ($Id -eq $Focus -and -not $Constraint) { $classes += ' failure-lens__vector--focus' }

  $callout = ''
  if ($Id -eq $Focus -and -not $Constraint) {
    $callout = @"

          <p class="failure-lens__callout">
            <span class="failure-lens__marker" aria-hidden="true">&#8593;</span>
            <span class="failure-lens__label">$CalloutLabel</span>
          </p>
"@
  }

  return @"
        <li class="$classes">
          <span class="transition-axis__vector-label">$label</span>$callout
        </li>
"@
}

function Get-FailureLensHtml {
  param(
    [string]$Focus,
    [string]$CalloutLabel,
    [string]$Kicker,
    [string]$AriaLabel,
    [string]$AltText,
    [switch]$Constraint
  )

  $asideClass = if ($Constraint) { 'failure-lens failure-lens--constraint' } else { 'failure-lens' }
  $constraintCallout = ''
  if ($Constraint) {
    $constraintCallout = @"

      <p class="failure-lens__callout">
        <span class="failure-lens__label">$CalloutLabel</span>
        <span class="failure-lens__note">Limits confidence across all measured transitions. Not a normal failure mode.</span>
      </p>
"@
  }

  return @"
      <aside class="$asideClass" aria-label="$AriaLabel">
        <p class="failure-lens__kicker">$Kicker</p>
        <ol class="failure-lens__axis transition-axis">
        <li class="transition-axis__state">Attention</li>
$(Get-VectorLi 't1' $Focus $CalloutLabel -Constraint:$Constraint)
        <li class="transition-axis__state">Interest</li>
$(Get-VectorLi 't2' $Focus $CalloutLabel -Constraint:$Constraint)
        <li class="transition-axis__state">Desire</li>
$(Get-VectorLi 't3' $Focus $CalloutLabel -Constraint:$Constraint)
        <li class="transition-axis__state">Action</li>
$(Get-VectorLi 't4' $Focus $CalloutLabel -Constraint:$Constraint)
        <li class="transition-axis__state">Loyalty</li>
        </ol>$constraintCallout
        <p class="utility-visually-hidden">$AltText</p>
      </aside>
"@
}

function Add-FailureLensStylesheet([string]$Content, [string]$LensHref) {
  if ($Content -match 'failure-lens\.css') { return $Content }
  return $Content -replace '<link rel="stylesheet" href="/assets/css/main.css">', "<link rel=`"stylesheet`" href=`"/assets/css/main.css`">`n  <link rel=`"stylesheet`" href=`"$LensHref`">"
}

$vectorPages = @{
  'vectors/attention-to-interest/index.html' = 't1'
  'vectors/interest-to-desire/index.html' = 't2'
  'vectors/desire-to-action/index.html' = 't3'
  'vectors/action-to-loyalty/index.html' = 't4'
}

foreach ($rel in $vectorPages.Keys) {
  $path = Join-Path $root $rel
  $focus = $vectorPages[$rel]
  $meta = $vectorMeta[$focus]
  $html = Get-FailureLensHtml -Focus $focus -CalloutLabel $meta.name -Kicker 'Where movement is measured' `
    -AriaLabel 'Measured transition on the AIDA axis' `
    -AltText "This page measures $($meta.long), the transition highlighted on the axis."
  $content = Get-Content -Raw -Encoding UTF8 -Path $path
  $content = Add-FailureLensStylesheet $content '/assets/css/failure-lens.css'
  $pattern = '(?s)<ol class="transition-axis" aria-label="[^"]*">.*?</ol>\s*<p class="utility-visually-hidden">[^<]*</p>'
  if ($content -notmatch $pattern) { throw "Vector axis block not found in $rel" }
  $content = [regex]::Replace($content, $pattern, $html.TrimEnd(), 1)
  Set-Content -Path $path -Value $content -Encoding UTF8 -NoNewline
  Write-Host "Updated $rel"
}

$tfo = Get-Content -Raw -Encoding UTF8 (Join-Path $root 'data/tfo-failure-modes.json') | ConvertFrom-Json
$entries = @($tfo.failure_modes) + @($tfo.diagnostic_constraints)

foreach ($entry in $entries) {
  $slug = ($entry.canonical_route -replace '^/failure-modes/|/$', '')
  $path = Join-Path $root "failure-modes/$slug/index.html"
  if (-not (Test-Path $path)) { throw "Missing failure mode page: $path" }

  $isConstraint = $entry.id -like 'tfo.constraint.*'
  $focus = if ($isConstraint) { 't1' } else { ($entry.primary_vector -replace 'ati.vector.', '') }
  $kicker = if ($isConstraint) { 'Diagnostic constraint scope' } else { 'Where this failure sits' }
  $aria = if ($isConstraint) { 'Measurement Gap scope on the transition axis' } else { 'Failure position on the transition axis' }
  $alt = if ($isConstraint) {
    "$($entry.name) is a diagnostic constraint that limits evidence confidence across transitions."
  } else {
    "$($entry.name) blocks movement on $($vectorMeta[$focus].long)."
  }

  $html = Get-FailureLensHtml -Focus $focus -CalloutLabel $entry.name -Kicker $kicker -AriaLabel $aria -AltText $alt -Constraint:$isConstraint
  $content = Get-Content -Raw -Encoding UTF8 -Path $path
  $content = Add-FailureLensStylesheet $content '/assets/css/failure-lens.css'
  if ($content -match 'class="failure-lens"') {
    Write-Host "Skipped failure-modes/$slug (already present)"
    continue
  }
  $content = $content -replace '(</article>\s*\r?\n\s*\r?\n)(      <section class="layout-section">\s*\r?\n        <h2>Definition</h2>)', "`$1$html`n`n`$2"
  Set-Content -Path $path -Value $content -Encoding UTF8 -NoNewline
  Write-Host "Updated failure-modes/$slug"
}

Write-Host 'Done.'
