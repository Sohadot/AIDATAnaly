# AIDAtanaly.com — Implementation Ledger

**Document Class:** Implementation / Build Ledger  
**Asset:** AIDAtanaly.com  
**Governed by:** `IMPLEMENTATION_PLAN.md` (IMPL-PLAN-001)  
**Status:** Active  
**Date started:** 2026-06-12  
**Purpose:** Record what was built, when, and whether it passed — not why governing rules were ratified (see `governance/decisions/`).

---

## Ledger Rules

- One entry per implementation sprint defined in `IMPLEMENTATION_PLAN.md`.
- Sprint completion does **not** require a separate decision log entry.
- Governing changes (scoring, routes, indexation, deployment exposure) require decision logs.
- Indexation remains **NON-INDEXED** until `PUBLIC_RELEASE_PLAN.md` is ratified and Sprint 11 completes.

---

## Sprint 0 — Repository Baseline

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `96a8545` |
| **Date** | 2026-06-12 |
| **Summary** | Repository structure aligned to governed route architecture: 41 route directories, `assets/`, `data/`, `scripts/`, initial `robots.txt` (`Disallow: /`), sitemap generation approach documented in `scripts/README.md`. |
| **Validators** | Structure review against `ROUTE_MAP.md`; `IMPLEMENTATION_PLAN.md` ratified (IMPL-PLAN-001). |
| **Notes** | No public pages implemented yet. Non-indexed posture established. |

---

## Sprint 1 — Data Registry Layer

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `4a41785` |
| **Date** | 2026-06-12 |
| **Summary** | Five governed JSON registries under `/data/`; `scripts/validate-data.ps1` (25 checks). |
| **Validators** | `validate-data.ps1` → 25/25 |
| **Notes** | D1–D7 and T1–T4 weights = 100%; TFO IDs match ontology; Partial Profile rule present; no `evidence_confidence_weight`. |

---

## Sprint 2 — Interface Foundation

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `edfec39` |
| **Date** | 2026-06-12 |
| **Summary** | `assets/css/main.css` (Flow Made Visible), component system, `preview/` page (noindex, no JS), `scripts/validate-interface.ps1`. |
| **Validators** | `validate-interface.ps1` → 17/17 |
| **Notes** | No external JS/CSS; no WebGL/3D/canvas; Evidence Confidence styling separate from diagnostic scale. |

---

## Sprint 3 — Core Reference Routes

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `367e9ed` |
| **Date** | 2026-06-12 |
| **Summary** | Core hub routes: `/`, category, intelligence, measurement grammar, ATI, evidence confidence, intervention layers; `scripts/validate-pages.ps1` introduced. |
| **Validators** | `validate-data.ps1`, `validate-interface.ps1`, `validate-pages.ps1` |
| **Notes** | Blueprint-required links and universal page checks enforced per route. |

---

## Sprint 4 — Vector Routes

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `1144c26` |
| **Date** | 2026-06-12 |
| **Summary** | All four vector pages under `/vectors/` with TFO sub-signal links and hub cross-links. |
| **Validators** | `validate-pages.ps1` (vector-specific checks) |
| **Notes** | T2 sub-signals and T4 continuity sentences governed. |

---

## Sprint 5 — TFO Overview and Failure Mode Pages

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `92cf155` |
| **Date** | 2026-06-12 |
| **Summary** | `/transition-failure-ontology/` and 22 failure/constraint dossiers; `scripts/generate-tfo-pages.ps1`; 34/41 route milestone. |
| **Validators** | `validate-pages.ps1` (TFO dossier checks) |
| **Notes** | Stable IDs and canonical URLs match `data/tfo-failure-modes.json`; Measurement Gap E0 statements. |

---

## Sprint 6 — Scanner Implementation

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `b0f187d` |
| **Date** | 2026-06-12 |
| **Summary** | `/scanner/` page and `assets/js/scanner.js` (Transition Scanner v1); `scripts/validate-scanner.ps1`; 35/41 routes. |
| **Validators** | `validate-scanner.ps1` → 23/23 |
| **Notes** | Scoring from `/data/*.json` only; Partial Profile and Unscorable enforced; no dynamic indexable result routes. |

---

## Sprint 7 — Reports and Trust Pages

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `41dc292` |
| **Date** | 2026-06-12 |
| **Summary** | Six trust routes close Required Launch set: methodology, governance, sources, report snapshot, privacy, terms. **41/41 routes implemented.** |
| **Validators** | `validate-pages.ps1` (Sprint 7 trust checks; broken link scan) |
| **Notes** | Trust pages without JS; governance page does not expose decision log paths as public links. |

---

## Sprint 8 — Internal Linking and Sitemap

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `5a2cfb7` |
| **Date** | 2026-06-12 |
| **Summary** | `scripts/generate-sitemap.ps1`, `sitemap.xml` (41 URLs), extended link graph validation, `robots.txt` deferred sitemap comment. |
| **Validators** | `validate-pages.ps1` → 308/308 (Sprint 8 checks) |
| **Notes** | No orphans; no broken links; sitemap excludes preview/data/assets/scripts/decisions; `Disallow: /` preserved. |

---

## Sprint 9 — Quality Gate Automation

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `37cc79b` |
| **Date** | 2026-06-12 |
| **Summary** | `scripts/quality-gate.ps1` — single orchestrated pre-release gate (validators + sitemap + post-sitemap re-validation). |
| **Validators** | Full gate: Data 25/25, Interface 17/17, Scanner 23/23, Pages 308/308, Sitemap 41 URLs |
| **Notes** | Confirms NON-INDEXED posture; does not remove `noindex` or activate robots sitemap. |

---

## Sprint 10 — Private Preview

| Field | Value |
|-------|-------|
| **Status** | PASS |
| **Commit** | `5c31254` |
| **Date** | 2026-06-12 |
| **Summary** | `PRIVATE_PREVIEW_REPORT.md`; `quality-gate.ps1 -PrivatePreview` (HTTP route review + three scanner scenarios). |
| **Validators** | `quality-gate.ps1 -PrivatePreview` → Private Preview PASS, Blocking Issues 0 |
| **Notes** | Site ready for private preview over local HTTP; not ready for public indexation. See `PRIVATE_PREVIEW_REPORT.md`. |

---

## Sprint 11 — Public Indexed Reference Release (Phase 2)

| Field | Value |
|-------|-------|
| **Status** | Phase 2 ACTIVATED (live domain verification pending) |
| **Commit** | `f2afbc4` (activation), report follows |
| **Date** | 2026-06-12 |
| **Summary** | Indexation activated on 41 routes; robots Allow + Sitemap; final gate PASS; `dist/` deployed to `gh-pages`. |
| **Validators** | `quality-gate.ps1 -IndexedRelease` — all checks PASS, Public Noindex 0 |
| **Notes** | `PUBLIC_RELEASE_REPORT.md` records deployment; custom domain/Pages propagation pending operator verification. |

---

## Current Build State

| Metric | Value |
|--------|-------|
| Required Launch Routes | 41/41 |
| Quality Gate | PASS |
| Private Preview | PASS |
| Release Package | PASS |
| Indexation Posture | **ACTIVE** |
| Public Noindex | 0 |
| Sitemap URLs | 41 |
| Forbidden Deployment Files | 0 |
| Latest activation commit | `f2afbc4` |
| gh-pages deploy | Retired (PUB-REL-002) |
| GitHub Actions Pages | `.github/workflows/pages.yml` on `main` |
| Live URL verification | Pending DNS/Pages / Actions cutover |

---

## Sprint 12G — Main-Only Deployment Correction

| Field | Value |
|-------|-------|
| **Status** | Complete (operator: switch Pages source to GitHub Actions) |
| **Decision** | PUB-REL-002 — `DECISION_MAIN_ONLY_DEPLOYMENT_POLICY.md` |
| **Summary** | Retire `gh-pages` branch deploy; `main` + GitHub Actions artifact from `dist/` only. |
| **Workflow** | `.github/workflows/pages.yml` |
| **Scripts** | `validate-deploy.ps1`; `deploy-dist.ps1` → local preflight only |

---

## Related Documents

| Document | Role |
|----------|------|
| `governance/decisions/` | Governing ratification decisions |
| `PRIVATE_PREVIEW_REPORT.md` | Private preview validation report |
| `PUBLIC_RELEASE_PLAN.md` | Indexed release activation plan (PUB-REL-001 ratified) |
| `PUBLIC_RELEASE_REPORT.md` | Post-release record (Phase 2 activation) |

---

*Ledger maintained as implementation record. Update after each sprint commit and gate run.*
