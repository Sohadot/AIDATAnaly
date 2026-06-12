# AIDAtanaly Private Preview Report

**Status:** Draft Review  
**Sprint:** 10 — Private Preview  
**Date:** 2026-06-12  
**Governed by:** `IMPLEMENTATION_PLAN.md` Sprint 10, `scripts/quality-gate.ps1`

This report records private preview readiness. It does **not** authorize public indexing. The switch to indexed posture remains governed by `PUBLIC_RELEASE_PLAN.md` (next phase after Sprint 10).

---

## 1. Preview Scope

Private preview validates the **complete Required Launch system** as an integrated reference graph:

- 41/41 governed routes implemented
- Data registry, interface foundation, scanner, pages, sitemap, and internal linking
- Local static-server behavior (including `/data/` fetches required by Scanner v1)
- Indexation posture unchanged: **NON-INDEXED**

**Out of scope for Sprint 10:**

- Removing `noindex`
- Changing `robots.txt` (`Disallow: /` preserved)
- Activating `Sitemap:` in `robots.txt`
- Adding analytics
- Adding routes or buyer-facing pages

---

## 2. Environment

| Item | Value |
|------|-------|
| Repository root | `C:\Projects\AIDATAnaly` |
| Local server | `python3 -m http.server 8000` from repo root |
| Preview base URL | `http://localhost:8000/` |
| Scanner data dependency | `/data/scanner-model.json` (+ three other JSON files via `scanner.js`) |
| Automated gate | `powershell -ExecutionPolicy Bypass -File scripts/quality-gate.ps1 -PrivatePreview` |

**Note:** Preview must be served over HTTP from the repository root. Opening `index.html` directly from the filesystem breaks Scanner data loading.

---

## 3. Quality Gate Result

Executed: `scripts/quality-gate.ps1 -PrivatePreview`

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

Validator counts at gate time:

| Validator | Result |
|-----------|--------|
| `validate-data.ps1` | 25/25 |
| `validate-interface.ps1` | 17/17 |
| `validate-scanner.ps1` | 23/23 |
| `validate-pages.ps1` | 308/308 (pre- and post-sitemap) |
| `generate-sitemap.ps1` | 41 URLs |

---

## 4. Manual Route Review

Routes reviewed over local HTTP (`http://localhost:8000`):

| Route | HTTP | One H1 | noindex | Canonical | CSS | Notes |
|-------|------|--------|---------|-----------|-----|-------|
| `/` | 200 | ✓ | ✓ | ✓ | ✓ | Homepage hub, primary message, blueprint links |
| `/aida-transition-index/` | 200 | ✓ | ✓ | ✓ | ✓ | ATI Standard reference |
| `/evidence-confidence/` | 200 | ✓ | ✓ | ✓ | ✓ | E0–E4 separation from score |
| `/transition-failure-ontology/` | 200 | ✓ | ✓ | ✓ | ✓ | TFO hub, dossier links |
| `/vectors/interest-to-desire/` | 200 | ✓ | ✓ | ✓ | ✓ | T2 vector dossier pattern |
| `/failure-modes/measurement-gap/` | 200 | ✓ | ✓ | ✓ | ✓ | Constraint page, E0 / Partial Profile |
| `/scanner/` | 200 | ✓ | ✓ | ✓ | ✓ | Wizard UI, local `scanner.js` only |
| `/methodology/` | 200 | ✓ | ✓ | ✓ | ✓ | Claim restraint statement |
| `/governance/` | 200 | ✓ | ✓ | ✓ | ✓ | Versioning, no decision-log exposure |
| `/sources/` | 200 | ✓ | ✓ | ✓ | ✓ | Adoption evidence posture |
| `/reports/ati-snapshot/` | 200 | ✓ | ✓ | ✓ | ✓ | Report template, no fear upsell |
| `/privacy/` | 200 | ✓ | ✓ | ✓ | ✓ | Scanner sensitive-data boundary |
| `/terms/` | 200 | ✓ | ✓ | ✓ | ✓ | No-guarantee section |

Additional check: `/data/scanner-model.json` returns 200 when served from repo root.

**Manual route review:** PASS (13/13 routes + scanner data)

---

## 5. Scanner Scenario Tests

Three governed scenarios were exercised against Scanner v1 logic (mirroring `assets/js/scanner.js` and `/data/*.json`).

### Scenario 1 — Full Scorable Profile

**Input:** All evidence questions strong (≥ Moderate); all vector answers Strong (4).

**Expected output elements:**

- Composite ATI: `{score}` — `{diagnostic_class}`
- Evidence Confidence summary
- T1–T4 results
- Weakest vector / Strongest vector
- Failure modes (when signal patterns warrant)
- Intervention layers
- Reference links

**Result:** PASS — composite profile issued; no Partial Profile banner.

### Scenario 2 — Partial Profile

**Input:** `ev.retention = 0` (T4 required evidence absent); other vectors fully scorable.

**Expected:**

- `ATI Profile: Partial`
- `Scorable vectors: [...]`
- `Unscorable vectors: [...] / E0 Absent Evidence`

**Must not appear:** `Composite ATI: {score}`

**Result:** PASS — partial profile only; composite suppressed.

### Scenario 3 — Weak Transition Diagnosis

**Input:** T2 and T3 vector answers all Weak/Absent (0); sufficient evidence elsewhere.

**Expected:** TFO failure modes from weak T2/T3 only, linking to existing dossier routes such as:

- `/failure-modes/comparison-stall/`
- `/failure-modes/value-ambiguity/`
- `/failure-modes/process-friction/`
- `/failure-modes/trust-deficit/`

**Result:** PASS — failure mode routes resolve to implemented pages.

**Scanner manual tests:** PASS (3/3 scenarios)

---

## 6. Interface Review

Confirmed via `validate-interface.ps1` and spot review on preview routes:

- Governed stylesheet only (`/assets/css/main.css`)
- No external JS, CSS, fonts, or CDN dependencies
- No WebGL, 3D, or canvas rendering
- Evidence Confidence uses neutral styling; diagnostic colors confined to diagnostic surfaces
- Transition Axis and scanner result components render without decorative motion
- `prefers-reduced-motion` supported
- Trust pages readable without JavaScript; Scanner uses governed local enhancement only

**Interface review:** PASS

---

## 7. Content and Claim Review

Spot review on trust and hub pages confirms:

- Mandatory measurement claim restraint on `/methodology/`
- Evidence Confidence separated from ATI score language
- No unqualified “industry standard” claims
- No guarantee or revenue-outcome promises on trust pages or `/reports/ati-snapshot/`
- Scanner disclosures present (no exact causality, no guaranteed improvement)
- Prohibited-claim scan in `validate-pages.ps1` passes across all 41 routes

**Content and claim review:** PASS

---

## 8. Link Review

From `validate-pages.ps1` Sprint 8 checks (confirmed at quality gate):

- Broken internal links: **0**
- Orphan pages: **0**
- No links to `/preview/`, `/governance/decisions/`, `/claims-policy/`, or `/versioning/`
- All pages link up to `/` via site header
- Minimum internal hub linking satisfied
- Sitemap contains exactly 41 launch URLs; no forbidden segments in `<loc>` values

**Link review:** PASS

---

## 9. Indexation Posture

| Control | Expected | Observed |
|---------|----------|----------|
| Page `<meta robots>` | `noindex` on all 41 launch pages | ✓ |
| `robots.txt` | `Disallow: /` | ✓ |
| Active `Sitemap:` directive | Absent (comment-only reference) | ✓ |
| Analytics | None | ✓ |
| `sitemap.xml` | Generated, 41 URLs, pre-launch comment | ✓ |

**Indexation posture:** NON-INDEXED (correct for private preview)

---

## 10. Issues Found

| ID | Severity | Issue | Status |
|----|----------|-------|--------|
| — | — | No blocking issues | — |

**Non-blocking observation:** On Windows, the Microsoft Store `python3.exe` stub does not run `http.server`. `quality-gate.ps1 -PrivatePreview` now resolves a working Python 3 executable before starting the preview server.

---

## 11. Fixes Applied

| Fix | File | Purpose |
|-----|------|---------|
| Private preview orchestration | `scripts/quality-gate.ps1` | `-PrivatePreview` switch: HTTP route checks, scanner scenarios, final preview report |
| Python discovery | `scripts/quality-gate.ps1` | Reliable Python 3 resolution for local server and scenario runner |
| Sprint 10 documentation | `scripts/README.md` | Private preview workflow and gate command |

No HTML, data, `robots.txt`, or indexation changes were required for preview pass.

---

## 12. Final Preview Decision

```text
Private Preview: PASS
Quality Gate: PASS
Scanner Manual Tests: PASS
Indexation Posture: NON-INDEXED
Blocking Issues: 0
```

**Decision:** The site is **technically ready for private preview** as a complete governed reference system. Public indexing remains **deferred** until `PUBLIC_RELEASE_PLAN.md` is executed (explicit approval to remove `noindex`, allow crawling, and activate sitemap discovery).

**Next phase:** `PUBLIC_RELEASE_PLAN.md` — not automatic de-index removal.

---

*Report generated as part of Sprint 10. Re-run `scripts/quality-gate.ps1 -PrivatePreview` after any material change.*
