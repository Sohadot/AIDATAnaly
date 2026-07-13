# DECISION_AGENT_READABILITY_LAYER_1_0_RATIFICATION.md

## AIDATAnaly.com — Agent-Readability Layer Ratification

**Document Class:** Governance Decision Log
**Asset:** AIDATAnaly.com
**Applies to:** all 41 governed launch routes, `scripts/validate-pages.ps1`, `scripts/build-dist.ps1`, `scripts/validate-dist.ps1`, `llms.txt`, `scripts/inject-jsonld.py`
**Decision ID:** AGENT-READ-001
**Decision Type:** Capability Ratification + Validator Amendment
**Status:** Ratified
**Ratified by:** Sohadot — System Operator
**Date:** 2026-07-13
**Fulfils:** `ASSET_THESIS.md` §19 (Agent-Readability Commitment); closes gap G4 of `INEVITABILITY_AUDIT.md`

---

## 1. Decision Summary

AIDATAnaly activates its **agent-readability layer**: every governed launch route now carries exactly one JSON-LD structured-data block, a root `llms.txt` guide is published, and the governed `/data/` registries are formally recognized as public machine-readable endpoints.

The asset is now legible to AI agents through three governed surfaces:

1. **JSON-LD structured data** (schema.org) on all 41 routes,
2. **`llms.txt`** at the site root,
3. **`/data/*.json`** governed registries (already deployed since Sprint 11).

---

## 2. Ratified Rules

### 2.1 JSON-LD policy

- Every governed launch route page carries **exactly one** `<script type="application/ld+json">` block.
- JSON-LD is **inert structured data, not executable JavaScript**. The no-JS readability rule (`PAGE_BLUEPRINTS.md`) remains in force for executable scripts; pages must remain fully readable with the JSON-LD block removed.
- All entity content is sourced from the governed registries (`/data/*.json`) and the governed vocabulary (`ASSET_THESIS.md` §7). **No claim may appear in structured data that does not already appear in governed content.**
- Only the `definition` field of registry entries may be embedded. Diagnostic fields (symptoms, detection signals, scoring impact) stay out of structured data.
- Schema types are restricted to: `WebSite`, `WebPage`, `Organization`, `DefinedTermSet`, `DefinedTerm`, `WebApplication`. Rating, review, offer, and aggregate schemas are prohibited until real usage evidence exists.
- The `@id` graph anchors: `/#website`, `/#organization`, `/#vocabulary`, `/transition-failure-ontology/#tfo`.

### 2.2 Type assignment by route class

| Route class | Structured entity |
|-------------|-------------------|
| `/` | `Organization` + `WebSite` + `DefinedTermSet` (governed vocabulary) |
| Core term hubs | `DefinedTerm` in the governed vocabulary set |
| `/vectors/*` | `DefinedTerm` with `termCode` T1–T4 and stable `identifier` |
| `/transition-failure-ontology/` | `DefinedTermSet` enumerating all TFO entries |
| `/failure-modes/*` | `DefinedTerm` with stable ID, governed definition, TFO set membership |
| `/intervention-layers/` | `DefinedTermSet` of governed intervention classes |
| `/scanner/` | `WebApplication` (free, browser-based) |
| Trust routes | `WebPage` only |

### 2.3 Validator amendment

`scripts/validate-pages.ps1` is amended:

- **New universal check:** every page must carry exactly one JSON-LD block that parses as valid JSON and declares the `https://schema.org` context.
- The no-JS check now strips the JSON-LD block before testing; the scanner-page exception (local `scanner.js` only) is unchanged; all other executable scripts remain prohibited on all routes.

### 2.4 llms.txt

- `llms.txt` lives at the repository root and is copied into `dist/` by `scripts/build-dist.ps1`.
- It is a **required deployment artifact** (`scripts/validate-dist.ps1`).
- Content is limited to governed definitions, canonical URLs, registry endpoints, and citation guidance. Claims restraint applies in full (introduce, never claim adoption).
- `llms.txt` is **not** added to `ROUTE_MAP.md` (it is a root file like `robots.txt`, not a route) and **not** added to `sitemap.xml`.

### 2.5 Regeneration tooling

- `scripts/inject-jsonld.py` is the sole authorized generator of JSON-LD blocks. It is idempotent: re-running replaces existing blocks, never duplicates.
- It must be re-run whenever a governed registry, page title, meta description, or canonical URL changes.
- Manual editing of JSON-LD blocks is prohibited.

---

## 3. What This Decision Does Not Change

- ROUTE_MAP (41 routes), sitemap (41 URLs), robots policy — untouched.
- ATI scoring, TFO ontology, scanner model — untouched.
- Indexation posture — unchanged (active).
- No new public HTML routes; no API endpoints beyond the existing `/data/` registries.

---

## 4. Inevitability Audit Linkage

This decision closes **G4** (agent-readability partial) of `INEVITABILITY_AUDIT.md` and directly serves criterion **C2** (agent resolution). Evidence of agent resolution remains to be observed and recorded; the capability is now in place.

---

*Ratified as AGENT-READ-001 — Agent-Readability Layer.*
