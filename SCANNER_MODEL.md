# SCANNER_MODEL.md

## AIDAtanaly.com — Transition Scanner v1 Model

**Document Class:** Operational Scanner Model
**Layer:** 6 — Diagnostic Engine Layer
**Asset:** AIDAtanaly.com
**Governed by:** FOUNDATION_DOCTRINE.md, ASSET_THESIS.md, ATI_STANDARD.md, TFO_ONTOLOGY.md, ROUTE_MAP.md, and INTERFACE_GOVERNANCE.md
**Status:** Ratified
**Version:** 1.0
**Date:** 2026-06-12
**Ratified by:** Sohadot — System Operator

---

## 1. Purpose of This Scanner Model

This document defines the first operational diagnostic model for the AIDAtanaly Transition Scanner.

The scanner converts AIDAtanaly's doctrine, standard, ontology, route architecture, and interface governance into a usable diagnostic experience.

The governing doctrine states:

> Stages are states. Value lives in transitions.

The scanner operationalizes that doctrine by evaluating movement across the four ATI vectors:

- T1 — Attention → Interest
- T2 — Interest → Desire
- T3 — Desire → Action
- T4 — Action → Loyalty

The scanner does not diagnose generic marketing performance.

It diagnoses transition health.

---

## 2. Scanner v1 Operating Principle

Scanner v1 is a rules-governed diagnostic engine.

It does not require live analytics integrations.

It does not claim exact causality.

It does not claim guaranteed revenue improvement.

It uses structured inputs, governed scoring dimensions, Evidence Confidence qualifiers, and TFO failure-mode mappings to produce a controlled diagnostic output.

The scanner must answer four operational questions:

1. Which transition is strongest?
2. Which transition is weakest?
3. What class of failure is likely present?
4. What intervention layer is indicated?

---

## 3. Governing Dependencies

Scanner v1 must comply with the following documents.

| Governing Document | Scanner Dependency |
|---|---|
| `FOUNDATION_DOCTRINE.md` | Scanner must measure transitions, not stages |
| `ASSET_THESIS.md` | Scanner must support the Category Intelligence Factory model |
| `ATI_STANDARD.md` | Scanner must use D1–D7 dimensions and E0–E4 Evidence Confidence |
| `TFO_ONTOLOGY.md` | Scanner failure modes must use TFO-governed IDs |
| `ROUTE_MAP.md` | Scanner outputs must link to canonical pages |
| `INTERFACE_GOVERNANCE.md` | Scanner UI must embody Flow Made Visible |

No scanner output may contradict these documents.

---

## 4. Scanner v1 Scope

Scanner v1 supports:

- self-guided diagnostic assessment,
- transition-vector scoring,
- Evidence Confidence qualification,
- failure-mode classification,
- intervention-layer recommendation,
- reference-page linking,
- free ATI Snapshot output,
- future paid diagnostic brief intake.

Scanner v1 does not support:

- automatic analytics ingestion,
- CRM integration,
- predictive revenue modeling,
- causal proof,
- benchmark claims,
- guarantee language,
- or fully automated enterprise audit.

Scanner v1 is intentionally controlled.

It is designed to build trust before complexity.

---

## 5. Scanner Input Categories

Scanner v1 uses six input categories.

| Input Category | Purpose |
|---|---|
| Funnel Context | Understand the user's business model and funnel type |
| Measurement Availability | Determine Evidence Confidence |
| T1 Signal Inputs | Evaluate Attention → Interest movement |
| T2 Intent Inputs | Evaluate Interest → Desire movement |
| T3 Action Inputs | Evaluate Desire → Action movement |
| T4 Loyalty Inputs | Evaluate Action → Loyalty movement |

The scanner may ask fewer questions in a simplified version, but every output must preserve the same governed logic.

---

## 6. Answer Scale

Scanner v1 uses a five-point answer scale.

| Answer Value | Label | Score Equivalent |
|---|---|---|
| 0 | No / Absent / Not tracked | 0 |
| 1 | Weak | 25 |
| 2 | Partial | 50 |
| 3 | Moderate | 75 |
| 4 | Strong | 100 |

The score equivalent is used to calculate dimension-level and vector-level scores.

If the answer is unknown because the signal is not measured, this affects Evidence Confidence.

It must not be hidden inside a false score.

---

## 7. Evidence Confidence Model

Evidence Confidence is mandatory.

It must be reported separately from ATI score.

Evidence Confidence never changes the score mathematically.

| Level | Name | Scanner Meaning |
|---|---|---|
| E0 | Absent Evidence | Required evidence is missing; no numeric score should be issued |
| E1 | Self-Reported Evidence | Mainly based on user perception or belief |
| E2 | Observable Evidence | Based on visible metrics, reports, or observed behavior |
| E3 | Multi-Source Evidence | Based on multiple connected evidence sources |
| E4 | Validated Evidence | Based on repeated, tracked, verified data patterns |

---

## 8. Evidence Confidence Assignment Rules

Evidence Confidence is assigned per vector.

### 8.1 E0 Rule

Assign E0 when the user cannot provide meaningful evidence for the vector.

E0 output:

```
T3: Unscorable / E0 Absent Evidence
```

E0 must not display a numeric score.

---

### 8.2 E1 Rule

Assign E1 when answers are mainly based on judgment, memory, belief, or unverified observation.

Output language must be provisional.

Example:

```
T2 Score: 46 / E1 Self-Reported Evidence
```

---

### 8.3 E2 Rule

Assign E2 when the user references visible metrics, analytics dashboards, reports, observable behavior, or consistent operational evidence.

Output language must be indicative.

Example:

```
T1 Score: 72 / E2 Observable Evidence
```

---

### 8.4 E3 Rule

Assign E3 when multiple evidence sources support the vector.

Examples:

- analytics + CRM,
- ad data + site behavior,
- sales data + lifecycle metrics,
- cohort data + retention data.

---

### 8.5 E4 Rule

Assign E4 only when evidence is tracked, repeated, validated, and stable over time.

E4 does not permit guarantee language.

It only allows stronger confidence in interpretation.

---

## 9. Scoring Dimensions

Each vector is scored using the seven ATI dimensions.

| Dimension | Weight | Meaning |
|---|---|---|
| D1 — Signal Quality | 17% | Strength and meaning of the signal |
| D2 — Movement Probability | 23% | Likelihood of transition |
| D3 — Transition Velocity | 11% | Speed and efficiency of movement |
| D4 — Friction Resilience | 17% | Ability to withstand obstacles |
| D5 — Drop-Off Resilience | 12% | Resistance to abandonment |
| D6 — Commercial Consequence | 10% | Business value of the movement |
| D7 — Intervention Clarity | 10% | Clarity of corrective action |

Vector score formula:

```
Vector Score =
(D1 × 0.17) +
(D2 × 0.23) +
(D3 × 0.11) +
(D4 × 0.17) +
(D5 × 0.12) +
(D6 × 0.10) +
(D7 × 0.10)
```

All dimensions are positive-direction.

Higher score means stronger transition health.

---

## 10. Composite ATI Score

The composite ATI score is calculated as:

```
ATI = (T1 + T2 + T3 + T4) / 4
```

Default v1 uses equal vector weighting.

If one or more vectors are E0 and therefore unscorable, the scanner must not issue a clean full ATI score.

Allowed output:

```
ATI Profile: Partial
Scorable vectors: T1, T2, T3
Unscorable vector: T4 / E0 Absent Evidence
```

Prohibited output:

```
ATI Score: 61.5
```

when T4 is E0.

---

## 11. Diagnostic Classes

The scanner must use the ATI diagnostic class thresholds exactly.

| Score Range | Diagnostic Class |
|---|---|
| 85–100 | Transition Strong |
| 70–84 | Transition Functional |
| 55–69 | Transition Unstable |
| 40–54 | Transition Constrained |
| 0–39 | Transition Critical |

These classes must match both `ATI_STANDARD.md` and `INTERFACE_GOVERNANCE.md`.

---

## 12. Funnel Context Questions

Funnel context questions do not directly score ATI.

They shape interpretation, language, and intervention priority.

| Question ID | Question | Purpose |
|---|---|---|
| `ctx.business_model` | What type of business is being assessed? | Adjust interpretation context |
| `ctx.primary_goal` | What is the main conversion goal? | Clarify Action definition |
| `ctx.sales_cycle` | Is the decision fast, medium, or long-cycle? | Interpret velocity |
| `ctx.channel_mix` | What are the main acquisition channels? | Interpret T1 and T2 signals |
| `ctx.transaction_type` | Is the model one-time, recurring, subscription, or enterprise? | Interpret T4 |
| `ctx.measurement_stack` | What tools are used to measure funnel behavior? | Support Evidence Confidence |

Allowed business model values:

```
ecommerce
saas
subscription
agency
b2b_service
marketplace
lead_generation
creator_business
education
enterprise_sales
other
```

---

## 13. Measurement Availability Questions

These questions determine Evidence Confidence.

| Question ID | Question | Evidence Impact |
|---|---|---|
| `ev.analytics` | Do you have analytics data for traffic and engagement? | Supports T1/T2 evidence |
| `ev.conversion_tracking` | Do you track conversions or key actions? | Supports T3 evidence |
| `ev.crm_or_leads` | Do you track leads, sales stages, or CRM progression? | Supports T2/T3 evidence |
| `ev.retention` | Do you track repeat purchase, retention, churn, or usage? | Supports T4 evidence |
| `ev.source_linkage` | Can you connect acquisition source to downstream value? | Supports E3/E4 |
| `ev.time_window` | Is the data recent, repeated, and stable? | Supports E3/E4 |

Evidence logic:

- no evidence = E0,
- user belief only = E1,
- one observable source = E2,
- multiple connected sources = E3,
- validated repeated data = E4.

---

## 14. T1 Question Model

**Attention → Interest**

T1 measures whether visibility becomes meaningful engagement.

Core question:

> Did visibility become curiosity?

| Question ID | Question | Dimension | Primary Failure Mode Signals |
|---|---|---|---|
| `t1.q1.signal_quality` | Do your impressions, reach, or traffic produce qualified engagement? | D1 | Attention Noise, Vanity Reach |
| `t1.q2.audience_fit` | Are the people you reach aligned with your actual offer or buyer profile? | D1 | Audience Mismatch |
| `t1.q3.movement_probability` | Do users continue beyond first exposure into meaningful content or product exploration? | D2 | Signal Decay, Message Blur |
| `t1.q4.velocity` | Does interest form quickly after first exposure? | D3 | Signal Decay |
| `t1.q5.friction_resilience` | Is the first landing experience clear enough to avoid confusion? | D4 | Message Blur |
| `t1.q6.dropoff_resilience` | Do users avoid immediate bounce or early abandonment? | D5 | Attention Noise, Signal Decay |
| `t1.q7.commercial_consequence` | Does T1 traffic contribute to downstream commercial movement? | D6 | Vanity Reach, Audience Mismatch |
| `t1.q8.intervention_clarity` | Can you identify which channel, audience, or message causes weak engagement? | D7 | Measurement Gap, Message Blur |

**T1 Failure Mode Mapping**

| Failure Mode | Trigger Pattern |
|---|---|
| `tfo.t1.attention_noise` | High visibility, weak qualified engagement |
| `tfo.t1.vanity_reach` | Large reach with little commercial movement |
| `tfo.t1.audience_mismatch` | Wrong traffic or poor buyer fit |
| `tfo.t1.signal_decay` | Initial attention fades before interest forms |
| `tfo.t1.message_blur` | Users do not understand why the offer matters |

---

## 15. T2 Question Model

**Interest → Desire**

T2 measures whether curiosity becomes preference, intent, motivation, or commercial desire.

Core question:

> Did curiosity become preference?

| Question ID | Question | Dimension | Primary Failure Mode Signals |
|---|---|---|---|
| `t2.q1.signal_quality` | Does engagement show real interest rather than passive consumption? | D1 | Passive Engagement |
| `t2.q2.preference_signal` | Do users compare, save, revisit, inquire, or show preference-building behavior? | D2 | Comparison Stall, Preference Dilution |
| `t2.q3.velocity` | Does interest become intent within a reasonable time for your business model? | D3 | Intent Evaporation |
| `t2.q4.friction_resilience` | Is your value proposition clear enough to support desire? | D4 | Value Ambiguity |
| `t2.q5.dropoff_resilience` | Do interested users continue instead of fading away? | D5 | Intent Evaporation |
| `t2.q6.commercial_consequence` | Does engaged traffic produce qualified leads, sales movement, or high-value actions? | D6 | Passive Engagement, Preference Dilution |
| `t2.q7.intervention_clarity` | Can you identify whether weak desire is caused by value, proof, comparison, or timing? | D7 | Value Ambiguity, Comparison Stall |
| `t2.q8.intent_depth` | Do users move from learning to wanting? | D2 | Passive Engagement, Value Ambiguity |

**T2 Failure Mode Mapping**

| Failure Mode | Trigger Pattern |
|---|---|
| `tfo.t2.passive_engagement` | Users consume content but do not form commercial intent |
| `tfo.t2.comparison_stall` | Users evaluate repeatedly without choosing |
| `tfo.t2.preference_dilution` | Offer does not become preferred against alternatives |
| `tfo.t2.intent_evaporation` | Early intent fades before action |
| `tfo.t2.value_ambiguity` | Users understand the category but not why this offer matters |

---

## 16. T3 Question Model

**Desire → Action**

T3 measures whether intent becomes completed action.

Core question:

> Did intent become action?

| Question ID | Question | Dimension | Primary Failure Mode Signals |
|---|---|---|---|
| `t3.q1.signal_quality` | Are high-intent signals clearly visible before action? | D1 | Decision Delay, Objection Residue |
| `t3.q2.movement_probability` | Do users who show intent complete the next step? | D2 | Process Friction, Trust Deficit |
| `t3.q3.velocity` | Does action happen without excessive delay after intent forms? | D3 | Decision Delay |
| `t3.q4.friction_resilience` | Is the action path simple, credible, and low-friction? | D4 | Process Friction, Complexity Wall |
| `t3.q5.dropoff_resilience` | Do users avoid abandoning forms, carts, demos, bookings, or checkout? | D5 | Process Friction, Price Shock |
| `t3.q6.commercial_consequence` | Does completed action create meaningful business value? | D6 | Price Shock, Trust Deficit |
| `t3.q7.intervention_clarity` | Can you identify whether action is blocked by trust, price, UX, complexity, or objections? | D7 | Trust Deficit, Objection Residue |
| `t3.q8.risk_reversal` | Are risk, proof, guarantee, or credibility concerns handled before action? | D4 | Trust Deficit, Objection Residue |

**T3 Failure Mode Mapping**

| Failure Mode | Trigger Pattern |
|---|---|
| `tfo.t3.process_friction` | Action path is too hard, long, unclear, or broken |
| `tfo.t3.trust_deficit` | Desire exists but trust is insufficient |
| `tfo.t3.price_shock` | Price exposure collapses movement |
| `tfo.t3.decision_delay` | Intent exists but urgency is weak |
| `tfo.t3.complexity_wall` | User cannot cross complexity threshold |
| `tfo.t3.objection_residue` | Unresolved doubts block action |

---

## 17. T4 Question Model

**Action → Loyalty**

T4 measures whether completed action becomes continuity, repeat value, retention, loyalty, or advocacy.

Core question:

> Did conversion become continuity?

| Question ID | Question | Dimension | Primary Failure Mode Signals |
|---|---|---|---|
| `t4.q1.signal_quality` | Do post-action behaviors show continuity, not only completion? | D1 | One-Transaction Funnel |
| `t4.q2.movement_probability` | Do customers return, repeat, continue, activate, or expand? | D2 | Silent Churn, Lifecycle Disconnect |
| `t4.q3.velocity` | Does the relationship continue soon enough after first action? | D3 | Lifecycle Disconnect |
| `t4.q4.friction_resilience` | Is onboarding or post-action experience clear and supportive? | D4 | Lifecycle Disconnect |
| `t4.q5.dropoff_resilience` | Do customers avoid disappearing after first action? | D5 | Silent Churn, One-Transaction Funnel |
| `t4.q6.commercial_consequence` | Does loyalty generate repeat value, lifetime value, referral, or advocacy? | D6 | Advocacy Vacuum, Loyalty Blindness |
| `t4.q7.intervention_clarity` | Can you identify what prevents repeat value or loyalty? | D7 | Loyalty Blindness, Measurement Gap |
| `t4.q8.advocacy_signal` | Do satisfied customers produce proof, referral, review, or public trust signals? | D6 | Advocacy Vacuum |

**T4 Failure Mode Mapping**

| Failure Mode | Trigger Pattern |
|---|---|
| `tfo.t4.one_transaction_funnel` | First action happens, continuity does not |
| `tfo.t4.silent_churn` | Users disappear without visible alarm |
| `tfo.t4.loyalty_blindness` | First conversion is measured, loyalty is not |
| `tfo.t4.advocacy_vacuum` | Loyalty does not become market-facing proof |
| `tfo.t4.lifecycle_disconnect` | Post-action relationship lacks structure |

---

## 18. Measurement Gap Mapping

Measurement Gap is a cross-vector diagnostic constraint.

Stable ID:

```
tfo.constraint.measurement_gap
```

Measurement Gap is assigned when the scanner cannot confidently score or interpret a transition because required evidence is missing.

Measurement Gap affects Evidence Confidence.

It does not directly reduce ATI score.

Examples:

- T4 cannot be scored because retention is not tracked.
- T2 is provisional because desire signals are not measured.
- T3 action completion is known, but reasons for abandonment are unknown.
- T1 traffic exists, but quality is not segmented.

Allowed language:

> Measurement Gap limits the confidence of this diagnosis.

Prohibited language:

> No data proves that this transition is broken.

---

## 19. Failure Mode Assignment Logic

Failure modes are assigned using pattern strength.

Each failure mode receives a pattern score based on answers mapped to that mode.

### 19.1 Pattern Strength Levels

| Pattern Score | Assignment Strength |
|---|---|
| 0–24 | Not assigned |
| 25–49 | Weak signal |
| 50–69 | Possible failure mode |
| 70–84 | Likely failure mode |
| 85–100 | Dominant failure mode |

Scanner v1 should normally output:

- one primary failure mode per weak vector,
- one or two secondary failure modes where evidence supports them,
- Measurement Gap where evidence is insufficient.

Scanner v1 must not output too many failure modes.

Over-diagnosis weakens trust.

---

## 20. Intervention Layer Mapping

Every assigned failure mode must map to approved intervention layers.

Approved layers:

| Intervention Layer | Scanner Use |
|---|---|
| Audience Intervention | Reach, segmentation, fit |
| Message Intervention | Clarity, positioning, promise |
| Offer Intervention | Value, packaging, proposition |
| Proof Intervention | Trust, authority, review, credibility |
| UX Intervention | Path, friction, interface, flow |
| Pricing Intervention | Price framing, clarity, risk |
| Timing Intervention | Follow-up, urgency, sequence |
| Attribution Intervention | Measurement visibility |
| Lifecycle Intervention | Retention, onboarding, loyalty |
| Sales-Assist Intervention | Human or automated help at high-friction points |

Contextual labels such as Channel Intervention and Measurement Governance are not standalone layers.

They must map to their approved parent layer.

---

## 21. Output Model

Scanner v1 must produce a governed output.

Required output fields:

- Composite ATI status
- T1 vector result
- T2 vector result
- T3 vector result
- T4 vector result
- Weakest vector
- Strongest vector
- Evidence Confidence per vector
- Primary failure mode
- Secondary failure mode where applicable
- Recommended intervention layer
- Reference links

If all vectors are scorable, the scanner may issue a composite ATI score.

If one or more vectors are E0, the scanner must issue a partial profile.

---

## 22. Output Language Rules

Scanner outputs must use controlled language.

Allowed:

> Your weakest vector is T2 — Interest → Desire.
> The likely failure mode is Value Ambiguity.
> This diagnosis is based on E1 Self-Reported Evidence and should be treated as provisional.

Allowed:

> T3 appears Transition Constrained. The strongest signal points to Process Friction and Trust Deficit.

Prohibited:

> Your funnel is broken.

Prohibited:

> AI knows exactly why you are losing money.

Prohibited:

> Fixing this will increase revenue by 40%.

The scanner must diagnose without overclaiming.

---

## 23. Scanner Result Structure

Recommended human-readable output:

```
ATI Snapshot

Composite ATI: 56.25 — Transition Unstable
Composite Evidence Confidence: Mixed E1–E2

T1 — Attention → Interest
Score: 76 / E2 Observable Evidence
Class: Transition Functional
Likely Failure Mode: Signal Decay
Recommended Intervention: Message Intervention

T2 — Interest → Desire
Score: 48 / E2 Observable Evidence
Class: Transition Constrained
Likely Failure Modes: Comparison Stall + Value Ambiguity
Recommended Intervention: Offer Intervention + Proof Intervention

T3 — Desire → Action
Score: 62 / E1 Self-Reported Evidence
Class: Transition Unstable
Likely Failure Mode: Process Friction
Recommended Intervention: UX Intervention

T4 — Action → Loyalty
Score: 39 / E1 Self-Reported Evidence
Class: Transition Critical
Likely Failure Mode: One-Transaction Funnel
Recommended Intervention: Lifecycle Intervention
```

---

## 24. Agent-Readable Output Structure

Future JSON outputs must separate score, confidence, failure modes, and references.

Example:

```json
{
  "scanner_version": "1.0",
  "asset": "AIDAtanaly.com",
  "composite": {
    "score": 56.25,
    "diagnostic_class": "Transition Unstable",
    "evidence_confidence": "Mixed E1-E2"
  },
  "vectors": [
    {
      "vector_id": "ati.vector.t2",
      "transition": "Interest → Desire",
      "score": 48,
      "diagnostic_class": "Transition Constrained",
      "evidence_confidence": {
        "level": "E2",
        "name": "Observable Evidence"
      },
      "failure_modes": [
        {
          "id": "tfo.t2.comparison_stall",
          "name": "Comparison Stall",
          "canonical_route": "/failure-modes/comparison-stall/"
        },
        {
          "id": "tfo.t2.value_ambiguity",
          "name": "Value Ambiguity",
          "canonical_route": "/failure-modes/value-ambiguity/"
        }
      ],
      "intervention_layers": [
        "Offer Intervention",
        "Proof Intervention"
      ],
      "reference_links": [
        "/vectors/interest-to-desire/",
        "/aida-transition-index/",
        "/transition-failure-ontology/",
        "/evidence-confidence/"
      ]
    }
  ]
}
```

Incorrect structure:

```json
{
  "score": 48,
  "evidence_confidence_weight": 0.10
}
```

Evidence Confidence is metadata about reliability.

It is not a score component.

---

## 25. Scanner UI Governance

Scanner UI must comply with `INTERFACE_GOVERNANCE.md`.

Required interface principles:

- show the transition axis,
- represent T1–T4 as movement,
- show score and Evidence Confidence separately,
- show E0 as Unscorable,
- do not make weak scores visually healthy,
- do not use gamified score effects,
- do not use decorative animation,
- support reduced motion,
- keep results readable without hidden interactions.

The scanner must feel like a governed diagnostic system, not a quiz.

---

## 26. Reference Linking Requirements

Every scanner result must link to canonical routes.

Required links:

| Output Element | Required Link |
|---|---|
| ATI score | `/aida-transition-index/` |
| Evidence Confidence | `/evidence-confidence/` |
| TFO failure mode | `/failure-modes/{slug}/` |
| Vector name | `/vectors/{vector-route}/` |
| Intervention layer | `/intervention-layers/` |
| Measurement Gap | `/failure-modes/measurement-gap/` |
| Method explanation | `/methodology/` |

No scanner output may mention a failure mode without linking to its canonical page once public pages exist.

---

## 27. Monetization Boundary

Scanner v1 may support monetization, but monetization must not degrade trust.

Allowed monetization paths:

- free ATI Snapshot,
- paid Transition Diagnostic Brief,
- advanced Transition Audit intake,
- downloadable structured report,
- professional audit request,
- future API access,
- future licensing path.

Prohibited monetization paths:

- fear-based manipulation,
- fake urgency,
- guaranteed revenue claims,
- paid ranking of tools,
- generic affiliate banners,
- selling unqualified leads,
- hiding basic explanation behind payment,
- overstating diagnosis to force purchase.

The free scanner must provide real value.

Paid outputs must deepen diagnosis, not repair intentionally weakened free output.

---

## 28. Quality Gate Requirements

Before public release, Scanner v1 must pass the following checks.

### 28.1 Scoring Checks

- D1–D7 weights total 100%.
- Vector weights total 100%.
- Evidence Confidence is not included in score.
- E0 does not output numeric score.
- Diagnostic class thresholds match ATI Standard.
- Composite score is not issued when any vector is E0.

### 28.2 Ontology Checks

- Every failure mode ID exists in `TFO_ONTOLOGY.md`.
- Every failure mode has canonical route in `ROUTE_MAP.md`.
- Measurement Gap is treated as diagnostic constraint.
- No unsupported failure mode is assigned.

### 28.3 Interface Checks

- Score and Evidence Confidence are visually separate.
- Reduced-motion mode is supported.
- Scanner can be understood without decorative motion.
- Output does not look gamified.
- Result language does not overclaim.

### 28.4 Link Checks

- All vector links exist.
- All failure mode links exist.
- Evidence Confidence link exists.
- Intervention Layers link exists.
- Scanner output does not link to deferred or missing public pages.

---

## 29. Public Claim Rules

Allowed:

> "The AIDAtanaly Transition Scanner provides a rules-governed diagnostic profile of AIDA transition health."

Allowed:

> "Scanner outputs are based on ATI scoring dimensions, Evidence Confidence, and TFO failure-mode mappings."

Allowed:

> "The scanner helps identify where movement weakens between AIDA states."

Prohibited:

> "The scanner proves why your revenue is falling."

Prohibited:

> "The scanner guarantees conversion growth."

Prohibited:

> "The scanner is an industry-standard AI benchmark."

Prohibited:

> "The scanner knows the exact cause without evidence."

---

## 30. Versioning and Change Control

Scanner Model v1.0 is versioned.

AIDAtanaly uses sequential document versioning.

Change severity is recorded in the decision log as Patch Change, Minor Change, or Major Change and is not encoded directly into the version number.

### 30.1 Patch Change

Examples:

- wording clarification,
- typo correction,
- route label update,
- UI copy refinement that does not affect scoring.

### 30.2 Minor Change

Examples:

- adding a new question that does not change score interpretation,
- adding optional context inputs,
- improving output language,
- adding non-scoring explanation,
- adding additional reference links.

### 30.3 Major Change

Examples:

- changing D1–D7 weights,
- changing vector weighting,
- changing Evidence Confidence rules,
- changing diagnostic thresholds,
- changing failure-mode mapping logic,
- changing whether E0 can issue scores,
- adding or removing required output fields.

Major scanner changes require:

- decision log entry,
- version update,
- compatibility statement,
- output impact statement,
- route impact statement where applicable,
- and scanner implementation impact statement.

---

## 31. Future JSON Implementation

This Markdown file governs the model.

A future machine-readable implementation should be created at:

```
/data/scanner-model.json
```

That JSON file must match this document.

It must include:

- scanner version,
- vector IDs,
- question IDs,
- dimension mappings,
- answer scale,
- evidence confidence rules,
- failure mode mappings,
- intervention mappings,
- diagnostic thresholds,
- output templates,
- canonical routes.

No hidden contradictory model is permitted.

---

## 32. Closing Scanner Declaration

The AIDAtanaly Transition Scanner is the operational bridge between doctrine and diagnosis.

It turns the governing thesis into output.

It measures movement.

It qualifies confidence.

It classifies failure.

It links diagnosis to reference architecture.

It supports monetization without degrading trust.

It prepares the asset for future agent-readable intelligence, reports, API outputs, and strategic buyer review.

The scanner is not a quiz.

It is the first operational expression of AIDAtanaly as a Category Intelligence Factory.

> Stages are states. Value lives in transitions.

---

**AIDAtanaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.**
