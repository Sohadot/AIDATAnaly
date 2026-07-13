# AIDATAnaly — AIDA Transition Analytics

AIDATAnaly is a governed reference system for **AIDA Transition Analytics**: measuring movement between AIDA stages rather than treating stages as outcomes.

Core doctrine:

> **Stages are states. Value lives in transitions.**

Live reference system: **https://aidatanaly.com/**

Name logic: **AIDA + T + Analy = AIDATAnaly** — the **T** is **Transition** (BRAND-001).

---

## 1. What This Is

- A **category artifact**: the reference surface for AIDA Transition Analytics — its language, taxonomy, standard, protocol, and diagnostic engine.
- **Four governed transition vectors**: T1 Signal Conversion (Attention → Interest), T2 Intent Formation (Interest → Desire), T3 Conversion Friction (Desire → Action), T4 Retention Extension (Action → Loyalty).
- A **governed ontology** of movement failure modes (Transition Failure Ontology — TFO) with stable IDs and canonical dossier pages.
- A **scoring standard** (AIDA Transition Index — ATI) with Evidence Confidence reported separately from the diagnostic scale.
- A **rules-governed Transition Scanner** whose every output resolves to canonical reference pages.
- **Agent-readable by design**: JSON-LD structured data on every route, `llms.txt`, and machine-readable registries under `/data/`.

## 2. What This Is Not

- Not a SaaS product pitch, a growth hack, or a conversion guarantee tool.
- Not "AI data analysis" — the T is Transition.
- Not a content farm: no page exists without an ontology, standard, protocol, tool, or governance justification.

**This repository does not claim industry adoption, guaranteed revenue improvement, or causal proof.** The full claim policy is `governance/policies/CLAIM_BOUNDARY.md`.

## 3. Core Layers

| Layer | Governing document |
|-------|--------------------|
| Foundation doctrine | `FOUNDATION_DOCTRINE.md` |
| Asset thesis (13-layer model) | `ASSET_THESIS.md` |
| Scoring standard (ATI) | `ATI_STANDARD.md` |
| Failure ontology (TFO) | `TFO_ONTOLOGY.md` |
| Scanner model | `SCANNER_MODEL.md` |
| Route architecture | `ROUTE_MAP.md` |
| Page blueprints | `PAGE_BLUEPRINTS.md` |
| Interface governance ("Flow Made Visible") | `INTERFACE_GOVERNANCE.md` |
| Implementation plan / ledger | `IMPLEMENTATION_PLAN.md`, `IMPLEMENTATION_LEDGER.md` |
| Public release plan | `PUBLIC_RELEASE_PLAN.md` |

## 4. Public Routes

41 governed launch routes, all indexed, zero orphans, zero broken links:

- `/` — home
- `/aida-transition-analytics/` — category definition
- `/aida-transition-index/` — the ATI standard
- `/transition-failure-ontology/` — the TFO taxonomy
- `/vectors/…` — the four transition vectors
- `/failure-modes/…` — 22 canonical failure/constraint dossiers
- `/scanner/` — the Transition Scanner
- `/methodology/`, `/governance/`, `/sources/`, `/privacy/`, `/terms/` — trust layer
- `/data/*.json` — machine-readable registries; `llms.txt` — agent guide

The authoritative registry is `ROUTE_MAP.md`; the sitemap is generated, never hand-edited.

## 5. Governance

- **Decisions** are ratified, append-only logs in `governance/decisions/`.
- **Policies** live in `governance/policies/` (claim boundary; external evidence policy in `external/`).
- **Audits** live in `governance/audits/` (inevitability audit, release and QA reports).
- **External positioning** material lives in `external/` — publication drafts and the positioning control layer. Engagement metrics and post URLs are maintained privately by the operator, never in this repository (`external/EXTERNAL_PUBLICATION_POLICY.md`).
- Every change passes the quality gate: data, interface, scanner, pages, structured data, sitemap, dist, and deploy-policy validators (`scripts/`).

## 6. Deployment

Main-only (PUB-REL-002): `main` is the sole source branch. GitHub Actions runs `scripts/quality-gate.ps1 -IndexedRelease`, builds the governed `dist/` package, and deploys it to GitHub Pages. The repository root is never served directly; governance documents never enter the deployment package.

## 7. Claim Boundaries

All public content, structured data, and external copy are bound by `governance/policies/CLAIM_BOUNDARY.md`:

- Allowed: "AIDATAnaly introduces / defines / publishes…", governed reference system, diagnostic reference layer.
- Prohibited: industry-standard claims, adoption claims, revenue guarantees, causal proof, AI certainty.
- Scanner outputs are diagnostic references, not guarantees of commercial outcome.

---

*AIDATAnaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.*
