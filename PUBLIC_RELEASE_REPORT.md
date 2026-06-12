# AIDAtanaly.com — Public Release Report

**Document Class:** Public Release Report (repository artifact — not a public website route)  
**Asset:** AIDAtanaly.com  
**Governed by:** `PUBLIC_RELEASE_PLAN.md` (PUB-REL-001)  
**Release date:** 2026-06-12  
**Commit hash:** `f2afbc4`  
**Indexation state:** Active (source + `dist/` package)

---

## 1. Release Summary

First public indexed reference release activation completed in governed order:

1. Checkpoint pushed to `origin/main`
2. `noindex` removed from 41 Required Launch routes only (`scripts/activate-indexation.ps1`)
3. `robots.txt` activated (`Allow: /` + `Sitemap:`)
4. `sitemap.xml` regenerated (41 URLs)
5. `dist/` rebuilt (`scripts/build-dist.ps1`)
6. Final indexed release gate passed (`quality-gate.ps1 -IndexedRelease`)
7. Activation committed and pushed
8. `dist/` deployed to `gh-pages` branch (`scripts/deploy-dist.ps1`)

Repository governance artifacts (`*.md`, `governance/decisions/`, `scripts/`, `preview/`) were **not** deployed as website routes.

---

## 2. Quality Gate Result

```text
Quality Gate: PASS
Release Package: PASS
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
Sitemap Directive: Active
Sitemap URLs: 41
Forbidden Deployment Files: 0
Indexation Posture: ACTIVE
```

Command:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/quality-gate.ps1 -IndexedRelease
```

---

## 3. Route and Sitemap Counts

| Metric | Value |
|--------|-------|
| Required Launch Routes | 41/41 |
| Sitemap URLs | 41 |
| Extra sitemap routes | 0 |
| Missing sitemap routes | 0 |

---

## 4. Robots State

**Active policy (source + `dist/`):**

```text
User-agent: *
Allow: /

Sitemap: https://aidatanaly.com/sitemap.xml
```

---

## 5. Deployment

| Item | Value |
|------|-------|
| Deployment package | `dist/` (PUB-REL-001) |
| Deploy target | `gh-pages` branch on `origin` |
| Deploy method | `scripts/deploy-dist.ps1` (generated from `dist/` only) |
| Repository root deployed | **No** (prohibited) |

**gh-pages branch contents verified:** 41 route trees, `assets/`, `data/`, `sitemap.xml`, `robots.txt`, `/governance/index.html` only — no `scripts/`, `preview/`, `*.md`, or `governance/decisions/`.

---

## 6. Post-Deploy Checks

### 6.1 Local verification of deployed package (`dist/` over HTTP)

| URL (local) | Result |
|-------------|--------|
| `/` | 200, no `noindex` |
| `/robots.txt` | 200, `Allow: /` |
| `/sitemap.xml` | 200, 41 locs |
| `/scanner/` | 200 |
| `/data/scanner-model.json` | 200 |
| `/governance/decisions/` | Not found (expected) |

### 6.2 Live domain checks (`https://aidatanaly.com/`)

Live HTTPS checks from the build environment did not complete successfully at release time:

- `https://aidatanaly.com/*` — TLS trust / certificate validation failure from this environment
- `http://aidatanaly.com/robots.txt` — HTTP 404

**Operator follow-up required:**

1. Enable GitHub Pages for repository `Sohadot/AIDATAnaly` with source branch **`gh-pages`** (root).
2. Confirm custom domain `aidatanaly.com` DNS + GitHub Pages custom domain + TLS provisioning.
3. Re-run live URL checklist from Section 7 after DNS/Pages propagation.

Until live domain serves the `gh-pages` deployment, the release package and indexation posture are **activated in source and deployed to `gh-pages`**, but public URL verification remains pending.

---

## 7. Post-Deploy URL Checklist (live — pending propagation)

After GitHub Pages + custom domain are active, verify:

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

Confirm: robots allows indexation, sitemap reachable, scanner loads `/data/*.json`, no `governance/decisions/` website route, no Markdown published as site pages.

---

## 8. Issues Found

| ID | Severity | Issue | Status |
|----|----------|-------|--------|
| REL-001 | Blocking (live verification) | Custom domain / GitHub Pages not yet serving `gh-pages` from this environment | Pending operator DNS/Pages setup |
| REL-002 | Info | TLS validation failed against `aidatanaly.com` during automated post-deploy fetch | Re-check after certificate provisioning |

No gate failures. No forbidden deployment files in `dist/`.

---

## 9. Fixes Applied

| Fix | Purpose |
|-----|---------|
| `scripts/activate-indexation.ps1` | Governed removal of `noindex` from 41 routes + robots activation |
| `scripts/quality-gate.ps1 -IndexedRelease` | Final indexed release gate with `Public Noindex: 0` |
| `scripts/validate-pages.ps1 -IndexedRelease` | Indexed posture validation |
| `scripts/validate-dist.ps1 -IndexedRelease` | Indexed `dist/` validation |
| `scripts/deploy-dist.ps1` | Deploy `dist/` only to `gh-pages` |
| Privacy page prose | Removed stale pre-launch `noindex` statement |

---

## 10. Final Release Decision

```text
Source Release Activation: PASS
Final Indexed Release Gate: PASS
dist/ Deployment to gh-pages: PASS
Live Domain Verification: PENDING (DNS / GitHub Pages / TLS)
Forbidden Deployment Files: 0
Indexation Posture (source + dist): ACTIVE
```

**Decision:** AIDAtanaly first public indexed reference release is **activated in repository source and deployed to `gh-pages` from governed `dist/`**. Live public URL confirmation at `aidatanaly.com` remains pending GitHub Pages and custom domain configuration.

Rollback procedure remains available per `PUBLIC_RELEASE_PLAN.md` Section 17 if live verification reveals a blocking issue.

---

*Repository artifact only. Not included in `dist/` or sitemap.*
