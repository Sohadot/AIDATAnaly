# DECISION_PUBLIC_RELEASE_PLAN_1_0_INITIAL_RATIFICATION.md

## AIDAtanaly.com — Public Release Plan v1.0 Initial Ratification Decision

**Document Class:** Governance Decision Log  
**Asset:** AIDAtanaly.com  
**Applies to:** `PUBLIC_RELEASE_PLAN.md`  
**Decision ID:** PUB-REL-001  
**Decision Type:** Initial Ratification  
**Status:** Ratified  
**Ratified by:** Sohadot — System Operator  
**Date:** 2026-06-12  
**Resulting Version:** Public Release Plan v1.0

---

## 1. Decision Summary

This decision ratifies `PUBLIC_RELEASE_PLAN.md` as the governed public exposure and indexation plan for AIDAtanaly.com.

The Public Release Plan governs the first public indexed reference release of AIDAtanaly.

This decision confirms that AIDAtanaly may move from non-indexed private preview readiness toward a controlled public indexed release only through the release procedure defined in `PUBLIC_RELEASE_PLAN.md`.

The governing thesis remains:

> Stages are states. Value lives in transitions.

---

## 2. Ratified Scope

This decision ratifies:

- first public indexed reference release requirements,
- 41-route release requirement,
- deployment exposure policy,
- controlled deployment package rule,
- exclusion of repository governance artifacts from public website deployment,
- indexation activation procedure,
- robots policy change procedure,
- sitemap activation procedure,
- noindex removal rule,
- final quality gate requirement,
- scanner release requirements,
- claim and messaging boundaries,
- analytics boundary,
- post-deploy checks,
- rollback procedure,
- and public release reporting requirement.

---

## 3. Relationship to Prior Governance

Public Release Plan v1.0 is governed by:

- `FOUNDATION_DOCTRINE.md`
- `ASSET_THESIS.md`
- `ATI_STANDARD.md`
- `TFO_ONTOLOGY.md`
- `ROUTE_MAP.md`
- `INTERFACE_GOVERNANCE.md`
- `SCANNER_MODEL.md`
- `PAGE_BLUEPRINTS.md`
- `IMPLEMENTATION_PLAN.md`

The public release must not contradict any ratified doctrine, route rule, interface rule, scanner rule, implementation rule, or page blueprint.

Specifically:

- no incomplete release may be indexed,
- no route outside `ROUTE_MAP.md` may be exposed as a public site route,
- no repository governance artifact may be accidentally deployed as a website page,
- no scanner result route may become dynamically indexable,
- and no unsupported adoption, revenue, causality, or market leadership claim may be introduced.

---

## 4. First Public Indexed Reference Release Requirement

This decision ratifies that the first public indexed release must include the complete 41-route Required Launch set.

The public indexed release must include:

- homepage,
- 3 required category routes,
- 3 required ATI standard routes,
- 4 vector routes,
- TFO overview,
- 22 failure mode and diagnostic constraint routes,
- scanner route,
- ATI Snapshot report route,
- methodology route,
- governance route,
- sources route,
- privacy route,
- terms route.

No incomplete public indexed release may be treated as AIDAtanaly's first official reference release.

---

## 5. Deployment Package Decision

This decision ratifies `dist/` as the governed deployment package.

The public website must be deployed from a controlled package, not from the repository root.

The deployment package must include only public website artifacts required for AIDAtanaly.com.

Recommended release package:

```text
dist/
```

The `dist/` package may be deployed directly to hosting or copied into a publishing branch.

---

## 6. GitHub Pages / gh-pages Rule

A `gh-pages` branch is allowed only if it is generated from `dist/`.

The `gh-pages` branch must contain public website artifacts only.

It must not contain:

- root Markdown governance documents,
- `governance/decisions/`,
- `scripts/`,
- `preview/`,
- private reports,
- validation tooling,
- implementation notes,
- `.gitkeep` files,
- or repository-only files.

Using the repository root as the website root is prohibited.

---

## 7. Repository Visibility Decision

This decision confirms that repository visibility and website exposure are separate.

The repository may remain public.

A public repository does not authorize exposing repository governance files as public website routes.

If the repository is public, decision logs may be readable on GitHub as repository artifacts.

However, they must not be accidentally published as AIDAtanaly.com website routes.

The public website exposure boundary is the deployment package, not repository visibility.

---

## 8. Public Website Exposure Policy

The public website may expose:

- the 41 public route directories,
- `/assets/`,
- `/data/` files required by scanner operation,
- `sitemap.xml`,
- `robots.txt`,
- and required static public assets.

The public website must not expose:

- root Markdown governance documents,
- `governance/decisions/`,
- `scripts/`,
- `preview/`,
- private reports,
- validation tooling,
- `.gitkeep` files,
- repository-only files,
- or implementation-only notes.

The public `/governance/` page remains the public trust surface.

No accidental exposure policy is permitted.

---

## 9. Indexation Activation Rule

Indexation activation must be deliberate and auditable.

Before public release, AIDAtanaly remains non-indexed.

Indexation may be activated only after:

- full quality gate passes,
- private preview passes,
- sitemap contains exactly 41 URLs,
- public release plan is ratified,
- deployment package is generated,
- deployment package excludes forbidden files,
- page-level `noindex` is removed from the 41 public routes,
- `robots.txt` is changed to allow indexation,
- `Sitemap:` is activated,
- and final release gate passes.

No direct removal of `noindex` is permitted before this release procedure.

---

## 10. Robots Policy Ratification

Before release activation, the valid robots policy remains:

```text
User-agent: *
Disallow: /
```

After release approval and final gate pass, the release may change robots policy to:

```text
User-agent: *
Allow: /

Sitemap: https://aidatanaly.com/sitemap.xml
```

This change must occur only as part of the governed public release activation procedure.

---

## 11. Noindex Removal Ratification

Before release activation, page-level `noindex` may remain present.

After release approval, `noindex` must be removed from the 41 public launch routes.

The final release gate must confirm:

- public noindex count is zero,
- non-public routes remain excluded,
- sitemap contains exactly 41 URLs,
- robots permits intended indexation,
- and forbidden repository artifacts are not deployed.

---

## 12. Sitemap Activation Ratification

`sitemap.xml` must be generated from `ROUTE_MAP.md`.

A route may enter sitemap only if:

- it belongs to the 41 Required Launch routes,
- its `index.html` exists,
- it is intended for public indexation,
- and it has a valid canonical URL.

The final public sitemap must contain exactly 41 URLs.

The sitemap must not include:

- `/preview/`
- `/data/`
- `/assets/`
- `/scripts/`
- `/governance/decisions/`
- root Markdown files,
- validation scripts,
- repository-only files,
- or routes outside `ROUTE_MAP.md`.

---

## 13. Final Release Gate Ratification

The final release gate must confirm:

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

A public indexed release is prohibited if any of these checks fail.

---

## 14. Scanner Public Release Rule

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

## 15. Claim Boundary Ratification

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

## 16. Analytics Boundary Ratification

No analytics are enabled by default in this release.

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

## 17. Post-Deploy Check Requirement

After deployment, the following must be verified:

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

The scanner route must load required `/data/*.json`.

The sitemap must be reachable.

Robots must permit indexation.

No forbidden route should be linked publicly.

---

## 18. Rollback Ratification

If a blocking issue appears after deployment, rollback must favor trust preservation over speed.

Rollback may include:

1. restoring `robots.txt` to:

   ```text
   User-agent: *
   Disallow: /
   ```

2. restoring temporary `noindex` if needed,
3. removing active `Sitemap:` if needed,
4. reverting deployment to the previous non-indexed package,
5. re-running the quality gate,
6. recording the issue and fix,
7. redeploying only after gates pass.

---

## 19. Public Release Report Requirement

After release, a release report must be created:

**`PUBLIC_RELEASE_REPORT.md`**

The report must include:

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

The release report records what happened during exposure.

It is not a decision log.

---

## 20. Compatibility Statement

This is the initial ratification of Public Release Plan v1.0.

No prior public release plan was issued.

No public indexed AIDAtanaly release depends on an earlier release plan.

No migration is required.

Future public releases must comply with this plan or be governed by a later ratified version.

---

## 21. Governance Impact

This decision moves AIDAtanaly from private preview readiness to governed public release readiness.

It prevents:

- accidental indexation,
- incomplete public exposure,
- repository root deployment,
- accidental exposure of governance decision logs as website routes,
- premature sitemap activation,
- unsupported launch claims,
- analytics drift,
- and irreversible release behavior.

It ensures that public exposure is intentional, complete, and reversible.

---

## 22. Repository Handling

The final root-level public release plan must remain:

**`PUBLIC_RELEASE_PLAN.md`**

This decision record must be archived under:

**`governance/decisions/DECISION_PUBLIC_RELEASE_PLAN_1_0_INITIAL_RATIFICATION.md`**

This preserves both:

1. a clean readable release plan,
2. an auditable governance trail for its initial ratification.

---

## 23. Closing Decision

Public Release Plan v1.0 is ratified as the governed public exposure and indexation plan for AIDAtanaly.

The release package must be controlled.

The repository root must not be deployed as the website root.

The repository may remain public, but public website exposure is limited to approved website artifacts.

The first public indexed release must include the complete 41-route reference system.

Indexation must be deliberate.

Rollback must remain available.

> Stages are states. Value lives in transitions.

**AIDAtanaly.com** — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.
