# scripts/

Validation and generation scripts supporting the governed implementation.

Governed by: `IMPLEMENTATION_PLAN.md` (IMPL-PLAN-001).

## Sitemap generation approach (established in Sprint 0)

- `sitemap.xml` is generated, not hand-maintained.
- The source of truth for inclusion is the Required Launch route list in `ROUTE_MAP.md` Section 13 (41 routes).
- Generation runs in Sprint 8 and must verify each route directory contains an implemented `index.html` before listing it.
- Deferred and Early Expansion routes are excluded until implemented and governed.
- The sitemap must never list a route that does not exist or a non-public artifact.

## Validation scripts (built in Sprint 9)

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
