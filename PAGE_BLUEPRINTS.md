# PAGE_BLUEPRINTS.md

## AIDAtanaly.com — Governed Page Blueprint Standard

**Document Class:** Page Blueprint Standard
**Layer:** 7 — Public Page Production Layer
**Asset:** AIDAtanaly.com
**Governed by:** FOUNDATION_DOCTRINE.md, ASSET_THESIS.md, ATI_STANDARD.md, TFO_ONTOLOGY.md, ROUTE_MAP.md, INTERFACE_GOVERNANCE.md, and SCANNER_MODEL.md
**Status:** Ratified
**Version:** 1.0
**Date:** 2026-06-12
**Ratified by:** Sohadot — System Operator

---

## 1. Purpose of This Standard

This document defines the governed page blueprints used to produce the public reference surface of AIDAtanaly.com.

The purpose of this standard is to prevent uncontrolled page production, weak route execution, generic SEO pages, duplicated layouts, thin content, broken internal linking, and interface drift.

AIDAtanaly is not permitted to publish pages merely because a keyword exists.

Every page must serve the asset's governing thesis:

> Stages are states. Value lives in transitions.

A page is valid only if it strengthens at least one of the following:

- the category definition,
- the ATI Standard,
- the TFO Ontology,
- the scanner model,
- the reference architecture,
- the internal linking graph,
- the interface thesis,
- the monetization boundary,
- the governance posture,
- or the strategic buyer logic.

---

## 2. Governed Page Principle

AIDAtanaly pages are not articles.

They are governed reference units.

Each page must answer:

1. What concept does this page define?
2. Which governed document authorizes this page?
3. Which route in `ROUTE_MAP.md` does it implement?
4. Which internal links are mandatory?
5. Which scanner or ontology output may reference it?
6. Which claim language is allowed?
7. Which claim language is prohibited?
8. Which component pattern from `INTERFACE_GOVERNANCE.md` applies?
9. Which machine-readable structure may later mirror it?
10. How does this page strengthen the asset's category authority?

No page may be published without a structural answer to these questions.

---

## 3. Page Classes Governed by This Standard

This standard governs the following page classes:

| Page Class | Primary Function |
|---|---|
| Homepage | Introduces the asset and thesis |
| Category Page | Defines category language |
| Standard Page | Explains ATI, evidence, or intervention rules |
| Vector Page | Defines one ATI transition vector |
| Ontology Page | Explains the TFO system |
| Failure Mode Page | Defines one TFO failure mode or diagnostic constraint |
| Scanner Page | Hosts the diagnostic engine |
| Scanner Result View | Displays governed scanner output |
| Report Page | Explains free or paid diagnostic outputs |
| Methodology Page | Explains how the system works |
| Governance Page | Explains trust, versioning, claims, privacy, or terms |
| Source Page | Explains source posture and reference limitations |
| Buyer Page | Supports strategic acquisition logic when activated |
| Data Reference Page | Human-readable explanation of future JSON/data endpoints |

---

## 4. Universal Page Requirements

Every public page must include:

- one canonical route,
- one `<h1>`,
- one unique title,
- one unique meta description,
- semantic HTML structure,
- visible internal links,
- no broken links,
- no orphan status,
- accessible text contrast,
- keyboard-readable structure,
- reduced-motion compatibility,
- clear relationship to the governing system,
- and page-specific internal links defined by this standard.

Every public page must avoid:

- filler introductions,
- generic marketing advice,
- keyword stuffing,
- fake benchmarks,
- unsupported industry-standard claims,
- exaggerated AI claims,
- revenue guarantee language,
- duplicate definitions,
- thin glossary-style content,
- and decorative interface patterns that do not explain the system.

---

## 5. Universal Page Metadata Template

Every page should define the following metadata before implementation.

```
Route ID:
Path:
Page Class:
Route Status:
Primary Governed Document:
Secondary Governed Documents:
Canonical Title:
Meta Description:
Primary H1:
Primary Thesis:
Required Components:
Required Internal Links:
Allowed Claim Language:
Prohibited Claim Language:
Machine-Readable Future Mapping:
```

This metadata may appear in source comments, route registry, page front matter, or build-time data.

The metadata must match `ROUTE_MAP.md`.

---

## 6. Universal Content Quality Rules

AIDAtanaly pages must be written as reference assets.

**Required Quality**

Each page must be:

- specific,
- durable,
- internally linked,
- terminology-consistent,
- scanner-compatible where relevant,
- agent-readable,
- and useful without requiring prior knowledge of the project.

**Prohibited Content**

The following are prohibited:

- generic "what is marketing" filler,
- SEO paragraphs that do not define anything,
- duplicated intros across pages,
- vague claims such as "optimize your funnel better,"
- unsupported "AI-powered" claims,
- invented statistics,
- fake market leadership claims,
- thin pages created only for indexation,
- and pages that cannot stand as independent reference nodes.

---

## 7. Universal Interface Requirements

Every page must comply with `INTERFACE_GOVERNANCE.md`.

The interface must embody the thesis:

> Flow Made Visible

Universal interface rules:

- states are visually quiet,
- transitions carry the visual weight,
- score and Evidence Confidence remain separate,
- E0 is displayed as Unscorable,
- diagnostic classes match ATI thresholds,
- motion is semantic, not decorative,
- WebGL/3D is prohibited unless separately governed,
- reference pages are readable without JavaScript,
- and components are reused consistently.

---

## 8. Universal Internal Linking Requirements

Every public page must link upward, sideways, and downward where applicable.

### 8.1 Upward Links

A page must link to its parent system.

Examples:

- failure mode page → parent vector page,
- vector page → ATI Standard,
- ATI page → category page,
- scanner result → scanner and methodology.

### 8.2 Sideways Links

A page must link to related concepts.

Examples:

- failure mode page → related failure modes,
- vector page → adjacent vectors,
- category page → related category terms.

### 8.3 Downward Links

A hub page must link to its governed children.

Examples:

- TFO overview → all failure modes,
- ATI page → all vectors,
- vector page → all failure modes under that vector.

No page may function as a dead end unless explicitly classified as a legal or terminal trust page.

---

## 9. Homepage Blueprint

### 9.1 Purpose

The homepage introduces AIDAtanaly as the reference layer for AIDA Transition Analytics.

It must communicate that AIDAtanaly does not merely describe funnel stages.

It measures movement between states.

Primary message:

> AIDAtanaly measures the movement between Attention, Interest, Desire, Action, and Loyalty.

---

### 9.2 Required Metadata

```
Route ID: AIDA-HOME-001
Path: /
Page Class: Home Route
Route Status: Required Launch
Primary Governed Document: ASSET_THESIS.md
Secondary Governed Documents: FOUNDATION_DOCTRINE.md, ATI_STANDARD.md, TFO_ONTOLOGY.md, ROUTE_MAP.md, INTERFACE_GOVERNANCE.md, SCANNER_MODEL.md
```

---

### 9.3 Required Page Structure

```markdown
# AIDA Transition Analytics

## Hero: Stages Are States. Value Lives in Transitions.
## Transition Axis: Attention → Interest → Desire → Action → Loyalty
## What AIDAtanaly Measures
## The Four Transition Vectors
## The AIDA Transition Index
## The Transition Failure Ontology
## Run the Transition Scanner
## Why This Category Matters
## Reference Architecture
## Methodology and Governance
```

---

### 9.4 Required Components

- Doctrine Statement
- Transition Axis
- Vector Card
- ATI Score Panel preview
- Failure Mode Dossier Block preview
- Scanner Step Panel preview
- Reference Link Cluster

---

### 9.5 Required Internal Links

The homepage must link to:

- `/aida-transition-analytics/`
- `/aida-transition-index/`
- `/transition-failure-ontology/`
- `/scanner/`
- `/methodology/`
- `/governance/`
- `/vectors/attention-to-interest/`
- `/vectors/interest-to-desire/`
- `/vectors/desire-to-action/`
- `/vectors/action-to-loyalty/`

---

### 9.6 Required Copy Rules

Allowed:

> "AIDAtanaly introduces AIDA Transition Analytics."

Allowed:

> "The system measures transition health across Attention, Interest, Desire, Action, and Loyalty."

Prohibited:

> "AIDAtanaly is the industry standard."

Prohibited:

> "The scanner guarantees conversion improvement."

---

## 10. Category Page Blueprint

### 10.1 Purpose

Category pages define the language of AIDAtanaly.

They must establish category meaning, not chase generic search demand.

Examples:

- `/aida-transition-analytics/`
- `/transition-intelligence/`
- `/measurement-grammar/`
- `/ai-governed-funnel-analytics/`
- `/funnel-movement-analysis/`

---

### 10.2 Required Metadata

```
Page Class: Category Page
Primary Governed Document: ASSET_THESIS.md
Secondary Governed Documents: FOUNDATION_DOCTRINE.md, ATI_STANDARD.md, ROUTE_MAP.md
```

---

### 10.3 Required Page Structure

```markdown
# {Category Term}

## Definition
## Why the Category Exists
## What the Category Measures
## What the Category Does Not Claim
## Relationship to AIDA
## Relationship to ATI
## Relationship to TFO
## Example Use Cases
## Scanner Relationship
## Related Category Terms
## Governance Notes
```

---

### 10.4 Required Sections

**Definition**

The page must define the term in AIDAtanaly-governed language.

**Why the Category Exists**

This section must explain the gap the category addresses.

**What the Category Measures**

This section must connect the term to transitions, movement, or diagnostic intelligence.

**What the Category Does Not Claim**

This section prevents overreach.

**Relationship to ATI**

This section must link to `/aida-transition-index/`.

**Relationship to TFO**

This section must link to `/transition-failure-ontology/` where relevant.

---

### 10.5 Required Components

- Doctrine Statement
- Transition Axis where relevant
- Reference Link Cluster
- Stable ID Chip where applicable

---

### 10.6 Required Internal Links

Every category page must link to:

- `/`
- `/aida-transition-index/`
- `/transition-failure-ontology/`
- `/scanner/`
- `/methodology/`
- at least two related category pages where applicable.

---

## 11. ATI Standard Page Blueprint

### 11.1 Purpose

ATI standard pages explain how AIDAtanaly measures transition health.

They translate `ATI_STANDARD.md` into public reference pages without exposing repository-only detail unnecessarily.

Examples:

- `/aida-transition-index/`
- `/ati-standard/`
- `/evidence-confidence/`
- `/intervention-layers/`

---

### 11.2 Required Metadata

```
Page Class: Standard Page
Primary Governed Document: ATI_STANDARD.md
Secondary Governed Documents: SCANNER_MODEL.md, TFO_ONTOLOGY.md, INTERFACE_GOVERNANCE.md
```

---

### 11.3 Required Page Structure

```markdown
# {Standard Topic}

## Definition
## Why This Standard Exists
## Governing Rule
## How It Works
## What It Measures
## What It Does Not Measure
## Relationship to Scanner
## Relationship to TFO
## Output Examples
## Public Claim Limits
## Related Reference Pages
```

---

### 11.4 Special Rule for Evidence Confidence Page

The `/evidence-confidence/` page must clearly state:

> Evidence Confidence is not part of the ATI score.

It must explain:

- E0 — Absent Evidence,
- E1 — Self-Reported Evidence,
- E2 — Observable Evidence,
- E3 — Multi-Source Evidence,
- E4 — Validated Evidence.

It must state:

- E0 does not issue numeric scores,
- E1 requires provisional language,
- E2 requires indicative language,
- E3 and E4 do not permit guaranteed causality.

---

### 11.5 Special Rule for Intervention Layers Page

The `/intervention-layers/` page must define only the approved layers:

- Audience Intervention
- Message Intervention
- Offer Intervention
- Proof Intervention
- UX Intervention
- Pricing Intervention
- Timing Intervention
- Attribution Intervention
- Lifecycle Intervention
- Sales-Assist Intervention

It must clarify that Channel Intervention and Measurement Governance are contextual subcases, not standalone layers in v1.0.

---

## 12. Vector Page Blueprint

### 12.1 Purpose

Vector pages define the four ATI transition vectors.

They must show that the transition, not the stage, is the unit of measurement.

Required vector pages:

- `/vectors/attention-to-interest/`
- `/vectors/interest-to-desire/`
- `/vectors/desire-to-action/`
- `/vectors/action-to-loyalty/`

---

### 12.2 Required Metadata

```
Page Class: Vector Page
Primary Governed Document: ATI_STANDARD.md
Secondary Governed Documents: TFO_ONTOLOGY.md, SCANNER_MODEL.md, INTERFACE_GOVERNANCE.md
```

---

### 12.3 Required Page Structure

```markdown
# {From State} → {To State}

## Transition Name
## Core Diagnostic Question
## Definition
## Why This Transition Matters
## Strong Signals
## Weak Signals
## ATI Scoring Dimensions
## Evidence Confidence Considerations
## Failure Modes Under This Vector
## Intervention Layers
## Scanner Relationship
## Related Vectors
## Reference Links
```

---

### 12.4 Required Vector Content

Every vector page must include:

- ATI vector ID,
- transition name,
- core question,
- strong signals,
- weak signals,
- scoring dimensions D1–D7,
- failure modes under that vector,
- links to all failure mode pages under the vector,
- link to Evidence Confidence,
- link to Scanner,
- link to ATI Standard,
- link to TFO Overview.

---

### 12.5 Required Components

- Transition Axis
- Vector Card
- Diagnostic Class Badge
- Evidence Confidence Badge
- Failure Mode Dossier Block
- Intervention Layer Tag
- Reference Link Cluster

---

### 12.6 Vector-Specific Requirements

**T1 — Attention → Interest**

Core question:

> Did visibility become curiosity?

Must link to:

- `/failure-modes/attention-noise/`
- `/failure-modes/vanity-reach/`
- `/failure-modes/audience-mismatch/`
- `/failure-modes/signal-decay/`
- `/failure-modes/message-blur/`

---

**T2 — Interest → Desire**

Core question:

> Did curiosity become preference?

Must link to:

- `/failure-modes/passive-engagement/`
- `/failure-modes/comparison-stall/`
- `/failure-modes/preference-dilution/`
- `/failure-modes/intent-evaporation/`
- `/failure-modes/value-ambiguity/`

Must state:

> Preference and intent are sub-signals inside T2, not separate transition vectors.

---

**T3 — Desire → Action**

Core question:

> Did intent become action?

Must link to:

- `/failure-modes/process-friction/`
- `/failure-modes/trust-deficit/`
- `/failure-modes/price-shock/`
- `/failure-modes/decision-delay/`
- `/failure-modes/complexity-wall/`
- `/failure-modes/objection-residue/`

---

**T4 — Action → Loyalty**

Core question:

> Did conversion become continuity?

Must link to:

- `/failure-modes/one-transaction-funnel/`
- `/failure-modes/silent-churn/`
- `/failure-modes/loyalty-blindness/`
- `/failure-modes/advocacy-vacuum/`
- `/failure-modes/lifecycle-disconnect/`

Must state:

> AIDAtanaly extends AIDA beyond Action because action without continuity is incomplete movement intelligence.

---

## 13. TFO Overview Page Blueprint

### 13.1 Purpose

The TFO overview page explains the Transition Failure Ontology as a system.

It must introduce TFO without duplicating every failure mode in full.

Route:

```
/transition-failure-ontology/
```

---

### 13.2 Required Metadata

```
Page Class: Ontology Page
Primary Governed Document: TFO_ONTOLOGY.md
Secondary Governed Documents: ATI_STANDARD.md, SCANNER_MODEL.md, ROUTE_MAP.md
```

---

### 13.3 Required Page Structure

```markdown
# Transition Failure Ontology

## Definition
## Why Failure Needs an Ontology
## Relationship to ATI
## T1 Failure Modes
## T2 Failure Modes
## T3 Failure Modes
## T4 Failure Modes
## Measurement Gap
## How Scanner Uses TFO
## Intervention Layer Relationship
## Public Claim Limits
## Full Failure Mode Index
```

---

### 13.4 Required Internal Links

The TFO page must link to:

- `/aida-transition-index/`
- all four vector pages,
- all 22 failure mode and diagnostic constraint pages,
- `/scanner/`
- `/intervention-layers/`
- `/methodology/`
- `/governance/`

---

## 14. Failure Mode Page Blueprint

### 14.1 Purpose

Failure mode pages are diagnostic reference dossiers.

They must not be generic advice pages.

Each failure mode page defines one governed TFO entry.

---

### 14.2 Required Metadata

```
Page Class: Failure Mode Page
Primary Governed Document: TFO_ONTOLOGY.md
Secondary Governed Documents: ATI_STANDARD.md, SCANNER_MODEL.md, ROUTE_MAP.md, INTERFACE_GOVERNANCE.md
```

---

### 14.3 Required Page Structure

```markdown
# {Failure Mode Name}

Stable ID:
Primary Vector:
Transition Name:
Canonical Route:
Diagnostic Class:

## Definition
## Core Diagnostic Question
## Why It Matters
## Symptoms
## Detection Signals
## Scoring Impact
## Evidence Confidence Considerations
## AI Instrumentation
## Intervention Layers
## Related Failure Modes
## Scanner Output Language
## Internal Links
## Version Notes
```

This structure is mandatory.

---

### 14.4 Required Components

- Stable ID Chip
- Failure Mode Dossier Block
- Diagnostic Class Badge
- Evidence Confidence Badge where relevant
- Intervention Layer Tag
- Reference Link Cluster
- Related Failure Mode Cluster

---

### 14.5 Required Content Rules

Every failure mode page must include:

- exact stable ID from `TFO_ONTOLOGY.md`,
- exact canonical route from `ROUTE_MAP.md`,
- parent vector,
- transition name,
- diagnostic class,
- definition,
- symptoms,
- detection signals,
- scoring impact,
- Evidence Confidence considerations,
- AI instrumentation limits,
- intervention layers,
- related failure modes,
- scanner output language,
- and internal links.

No failure mode page may introduce a new failure mode without governance.

---

### 14.6 Required Internal Links

Every failure mode page must link to:

- parent vector page,
- `/aida-transition-index/`,
- `/transition-failure-ontology/`,
- `/scanner/`,
- `/evidence-confidence/`,
- `/intervention-layers/`,
- at least two related failure modes where applicable,
- `/methodology/` or `/governance/`.

---

### 14.7 Failure Mode Claim Rules

Allowed:

> "This failure mode may indicate weak movement from Interest to Desire."

Allowed:

> "Evidence Confidence determines how strongly this diagnosis should be interpreted."

Prohibited:

> "This failure mode proves why revenue is falling."

Prohibited:

> "Fixing this failure mode guarantees conversion growth."

---

## 15. Measurement Gap Page Blueprint

### 15.1 Purpose

The Measurement Gap page explains a diagnostic constraint, not a normal failure mode.

Route:

```
/failure-modes/measurement-gap/
```

Stable ID:

```
tfo.constraint.measurement_gap
```

---

### 15.2 Required Page Structure

```markdown
# Measurement Gap

Stable ID:
Primary Classification:
Applies Across:
Canonical Route:

## Definition
## Why It Is Not a Normal Failure Mode
## Core Diagnostic Question
## Symptoms
## Detection Signals
## Evidence Confidence Impact
## E0 and Partial Profile Rule
## Scanner Output Language
## Intervention Layers
## Related Failure Modes
## Internal Links
```

---

### 15.3 Required Claim Rule

The page must state:

> Measurement Gap limits diagnostic confidence. It does not automatically prove that the transition is broken.

It must also state:

> If a vector is E0, Scanner v1 must not issue a numeric vector score, and if one or more vectors are E0, Scanner v1 must issue a Partial Profile rather than a clean composite ATI score.

---

## 16. Scanner Page Blueprint

### 16.1 Purpose

The scanner page hosts the public rules-governed diagnostic experience.

It must feel like a governed diagnostic system, not a marketing quiz.

Route:

```
/scanner/
```

---

### 16.2 Required Metadata

```
Page Class: Scanner Page
Primary Governed Document: SCANNER_MODEL.md
Secondary Governed Documents: ATI_STANDARD.md, TFO_ONTOLOGY.md, ROUTE_MAP.md, INTERFACE_GOVERNANCE.md
```

---

### 16.3 Required Page Structure

```markdown
# AIDAtanaly Transition Scanner

## What the Scanner Measures
## What the Scanner Does Not Claim
## Evidence Confidence Notice
## Transition Axis
## Step 1: Funnel Context
## Step 2: Measurement Availability
## Step 3: T1 — Attention → Interest
## Step 4: T2 — Interest → Desire
## Step 5: T3 — Desire → Action
## Step 6: T4 — Action → Loyalty
## Result Preview
## Methodology Links
## Report Upgrade Path
```

---

### 16.4 Required Scanner Disclosure

The scanner page must state:

> Scanner v1 is rules-governed. It does not require live analytics integrations and does not claim exact causality.

It must also state:

> Evidence Confidence qualifies how strongly a result should be interpreted.

---

### 16.5 Required Components

- Transition Axis
- Scanner Step Panel
- ATI Score Panel
- Evidence Confidence Badge
- Diagnostic Class Badge
- Failure Mode Dossier Block
- Reference Link Cluster

---

### 16.6 Scanner Page Prohibitions

The scanner page must not use:

- fear-based copy,
- fake urgency,
- revenue guarantees,
- "AI knows exactly" language,
- gamified score effects,
- hidden scoring logic,
- or intentionally weak free outputs.

---

## 17. Scanner Result View Blueprint

### 17.1 Purpose

Scanner result views display governed diagnostic output.

Dynamic result states must not become indexable public routes unless separately governed.

---

### 17.2 Required Result Structure

```markdown
# ATI Snapshot

## Composite Status
## Evidence Confidence Summary
## T1 Result
## T2 Result
## T3 Result
## T4 Result
## Weakest Vector
## Strongest Vector
## Likely Failure Modes
## Recommended Intervention Layers
## Reference Links
## Paid Diagnostic Brief Path
```

---

### 17.3 Required Full Score Output

If all vectors are scorable, the result may show:

```
Composite ATI: {score} — {diagnostic_class}
Composite Evidence Confidence: {confidence_summary}
```

---

### 17.4 Required Partial Profile Output

If one or more vectors are E0, the result must show:

```
ATI Profile: Partial
Scorable vectors: {list}
Unscorable vectors: {list} / E0 Absent Evidence
```

It must not show a clean composite ATI score.

---

### 17.5 Required Result Links

Every scanner result must link to:

- `/aida-transition-index/`
- `/evidence-confidence/`
- relevant vector pages,
- relevant failure mode pages,
- `/intervention-layers/`
- `/methodology/`

---

## 18. Report Page Blueprint

### 18.1 Purpose

Report pages explain free and paid outputs without degrading trust.

Examples:

- `/reports/ati-snapshot/`
- `/reports/transition-diagnostic-brief/`
- `/reports/advanced-transition-audit/`

---

### 18.2 Required Page Structure

```markdown
# {Report Name}

## What This Report Provides
## Who It Is For
## What It Includes
## What It Does Not Claim
## Evidence Confidence Treatment
## Relationship to Scanner
## Relationship to ATI and TFO
## Example Output Sections
## Pricing or Access Model
## Trust and Limits
```

---

### 18.3 Monetization Rules

Allowed monetization:

- diagnostic briefs,
- structured reports,
- audit intake,
- API access later,
- licensing later.

Prohibited monetization:

- fake urgency,
- fear-based upsells,
- generic affiliate banners,
- paid rankings,
- guaranteed outcomes,
- hiding basic definitions behind payment.

---

## 19. Methodology Page Blueprint

### 19.1 Purpose

The methodology page explains how AIDAtanaly works in public language.

Route:

```
/methodology/
```

---

### 19.2 Required Page Structure

```markdown
# Methodology

## Governing Thesis
## Why Transitions Matter
## How ATI Scores Movement
## How Evidence Confidence Works
## How TFO Classifies Failure
## How Scanner v1 Produces Output
## What the System Does Not Claim
## Versioning and Governance
## Related Reference Pages
```

---

### 19.3 Required Links

The methodology page must link to:

- `/aida-transition-analytics/`
- `/aida-transition-index/`
- `/evidence-confidence/`
- `/transition-failure-ontology/`
- `/scanner/`
- `/governance/`
- `/sources/`

---

## 20. Governance Page Blueprint

### 20.1 Purpose

The governance page explains how AIDAtanaly maintains trust, versioning, source restraint, claim limits, and reference discipline.

Route:

```
/governance/
```

---

### 20.2 Required Page Structure

```markdown
# Governance

## Why Governance Exists
## Governed Documents
## Versioning Principle
## Decision Logs
## Claim Restraint
## Evidence Confidence
## Route Governance
## Interface Governance
## Scanner Governance
## Public Limits
## Related Trust Pages
```

---

### 20.3 Required Governance Statement

The page must state:

> AIDAtanaly uses sequential document versioning. Change severity is recorded in decision logs and is not encoded directly into the version number.

---

### 20.4 Required Links

The governance page must link to:

- `/methodology/`
- `/sources/`
- `/claims-policy/` when public,
- `/versioning/` when public,
- `/privacy/`
- `/terms/`
- `/aida-transition-index/`
- `/transition-failure-ontology/`

---

## 21. Sources Page Blueprint

### 21.1 Purpose

The sources page explains source posture and reference limits.

Route:

```
/sources/
```

AIDAtanaly must not pretend to have external benchmark authority before evidence exists.

---

### 21.2 Required Page Structure

```markdown
# Sources and Reference Posture

## Source Policy
## Internal Standards
## External References
## What Is Governed Internally
## What Requires External Evidence
## Claim Limits
## Update Policy
## Related Governance Pages
```

---

### 21.3 Required Claim Rule

The sources page must state:

> AIDAtanaly may introduce governed internal standards before market adoption, but it must not describe them as adopted industry standards unless adoption evidence exists.

---

## 22. Privacy and Terms Page Blueprint

### 22.1 Privacy Page Purpose

The privacy page must explain how scanner inputs are handled.

Route:

```
/privacy/
```

Required sections:

```markdown
# Privacy

## What Data May Be Entered
## How Scanner Inputs Are Used
## What Is Not Required
## No Sensitive Data Requirement
## Future Report Handling
## Contact or Inquiry Path
```

---

### 22.2 Terms Page Purpose

The terms page must define use limits.

Route:

```
/terms/
```

Required sections:

```markdown
# Terms

## Use of the Site
## Diagnostic Nature of Scanner
## No Guarantee
## No Professional Advice Warranty
## Intellectual Property
## Report Use
## Changes to Terms
```

---

## 23. Buyer Page Blueprint

### 23.1 Purpose

Buyer pages are deferred until buyer-facing posture is activated.

Examples:

- `/buyer-logic/`
- `/for-martech-platforms/`
- `/for-agencies/`
- `/licensing/`
- `/availability/`

Buyer pages must not sound like domain flipping.

They must frame AIDAtanaly as:

- category language,
- measurement standard,
- failure ontology,
- scanner engine,
- reference architecture,
- interface system,
- and acquisition-ready category artifact.

---

### 23.2 Required Page Structure

```markdown
# {Buyer Page Topic}

## Strategic Context
## What AIDAtanaly Owns
## Why This Category Matters
## Asset Components
## Integration Potential
## Monetization Potential
## Buyer Logic
## What Is Not Being Claimed
## Inquiry Boundary
```

---

### 23.3 Buyer Page Prohibitions

Buyer pages must not include:

- desperate sale language,
- inflated traffic claims,
- fake urgency,
- unrealistic valuation claims,
- competitor attacks,
- or unsupported adoption claims.

---

## 24. Data Reference Page Blueprint

### 24.1 Purpose

Data reference pages explain future machine-readable endpoints.

Examples:

- `/data/ati-standard.json`
- `/data/ati-vectors.json`
- `/data/tfo-failure-modes.json`
- `/data/intervention-layers.json`
- `/data/scanner-model.json`

These are data endpoints, not content pages.

A human-readable explanation may exist under a trust or methodology route, but JSON endpoints must match public definitions.

---

### 24.2 Data Endpoint Rules

Data endpoints must:

- use stable IDs,
- match public definitions,
- preserve canonical routes,
- include version fields,
- avoid hidden contradictory logic,
- and remain consistent with ratified Markdown standards.

---

## 25. SEO Blueprint Rules

AIDAtanaly SEO must emerge from reference authority.

Allowed SEO behavior:

- precise titles,
- unique meta descriptions,
- canonical definitions,
- structured headings,
- durable URLs,
- internal links,
- glossary support where useful,
- scanner-linked pages,
- ontology-driven pages,
- and schema-friendly content.

Prohibited SEO behavior:

- pages created only for search volume,
- AI-generated bulk pages without governance,
- keyword stuffing,
- duplicate page bodies,
- unrelated MarTech trend posts,
- tool-list affiliate pages,
- unsupported benchmark pages,
- and thin pages published before meaning exists.

---

## 26. Schema and Structured Data Guidance

Where appropriate, pages may use structured data.

Allowed schema types may include:

- `WebPage`
- `Article`
- `DefinedTerm`
- `FAQPage`
- `SoftwareApplication` for scanner page, if appropriate
- `Dataset` for data endpoints, if appropriate

Structured data must not claim:

- ratings that do not exist,
- reviews that do not exist,
- organization facts that are not true,
- product status that is not public,
- or industry adoption that has not occurred.

Structured data must reflect visible page content.

---

## 27. Page Production Quality Gate

Before any public page is released, it must pass this quality gate.

### 27.1 Route Checks

- route exists in `ROUTE_MAP.md`,
- route status permits publication,
- canonical URL is present,
- no duplicate route purpose,
- no orphan status.

### 27.2 Content Checks

- page follows the correct blueprint,
- page has one clear definition,
- page has no filler,
- page uses governed terminology,
- page avoids prohibited claims,
- page links to governing pages.

### 27.3 Interface Checks

- page follows `INTERFACE_GOVERNANCE.md`,
- page is readable without JavaScript,
- components are reused consistently,
- motion is not required for comprehension,
- Evidence Confidence is visually separate where present.

### 27.4 Link Checks

- all required links exist,
- no link points to missing public page,
- no deferred route is linked as live unless implemented,
- sitemap includes only existing public routes.

### 27.5 Scanner Compatibility Checks

Where relevant:

- failure mode pages use TFO IDs,
- vector pages use ATI vector names,
- scanner outputs can link to the page,
- page language supports controlled output.

---

## 28. Launch Page Production Order

The 41 Required Launch routes should not be produced randomly.

Recommended order:

1. Homepage
2. Core category routes
3. ATI standard routes
4. Vector routes
5. TFO overview
6. Failure mode pages
7. Scanner page
8. ATI Snapshot report page
9. Methodology
10. Governance
11. Sources
12. Privacy
13. Terms

Failure mode pages may be produced in vector groups:

- T1 group
- T2 group
- T3 group
- T4 group
- Measurement Gap

This preserves internal link integrity.

---

## 29. Minimum Viable Preview Rule

AIDAtanaly may not publicly launch an indexed reference release with isolated pages that do not form the complete governed launch architecture.

The Required Launch route set defined in `ROUTE_MAP.md` remains the governing requirement for the first public indexed reference release.

Therefore, the first public indexed reference release must include the full 41-route Required Launch set.

A smaller page set may exist only as a Minimum Viable Preview under one of the following conditions:

- private preview,
- internal review,
- staging environment,
- soft launch with `noindex`,
- or controlled non-indexed demonstration.

A Minimum Viable Preview is not a substitute for the first public reference release.

A Minimum Viable Preview must include at minimum:

- homepage,
- primary category page,
- ATI page,
- all four vector pages,
- TFO overview,
- at least one complete vector group of failure mode pages,
- scanner page or scanner preview,
- methodology page,
- governance page,
- sources page,
- privacy page,
- terms page.

The preferred and required indexed public launch remains the complete 41-route set defined in `ROUTE_MAP.md`.

No incomplete preview may be submitted for public indexation as the official first reference release.

---

## 30. Page Versioning

Pages may include visible or hidden version metadata.

Recommended page version metadata:

```
Page Version:
Last Updated:
Governed by:
Canonical Route:
Stable ID where applicable:
```

Failure mode pages should include stable ID visibly.

Standard and methodology pages may include version notes where useful.

---

## 31. Future Automation Compatibility

This standard prepares future automated page generation, but automation must remain governed.

No automated page builder may create pages outside:

- `ROUTE_MAP.md`,
- `TFO_ONTOLOGY.md`,
- `ATI_STANDARD.md`,
- `SCANNER_MODEL.md`,
- and this `PAGE_BLUEPRINTS.md`.

Future automation must validate:

- route ID,
- page class,
- required sections,
- internal links,
- stable IDs,
- canonical URLs,
- metadata,
- and prohibited claims.

Automation without governance is prohibited.

---

## 32. Governance and Change Control

Page Blueprint Standard v1.0 is versioned.

AIDAtanaly uses sequential document versioning.

Change severity is recorded in the decision log as Patch Change, Minor Change, or Major Change and is not encoded directly into the version number.

### 32.1 Patch Change

Examples:

- typo correction,
- section label clarification,
- minor copy guidance update.

### 32.2 Minor Change

Examples:

- adding a section to an existing blueprint,
- adding a non-required component,
- adding a new optional page class,
- adding a new schema guidance note.

### 32.3 Major Change

Examples:

- changing required sections for failure mode pages,
- changing launch page requirements,
- changing universal page requirements,
- changing scanner result page requirements,
- changing route-to-blueprint mapping,
- allowing thin pages,
- removing required internal link rules.

Major changes require:

- decision log entry,
- version update,
- compatibility statement,
- route impact statement,
- page production impact statement,
- and scanner impact statement where applicable.

---

## 33. Closing Page Blueprint Declaration

AIDAtanaly cannot become a category artifact through routes alone.

Routes define where meaning lives.

Blueprints define how meaning is built.

Every page must carry the doctrine.

Every section must serve the system.

Every internal link must strengthen the reference graph.

Every scanner output must resolve into a governed page.

Every interface pattern must make transition intelligence visible.

This standard prevents AIDAtanaly from becoming a generic website.

It turns page production into governed asset construction.

> Stages are states. Value lives in transitions.

---

**AIDAtanaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.**
