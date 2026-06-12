# AIDAtanaly.com — Public Indexed Reference Release Plan

**Document Class:** Public Release Plan  
**Layer:** 9 — Public Exposure and Indexation Layer  
**Asset:** AIDAtanaly.com  
**Governed by:** `FOUNDATION_DOCTRINE.md`, `ASSET_THESIS.md`, `ATI_STANDARD.md`, `TFO_ONTOLOGY.md`, `ROUTE_MAP.md`, `INTERFACE_GOVERNANCE.md`, `SCANNER_MODEL.md`, `PAGE_BLUEPRINTS.md`, and `IMPLEMENTATION_PLAN.md`  
**Status:** Draft for Ratification  
**Version:** 1.0  
**Date:** 2026-06-12  
**Prepared for:** Sohadot — System Operator

---

## 1. Purpose of This Plan

This document defines the controlled public release plan for the first indexed reference release of AIDAtanaly.com.

The purpose is to prevent accidental indexation, incomplete exposure, broken public release, uncontrolled repository file exposure, premature sitemap activation, and unsupported launch claims.

AIDAtanaly may be publicly indexed only after:

- all 41 Required Launch routes exist,
- the quality gate passes,
- the private preview passes,
- sitemap governance is complete,
- robots policy is intentionally changed,
- page-level `noindex` is intentionally removed,
- and release exposure boundaries are confirmed.

The governing thesis remains:

> Stages are states. Value lives in transitions.

---

## 2. Release Type

This plan governs the first public indexed reference release.

**Release type:** First Public Indexed Reference Release

This is **not**:

- a private preview,
- a staging release,
- a soft launch with `noindex`,
- a buyer-facing sale page,
- or an experimental partial release.

This release exposes AIDAtanaly as a governed reference and diagnostic system.

---

## 3. Release Preconditions

Public release may proceed only if the following are true:

```text
Quality Gate: PASS
Private Preview: PASS
Required Launch Routes: 41/41
Broken Links: 0
Orphan Pages: 0
Sitemap URLs: 41
Scanner Manual Tests: PASS
Indexation Posture Before Activation: NON-INDEXED
Blocking Issues: 0
```

The following files must exist and pass validation:

- `scripts/quality-gate.ps1`
- `scripts/generate-sitemap.ps1`
- `scripts/validate-data.ps1`
- `scripts/validate-interface.ps1`
- `scripts/validate-scanner.ps1`
- `scripts/validate-pages.ps1`
- `PRIVATE_PREVIEW_REPORT.md`
- `sitemap.xml`
- `robots.txt`

**Current state (pre-ratification):** Private preview and quality gate pass. Indexation remains **NON-INDEXED** until this plan is ratified and Sprint 11 activation steps complete.

---

## 4. Required Launch Route Set

The public indexed release must include exactly the 41 Required Launch routes defined in `ROUTE_MAP.md`.

No incomplete route set may be released as the first public indexed reference release.

The sitemap must contain only the 41 public HTML routes.

The sitemap must **not** include:

- `/preview/`
- `/data/` as sitemap entries (data files remain served for scanner operation but are not indexable routes)
- `/assets/`
- `/scripts/`
- `/governance/decisions/`
- root Markdown governance files,
- validation scripts,
- repository-only files,
- or routes outside `ROUTE_MAP.md`.

---

## 5. Deployment Exposure Policy

This release adopts the following exposure policy:

> The public website deployment package must expose only public website artifacts, not repository governance artifacts.

**Public website artifacts include:**

- 41 public route directories,
- `/assets/`,
- `/data/` files required by scanner operation,
- `sitemap.xml`,
- `robots.txt`,
- and any required static public assets.

**Repository artifacts must not be deployed as public website files.**

Repository-only artifacts include:

- root Markdown governance documents,
- `governance/decisions/`,
- `scripts/`,
- `preview/`,
- private reports (`PRIVATE_PREVIEW_REPORT.md`, `IMPLEMENTATION_LEDGER.md`, this plan until intentionally published),
- validation tooling,
- `.gitkeep` files,
- and implementation-only notes.

The public `/governance/` page remains the public trust surface.

The repository decision logs may remain available through the repository if the repository itself is public, but they must **not** be accidentally exposed as website routes.

**No accidental exposure policy is permitted.**

---

## 6. Deployment Package Rule

The release should use a controlled deployment package.

**Recommended package directory:** `dist/`

The deployment package should include only:

```text
dist/
  index.html
  aida-transition-analytics/
  transition-intelligence/
  measurement-grammar/
  aida-transition-index/
  evidence-confidence/
  intervention-layers/
  vectors/
  transition-failure-ontology/
  failure-modes/
  scanner/
  reports/
  methodology/
  governance/
  sources/
  privacy/
  terms/
  assets/
  data/
  sitemap.xml
  robots.txt
```

The deployment package must exclude:

- `*.md`
- `scripts/`
- `preview/`
- `governance/decisions/`
- `.git/`
- `.github/` unless required by hosting workflow

If GitHub Pages is used, deployment should prefer a controlled publish branch or generated static package rather than exposing the repository root as the website root.

---

## 7. Indexation Activation Steps

Indexation activation must be deliberate and auditable.

The release activation steps are:

1. Run full quality gate.
2. Generate final sitemap.
3. Confirm 41 sitemap URLs.
4. Remove page-level `noindex` from the 41 public routes.
5. Keep non-public routes excluded.
6. Update `robots.txt` from non-indexed mode to indexed mode.
7. Activate `Sitemap:` in `robots.txt`.
8. Re-run full quality gate (release-specific gate).
9. Build deployment package.
10. Verify deployment package contains only public artifacts.
11. Deploy public package.
12. Run post-deploy URL checks.
13. Record final release result in `PUBLIC_RELEASE_REPORT.md`.

**No step in this sequence may run before this plan is ratified.**

---

## 8. Robots Policy

**Before release**, robots policy is:

```text
User-agent: *
Disallow: /
```

**After release approval**, robots policy becomes:

```text
User-agent: *
Allow: /

Sitemap: https://aidatanaly.com/sitemap.xml
```

No robots change may occur before this plan is ratified and the final release gate passes.

---

## 9. Noindex Removal Rule

Before release, all public pages may contain temporary `noindex`.

After release approval, `noindex` must be removed from the 41 public routes.

The release gate must verify:

- no public launch page contains `noindex`,
- non-public preview routes remain excluded,
- sitemap contains exactly 41 URLs,
- robots permits intended indexation,
- and no repository-only file is exposed through sitemap.

---

## 10. Sitemap Rule

`sitemap.xml` must be generated from `ROUTE_MAP.md`.

A route may enter sitemap only if:

- it belongs to the 41 Required Launch routes,
- its `index.html` exists,
- it is intended for public indexation,
- and it has a valid canonical URL.

The final sitemap must contain exactly 41 URLs.

---

## 11. Final Quality Gate

Before deployment, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/quality-gate.ps1
```

Then run the release-specific gate after indexation activation changes.

The final gate must confirm:

```text
Quality Gate: PASS
Data: PASS
Interface: PASS
Scanner: PASS
Pages: PASS
Sitemap: PASS
Required Launch Routes: 41/41
Broken Links: 0
Orphan Pages: 0
Public Noindex: 0
Robots: Allow
Sitemap: Active
Forbidden Deployment Files: 0
```

---

## 12. Scanner Release Requirements

The public scanner must remain governed.

Scanner release requirements:

- reads from `/data/*.json`,
- does not duplicate hidden scoring logic,
- enforces E0 as Unscorable,
- enforces Partial Profile,
- assigns failure modes only from TFO,
- links outputs to canonical reference pages,
- does not create dynamic indexable result routes,
- does not guarantee commercial outcomes,
- and does not use external JavaScript dependencies.

The scanner must remain a diagnostic reference tool, not a claim-heavy conversion quiz.

---

## 13. Claim and Messaging Boundaries

The public release **may** claim:

- AIDAtanaly introduces AIDA Transition Analytics.
- AIDAtanaly defines ATI as a governed internal measurement standard.
- AIDAtanaly defines TFO as a governed failure ontology.
- Scanner v1 provides rules-governed diagnostic output.
- Evidence Confidence qualifies interpretation strength.

The public release **must not** claim:

- adopted industry standard,
- guaranteed conversion improvement,
- guaranteed revenue improvement,
- causal proof,
- market leadership,
- external adoption without evidence,
- benchmark authority without sources,
- or AI certainty.

---

## 14. Monetization Boundary at Release

The first public indexed release may include:

- `/reports/ati-snapshot/`

This page may explain future report value.

It must not use:

- fake urgency,
- fear-based upsell,
- forced lead capture,
- paid rankings,
- generic affiliate banners,
- or guaranteed outcome language.

Monetization must remain trust-preserving.

---

## 15. Analytics Boundary

No analytics are enabled by default in this release plan.

If analytics are later introduced, they require a separate governance decision covering:

- provider,
- data collected,
- consent posture,
- privacy page update,
- script loading method,
- performance impact,
- and opt-out posture where applicable.

The first indexed release may proceed without analytics.

---

## 16. Post-Deploy Checks

After deployment, verify:

- https://aidatanaly.com/
- https://aidatanaly.com/scanner/
- https://aidatanaly.com/sitemap.xml
- https://aidatanaly.com/robots.txt
- https://aidatanaly.com/aida-transition-index/
- https://aidatanaly.com/evidence-confidence/
- https://aidatanaly.com/transition-failure-ontology/
- https://aidatanaly.com/failure-modes/measurement-gap/
- https://aidatanaly.com/methodology/
- https://aidatanaly.com/governance/
- https://aidatanaly.com/sources/
- https://aidatanaly.com/privacy/
- https://aidatanaly.com/terms/

Each checked route must return the expected public page.

The scanner route must load `/data/*.json`.

The sitemap must be reachable.

Robots must permit indexation.

No forbidden route should be linked publicly.

---

## 17. Rollback Procedure

If a blocking issue appears after deployment:

1. Restore `robots.txt` to:

   ```text
   User-agent: *
   Disallow: /
   ```

2. Restore temporary `noindex` if needed.
3. Remove active `Sitemap:` if needed.
4. Revert deployment to previous non-indexed package.
5. Re-run quality gate.
6. Record issue and fix.
7. Redeploy only after gates pass.

Rollback must favor trust preservation over speed.

---

## 18. Release Record

After release, create:

**`PUBLIC_RELEASE_REPORT.md`**

It should include:

- release date,
- commit hash,
- quality gate result,
- route count,
- sitemap count,
- robots state,
- indexation state,
- post-deploy checks,
- issues found,
- fixes applied,
- and final release decision.

---

## 19. Decision Log Requirement

After `PUBLIC_RELEASE_PLAN.md` is reviewed and accepted, it should be ratified by decision log.

**Expected decision file:**

`governance/decisions/DECISION_PUBLIC_RELEASE_PLAN_1_0_INITIAL_RATIFICATION.md`

**Expected decision ID:** PUB-REL-001

The decision should explicitly ratify:

- first public indexed reference release requirements,
- 41-route release requirement,
- deployment exposure policy,
- exclusion of repository governance artifacts from public website deployment,
- indexation activation procedure,
- robots policy change,
- sitemap activation,
- noindex removal rule,
- final quality gate,
- post-deploy checks,
- and rollback procedure.

**Pre-ratification rule:** Do not remove `noindex`, change `robots.txt`, or activate public indexation until PUB-REL-001 is ratified.

---

## 20. Closing Release Declaration

AIDAtanaly may be indexed only when it is complete as a governed public reference system.

Routes define where meaning lives.

Blueprints define how meaning is built.

Implementation makes the system real.

Public release exposes it to the world.

This plan ensures that exposure is intentional, complete, and reversible.

> Stages are states. Value lives in transitions.

**AIDAtanaly.com** — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.

---

## 21. Pre-Ratification Operator Decisions

Two decisions must be confirmed before PUB-REL-001 ratification. Until confirmed, Sprint 11 must not proceed.

### A. Deployment channel: `dist/` package vs `gh-pages` branch

| Option | Description | Exposure boundary |
|--------|-------------|-------------------|
| **Recommended: `dist/` build package** | Generate `dist/` from governed public artifacts only; deploy `dist/` contents to hosting (custom domain or Pages artifact upload). | Strongest separation: repository root never becomes the web root. |
| **Alternative: `gh-pages` branch** | CI builds the same public artifact set into a dedicated branch; GitHub Pages serves that branch only. | Equivalent boundary **if and only if** the branch contains no repository governance files. |
| **Not permitted** | Publishing the repository root as the website root. | Exposes `*.md`, `scripts/`, `governance/decisions/`, and preview tooling as browsable URLs. |

**Operator note:** Either permitted option must implement Section 5–6 exclusions. A future `scripts/build-dist.ps1` (Sprint 11) should enforce the allowlist.

### B. Repository visibility vs public website visibility

These are **separate** decisions:

| Layer | Question | Recommended posture |
|-------|----------|---------------------|
| **Website** | What is publicly served at `aidatanaly.com`? | Only Section 6 deployment package artifacts. Governance is explained via `/governance/` HTML, not root Markdown. |
| **Repository** | Is the GitHub repository public or private? | Either is compatible with this plan. Public repo allows governance Markdown and decision logs to be read on GitHub without deploying them as website routes. Private repo keeps source private while the site remains public via `dist/` deploy. |

**Critical rule:** Repository visibility does **not** override deployment exposure policy. A public repository must still **not** publish root Markdown or `governance/decisions/` as website routes.

### C. Recommended default (pending operator confirmation)

1. **`dist/`** as the canonical deployment artifact (portable across hosts).
2. **Public repository** acceptable if decision logs remain GitHub-only artifacts and deployment never uses repo root as web root.
3. **Indexation activation deferred** until PUB-REL-001 ratifies this plan and Sprint 11 gates pass.

---

## Document Separation Reference

| Artifact | Role |
|----------|------|
| `governance/decisions/` | **Why** a governing rule was ratified |
| `IMPLEMENTATION_LEDGER.md` | **What** was built, sprint by sprint |
| `PRIVATE_PREVIEW_REPORT.md` | **Whether** the system is ready for private preview |
| `PUBLIC_RELEASE_PLAN.md` | **How** public indexation may be activated |
| `PUBLIC_RELEASE_REPORT.md` | **What happened** at indexed release (after Sprint 11) |

Sprint completion is recorded in the Implementation Ledger, not as individual decision logs.
