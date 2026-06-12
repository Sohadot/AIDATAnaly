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
preview page is noindex and readable without JavaScript, motion tokens
stay within the governed 200–600ms range.

Sprint 12A–12D additions: transition axis responsive grammar (64rem breakpoint),
transition health visual language, Failure Lens stylesheet separation
(`failure-lens.css`), and scanner `Transition Health Map` classes in `main.css`.

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

Sprint 5 TFO checks (when failure mode pages exist): `/transition-failure-ontology/`
and all 22 failure/constraint dossier routes; stable IDs and canonical URLs
match `data/tfo-failure-modes.json`; section 14.3 dossier headings on every
page; parent vector links (all four vectors for Measurement Gap); hub links to
ATI, TFO, Scanner, Evidence Confidence, and Intervention Layers; Measurement
Gap constraint classification and mandatory E0 / Partial Profile statements;
TFO overview ATI/TFO questions and links to all dossier pages; no failure
mode routes outside the JSON registry; no TFO IDs outside the registry;
34/41 route implementation milestone.

## generate-tfo-pages.ps1 (built in Sprint 5)

Generates `/transition-failure-ontology/` and all `/failure-modes/*/` dossier
pages from `data/tfo-failure-modes.json` with AI Instrumentation extracted
from `TFO_ONTOLOGY.md`.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-tfo-pages.ps1
```

Regenerate after JSON or ontology changes; then run `validate-pages.ps1`.

## validate-scanner.ps1 (built in Sprint 6)

Validates `/scanner/` and `assets/js/scanner.js` against `SCANNER_MODEL.md` v1.0
and `PAGE_BLUEPRINTS.md` §16–17.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-scanner.ps1
```

Checks: scanner page and JS exist; blueprint headings and mandatory disclosures;
local `scanner.js` only (no external JS or analytics); fetches all four `/data/*.json`
files; no `evidence_confidence_weight`; Partial Profile and Unscorable logic; TFO IDs
confined to registry; canonical route links in output; separate score and evidence
components; prohibited claim phrases; no dynamic indexable result routes.

Sprint 12D additions: `Transition Health Map` in scanner results; per-vector health
modifiers (`scanner-result-map__vector--*`); Partial Profile gating for Composite ATI;
weakest/strongest movement blocks; primary failure mode with canonical routes; intervention
layers; Evidence Confidence summary kept separate from the map; no Failure Lens in scanner
output; result-map CSS classes in `main.css`.

Sprint 6 page checks in `validate-pages.ps1`: `/scanner/` route, blueprint structure,
Partial Profile documentation, governed script tag, reference links, 35/41 route milestone.

## Sprint 7 trust pages (built in Sprint 7)

Six routes close the Required Launch set: `/methodology/`, `/governance/`, `/sources/`,
`/reports/ati-snapshot/`, `/privacy/`, `/terms/`.

Sprint 7 checks in `validate-pages.ps1`: all six pages exist; methodology claim restraint and
links; governance versioning statement; sources adoption posture; report page without fear/guarantee
upsell; privacy sensitive-data statement; terms no-guarantee statement; trust pages without JS;
broken internal link scan across all implemented pages; **41/41 route milestone**.

After Sprint 7, run all four validators before Sprint 8 (sitemap and full link gate):

```powershell
powershell -ExecutionPolicy Bypass -File scripts/validate-data.ps1
powershell -ExecutionPolicy Bypass -File scripts/validate-interface.ps1
powershell -ExecutionPolicy Bypass -File scripts/validate-scanner.ps1
powershell -ExecutionPolicy Bypass -File scripts/validate-pages.ps1
```

## generate-sitemap.ps1 (built in Sprint 8)

Generates `sitemap.xml` at the repository root from the 41 Required Launch routes
in `ROUTE_MAP.md` Section 13. A route is included only when its `index.html` exists.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/generate-sitemap.ps1
powershell -ExecutionPolicy Bypass -File scripts/validate-pages.ps1
```

Excludes `preview/`, `data/`, `assets/`, `scripts/`, `governance/decisions/`, and any
route outside the launch set. Fails if any Required Launch route is missing its page.

## Sprint 8 — internal linking and sitemap (built in Sprint 8)

`robots.txt` remains `Disallow: /` pre-launch. The active `Sitemap:` directive is deferred
to `PUBLIC_RELEASE_PLAN.md` (comment-only reference in `robots.txt`).

Sprint 8 checks in `validate-pages.ps1`:

- `sitemap.xml` exists with exactly 41 URLs matching implemented routes
- no preview, data, assets, scripts, or decision paths in sitemap
- `robots.txt` non-indexed posture preserved
- no broken internal links, orphan pages, or prohibited hrefs (`/preview/`,
  `/governance/decisions/`, `/claims-policy/`, `/versioning/`)
- all canonical URLs and `noindex` meta tags valid
- minimum internal reference graph (up link to `/`, hub linking)

## quality-gate.ps1 (built in Sprint 9)

Single governed pre-release gate for **private preview readiness** — not public
indexed release. Runs every validator in order, regenerates `sitemap.xml`, and
re-validates pages after sitemap generation.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/quality-gate.ps1
```

Execution order:

1. `validate-data.ps1`
2. `validate-interface.ps1`
3. `validate-scanner.ps1`
4. `validate-pages.ps1`
5. `generate-sitemap.ps1`
6. `validate-pages.ps1` (post-sitemap confirmation)

The gate confirms (via the validators above):

- JSON parses; D1–D7 and T1–T4 weights = 100%; TFO IDs complete; 10 intervention layers only
- Scanner uses the `/data/` layer; Partial Profile and Unscorable rules enforced
- 41/41 Required Launch routes implemented
- `sitemap.xml` = exactly 41 URLs; no preview/data/assets/scripts/decisions in sitemap
- No broken internal links; no orphan pages; canonical URLs valid
- One `<h1>`, unique title/meta per page; no unsupported claim language
- No external JS; no WebGL/3D/canvas
- **Indexation posture remains NON-INDEXED**: all pages keep `noindex`; `robots.txt`
  keeps `Disallow: /`; no active `Sitemap:` directive

Sprint 9 does **not** remove `noindex`, enable `Sitemap:` in `robots.txt`, change
`Disallow: /`, add analytics, add routes, or add buyer-facing pages. Public indexing
remains governed by `PUBLIC_RELEASE_PLAN.md` (Sprint 10+).

Example passing report:

```text
Quality Gate: PASS
Data: PASS
Interface: PASS
Scanner: PASS
Pages: PASS
Sitemap: PASS
Indexation posture: NON-INDEXED
Required Launch Routes: 41/41
Broken Links: 0
Orphan Pages: 0
```

Exit code is non-zero on any failure; failures block private preview promotion and
public indexed release.

## Sprint 10 — private preview (built in Sprint 10)

Sprint 10 validates the **full system experience** before any public release decision.
It does not remove `noindex`, change `robots.txt`, activate `Sitemap:`, or add analytics.

Documented in: `PRIVATE_PREVIEW_REPORT.md` (Status: Draft Review).

Run the full private preview gate:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/quality-gate.ps1 -PrivatePreview
```

Manual review server (from repository root):

```powershell
python3 -m http.server 8000
```

Then open `http://localhost:8000/` and `http://localhost:8000/scanner/`. Serve over HTTP so
Scanner v1 can fetch `/data/*.json`.

The `-PrivatePreview` switch adds:

- HTTP checks on 13 governed review routes (+ `/data/scanner-model.json`)
- Three Scanner v1 scenario validations (Full Scorable, Partial Profile, Weak T2/T3 diagnosis)
- Final preview report:

```text
Private Preview: PASS
Quality Gate: PASS
Scanner Manual Tests: PASS
Indexation Posture: NON-INDEXED
Blocking Issues: 0
```

After Sprint 10, the next phase is `PUBLIC_RELEASE_PLAN.md` (indexed release approval), not
automatic removal of `noindex`.

## Sprint 11 — release package (built in Sprint 11, phase 1)

PUB-REL-001 ratifies `dist/` as the governed deployment package. Sprint 11 phase 1 builds and
validates `dist/` **without** indexation activation.

Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/quality-gate.ps1 -ReleasePackage
```

Or manually:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/build-dist.ps1
powershell -ExecutionPolicy Bypass -File scripts/validate-dist.ps1
```

`build-dist.ps1`:

- regenerates `sitemap.xml`,
- writes `dist/` with 41 routes, `assets/`, `data/`, `sitemap.xml`, `robots.txt`,
- copies `/governance/index.html` only (excludes `governance/decisions/`),
- excludes `.gitkeep`, `*.md`, `scripts/`, `preview/`, and repository artifacts.

`validate-dist.ps1` confirms forbidden deployment files = 0, 41/41 routes in `dist/`, pre-activation
`noindex` and `Disallow: /` preserved in the package copy.

**Not performed in phase 1:** removing `noindex`, robots Allow, active `Sitemap:` — these run only
after the release package gate passes, per `PUBLIC_RELEASE_PLAN.md` Section 7.
