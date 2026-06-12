# scripts/

Validation and generation scripts supporting the governed implementation.

Governed by: `IMPLEMENTATION_PLAN.md` (IMPL-PLAN-001).

## Sitemap generation approach (established in Sprint 0)

- `sitemap.xml` is generated, not hand-maintained.
- The source of truth for inclusion is the Required Launch route list in `ROUTE_MAP.md` Section 13 (41 routes).
- Generation runs in Sprint 8 and must verify each route directory contains an implemented `index.html` before listing it.
- Deferred and Early Expansion routes are excluded until implemented and governed.
- The sitemap must never list a route that does not exist or a non-public artifact.

## validate-data.ps1 (built in Sprint 1)

Validates the `/data/*.json` registry against the ratified governance documents.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-data.ps1
```

Checks (25 total): JSON parse, D1–D7 weights = 100%, T1–T4 weights = 100%,
21 failure modes + measurement_gap constraint, exact `tfo.*` ID match against
`TFO_ONTOLOGY.md`, canonical routes against the 41-route launch set in
`ROUTE_MAP.md`, exactly 10 intervention layers (Channel Intervention and
Measurement Governance as contextual mappings only), Partial Profile rule
presence in `ati-standard.json` and `scanner-model.json`, no
`evidence_confidence_weight` anywhere, Evidence Confidence flagged as
non-score-component, diagnostic thresholds consistency, and full failure-mode
coverage across T1–T4.

Implementation note: the validator is PowerShell (`.ps1`) rather than Node
(`.mjs`) because Node.js is not installed on the build machine. A Node port
can be added when a CI runtime is chosen; the check list is the contract, not
the language.

Exit code is non-zero on any failure; failures block release.

## validate-interface.ps1 (built in Sprint 2)

Validates the interface foundation against `INTERFACE_GOVERNANCE.md` v1.0.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-interface.ps1
```

Checks (17 total): `assets/css/main.css` exists, scanner.js placeholder exists
with no premature logic, no external JS/CSS/font/CDN dependencies, no
WebGL/3D/canvas, no animation libraries, `prefers-reduced-motion` support,
all 20 governed component classes defined, Evidence Confidence styling never
uses diagnostic scale variables, diagnostic colors confined to diagnostic
surfaces, Unscorable State is non-numeric, Transition Axis is responsive,
preview page is noindex and readable without JavaScript, and motion tokens
stay within the governed 200–600ms range.

## validate-pages.ps1 (built in Sprint 3)

Validates every implemented public route page against `PAGE_BLUEPRINTS.md` §27
(quality gate) and `ROUTE_MAP.md` §15/§18.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-pages.ps1
```

Auto-discovers implemented routes (an `index.html` under a Required Launch
route) and checks per page: exactly one `<h1>`, unique title, unique meta
description, canonical URL matching the route, pre-launch `noindex`, the
governed stylesheet, zero `<script>` tags, all internal links inside the
launch route set, and prohibited claim language (unqualified "industry
standard", guarantee phrasing, revenue promises). It also enforces
blueprint-required internal links per route and the page-specific governed
statements (Evidence Confidence separation statement, the ten intervention
layers, the homepage primary message).

Note: `preview/` is internal, carries `noindex, nofollow`, is not a
`ROUTE_MAP.md` route, and must never be included in `sitemap.xml` (sitemap
generation reads only the 41-route launch list).

Sprint 4 vector checks (when vector pages exist): all four vector routes
present; hub links to ATI, TFO, Scanner, Evidence Confidence, and
Intervention Layers; failure-mode links restricted to the vector's own TFO
entries; T2 sub-signals sentence; T4 continuity sentence.

## Full site validation (built in Sprint 9)

Planned checks, per IMPLEMENTATION_PLAN.md Sprint 9:

- JSON parse and schema checks for `/data/*.json`.
- D1–D7 weight total = 100% and vector weight total = 100%.
- TFO ID coverage against `TFO_ONTOLOGY.md` (21 failure modes + 1 constraint).
- Route existence and canonical URL checks against `ROUTE_MAP.md`.
- Internal link resolution (no broken links, no orphans, no deferred routes linked as live).
- One `<h1>`, unique title, unique meta description per page.
- Prohibited claim phrase scan (no guarantees, no industry-standard claims).
- No `evidence_confidence_weight` anywhere.
- E0 / Partial Profile rule compliance in scanner outputs.
- Sitemap route count check (= 41 at launch).
- No WebGL/3D and no external JS dependencies unless governed.

Failures block public indexed release.
