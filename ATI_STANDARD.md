# ATI_STANDARD.md

## AIDAtanaly.com — AIDA Transition Index Standard

**Document Class:** Measurement Standard
**Layer:** 2 — Index / Standard Layer
**Asset:** AIDAtanaly.com
**Governed by:** FOUNDATION_DOCTRINE.md and ASSET_THESIS.md
**Status:** Ratified
**Version:** 1.1
**Date:** 2026-06-11
**Ratified by:** Sohadot — System Operator

---

## 1. Purpose of This Standard

This document defines the **AIDA Transition Index — ATI**, the governed measurement standard used by AIDAtanaly to evaluate movement inside AI-era marketing funnels.

The purpose of ATI is to convert the doctrine of AIDAtanaly into an operational scoring framework.

The doctrine states:

> Stages are states. Value lives in transitions.

The ATI standard answers the next question:

> How is transition quality measured?

ATI exists to measure, classify, score, and diagnose the health of movement across the four governed transition vectors:

- **T1 — Attention → Interest**
- **T2 — Interest → Desire**
- **T3 — Desire → Action**
- **T4 — Action → Loyalty**

ATI is not a generic funnel score.

It is a **transition health standard**.

---

## 2. Governing Principle

**The unit of measurement is the transition, not the stage.**

A stage describes where a prospect appears to be.

A transition measures whether movement occurred, how strong that movement was, what friction weakened it, what signal predicted it, and what commercial consequence followed from it.

ATI therefore does not ask only:

> "How many users reached this stage?"

It asks:

> "How effectively did users move from one state to the next?"

This distinction governs every scoring rule in this document.

---

## 3. What ATI Measures

ATI measures the quality of movement across four vectors:

| Vector | Transition | Transition Name | Core Question |
|---|---|---|---|
| T1 | Attention → Interest | Signal Conversion | Did visibility become curiosity? |
| T2 | Interest → Desire | Intent Formation | Did curiosity become preference? |
| T3 | Desire → Action | Conversion Friction | Did intent become action? |
| T4 | Action → Loyalty | Retention Extension | Did conversion become continuity? |

Each vector receives a score from 0 to 100, except where evidence is absent.

The full ATI score is a composite score from 0 to 100 based on the four vector scores.

Every score must be accompanied by an **Evidence Confidence** qualifier.

---

## 4. What ATI Does Not Measure

ATI does not replace analytics platforms, attribution systems, CRM dashboards, or product analytics tools.

ATI does not claim to be an industry-adopted standard before market adoption.

ATI does not score vanity metrics in isolation.

ATI does not treat AIDA as a rigid linear path.

ATI does not assume that all customer journeys follow the same sequence.

ATI does not diagnose revenue performance without considering transition evidence.

ATI is a **governed interpretation layer**.

It translates available funnel signals into a structured transition diagnosis.

---

## 5. Measurement Philosophy

ATI is based on five measurement principles.

### 5.1 Movement Over Volume

High traffic does not automatically mean strong movement.

A campaign may generate reach without interest, interest without desire, desire without action, or action without loyalty.

ATI rewards movement quality, not raw volume.

---

### 5.2 Signal Over Noise

Not every click, scroll, view, or session is meaningful.

ATI distinguishes between weak surface interaction and meaningful transition signal.

The purpose is to separate attention noise from movement evidence.

---

### 5.3 Friction Over Blame

A weak transition is not automatically a marketing failure.

It may be caused by message ambiguity, audience mismatch, trust deficit, price shock, process friction, lifecycle disconnect, or measurement gaps.

ATI classifies the failure mode before prescribing intervention.

---

### 5.4 Confidence Over Assertion

A score must reflect its evidence context.

Evidence confidence does not change the movement score, but it determines how strongly the score may be interpreted.

ATI therefore reports Evidence Confidence separately from the score.

---

### 5.5 Governance Over Guesswork

Every ATI output must map back to:

- a transition vector,
- scoring dimensions,
- evidence level,
- failure mode,
- intervention layer,
- and canonical reference pages.

No diagnostic output may be invented without a governed mapping.

---

## 6. Index Architecture

ATI has three scoring layers.

### 6.1 Vector Score

Each transition vector receives a score from 0 to 100 when evidence is sufficient.

Example:

- T1: 72
- T2: 46
- T3: 61
- T4: 38

This shows which part of the funnel has healthy movement and which part is structurally weak.

---

### 6.2 Composite ATI Score

The composite ATI score is the weighted average of T1–T4.

Default v1.1 vector weighting:

| Vector | Weight |
|---|---|
| T1 — Attention → Interest | 25% |
| T2 — Interest → Desire | 25% |
| T3 — Desire → Action | 25% |
| T4 — Action → Loyalty | 25% |

Default v1.1 uses equal vector weighting to preserve clarity, neutrality, and auditability.

Future versions may introduce context-specific weighting for B2B, e-commerce, SaaS, subscription, marketplace, or enterprise sales funnels. Any non-default weighting must be explicitly declared in the output.

---

### 6.3 Diagnostic Classification

Each vector score is mapped to a diagnostic class.

| Score Range | Diagnostic Class | Meaning |
|---|---|---|
| 85–100 | Transition Strong | Movement is healthy, clear, and commercially useful |
| 70–84 | Transition Functional | Movement exists but may contain optimization gaps |
| 55–69 | Transition Unstable | Movement occurs inconsistently or with meaningful friction |
| 40–54 | Transition Constrained | Movement is weak, delayed, or structurally blocked |
| 0–39 | Transition Critical | Movement is failing or largely ineffective |

The composite ATI score provides a summary.

The vector scores provide the diagnosis.

The failure modes provide the explanation.

The evidence qualifier controls how strongly the diagnosis may be interpreted.

---

## 7. Core Scoring Dimensions

Each vector is scored using seven governed dimensions.

Evidence Confidence is not part of the score. It is reported as a parallel qualifier under Section 9.

| Dimension | Weight | Scoring Direction |
|---|---|---|
| D1 — Signal Quality | 17% | Higher is better |
| D2 — Movement Probability | 23% | Higher is better |
| D3 — Transition Velocity | 11% | Higher is better |
| D4 — Friction Resilience | 17% | Higher is better |
| D5 — Drop-Off Resilience | 12% | Higher is better |
| D6 — Commercial Consequence | 10% | Higher is better |
| D7 — Intervention Clarity | 10% | Higher is better |

Total: 100%

Each dimension is scored from 0 to 100.

The vector score is calculated as:

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

All seven dimensions are positive-direction dimensions.

A higher score always indicates stronger transition health.

Evidence Confidence is reported separately as E0–E4.

---

## 8. Dimension Definitions

### D1 — Signal Quality

Signal Quality measures whether the observed behavior indicates genuine movement or only surface activity.

Examples of strong signal:

- repeat engagement,
- qualified content continuation,
- pricing or product exploration,
- brand-specific search,
- meaningful scroll depth,
- comparison behavior,
- demo or checkout intent,
- repeat purchase behavior.

Examples of weak signal:

- accidental clicks,
- short sessions,
- bounce-heavy traffic,
- generic impressions,
- unqualified reach,
- passive views,
- low-context engagement.

---

### D2 — Movement Probability

Movement Probability estimates the likelihood that a prospect will move from the current state to the next state.

It asks:

> "Given the available signals, how likely is transition?"

High movement probability indicates that the transition is not merely possible but actively forming.

---

### D3 — Transition Velocity

Transition Velocity measures how efficiently movement occurs.

A transition may be real but slow.

Slow movement may indicate hesitation, unclear positioning, friction, complex evaluation, weak urgency, or missing trust.

Velocity must be interpreted by context. Enterprise B2B transitions are naturally slower than low-cost consumer transactions.

---

### D4 — Friction Resilience

Friction Resilience measures how well the transition withstands or reduces obstacles that would otherwise prevent movement.

Common friction sources include:

- unclear message,
- wrong audience,
- weak value proposition,
- trust gap,
- price shock,
- complex process,
- slow page experience,
- poor UX,
- missing proof,
- unclear next step,
- weak post-purchase path.

High Friction Resilience indicates that these obstacles are low, controlled, or unlikely to block movement.

Low Friction Resilience indicates that friction is materially weakening the transition.

---

### D5 — Drop-Off Resilience

Drop-Off Resilience measures how well the transition resists abandonment before the next state is reached.

Low resilience may appear as:

- attention without click,
- engagement without preference,
- intent without purchase,
- checkout abandonment,
- signup abandonment,
- first purchase without repeat value,
- product activation failure,
- lifecycle silence.

High Drop-Off Resilience indicates that prospects are less likely to exit before completing the transition.

Low Drop-Off Resilience indicates that abandonment risk is structurally significant.

---

### D6 — Commercial Consequence

Commercial Consequence measures the value impact of the transition.

A transition may be healthy but commercially minor, or weak but strategically critical.

This dimension evaluates:

- revenue relevance,
- lead quality,
- pipeline contribution,
- retention value,
- customer lifetime value impact,
- strategic account value,
- and opportunity cost of failure.

ATI does not only measure movement.

It measures movement that matters.

---

### D7 — Intervention Clarity

Intervention Clarity measures whether the cause of weakness is identifiable enough to suggest an action.

High intervention clarity means the system can indicate the likely correction layer.

Examples:

- message intervention,
- audience intervention,
- offer intervention,
- proof intervention,
- UX intervention,
- pricing intervention,
- timing intervention,
- lifecycle intervention,
- attribution intervention.

Low intervention clarity means the system detects weakness but lacks enough evidence to prescribe a confident intervention.

---

## 9. Evidence Confidence Qualifier

Evidence Confidence measures the reliability of the evidence supporting an ATI score.

Confidence is not the same as score.

The ATI score measures transition quality.

Evidence Confidence measures how much trust should be placed in that score.

Every ATI output must include or imply an evidence confidence level.

| Level | Name | Description | Output Treatment |
|---|---|---|---|
| E0 | Absent Evidence | No meaningful evidence available | Numeric score should not be issued |
| E1 | Self-Reported Evidence | Based mainly on user answers or internal belief | Provisional score allowed |
| E2 | Observable Evidence | Based on visible metrics, behavior, or reported funnel data | Indicative score allowed |
| E3 | Multi-Source Evidence | Based on multiple signals across channels or systems | Strong score allowed |
| E4 | Validated Evidence | Based on tracked, repeated, and verifiable data patterns | Validated score allowed |

---

### 9.1 E0 Rule

If Evidence Confidence is E0, ATI should not issue a numeric score.

Correct output:

```
T3: Unscorable / E0 Absent Evidence
```

Incorrect output:

```
T3: 22 / E0 Absent Evidence
```

When evidence is absent, the correct diagnosis is a measurement gap, not a numeric certainty.

---

### 9.2 E1 Rule

E1 scores are allowed but must be described as provisional.

Example:

```
T2 Score: 46 / E1 Self-Reported Evidence
```

Public language:

> "This is a provisional diagnostic score based on self-reported inputs."

---

### 9.3 E2 Rule

E2 scores are allowed as indicative.

Example:

```
T1 Score: 72 / E2 Observable Evidence
```

Public language:

> "This score is indicative and based on observable or reported funnel signals."

---

### 9.4 E3–E4 Rule

E3 and E4 scores may be described with stronger confidence language.

However, even E4 does not permit revenue guarantees, unsupported causal certainty, or claims of universal industry authority.

Evidence Confidence strengthens the reliability of the interpretation.

It does not turn the score into a guarantee.

---

## 10. Vector Standards

### 10.1 T1 — Attention → Interest

**Signal Conversion Standard**

T1 measures whether raw visibility becomes meaningful engagement.

**Core Question**

> Did visibility become curiosity?

**Strong T1 Signals**

- qualified click-through,
- meaningful scroll depth,
- repeat visit after exposure,
- search follow-up,
- page continuation,
- content interaction,
- audience-fit engagement,
- low bounce from qualified sources,
- ad-to-content alignment.

**Weak T1 Signals**

- high impressions with low engagement,
- low-quality traffic,
- accidental clicks,
- irrelevant audience,
- short sessions,
- high bounce,
- social visibility without site interest,
- curiosity gap clicks without continuation.

**T1 Failure Modes**

Initial governed failure modes:

- Attention Noise,
- Vanity Reach,
- Audience Mismatch,
- Signal Decay,
- Message Blur.

**T1 Intervention Layers**

Common interventions:

- audience refinement,
- message clarification,
- channel adjustment,
- creative repositioning,
- content alignment,
- landing-page promise correction.

**T1 Diagnostic Output Examples**

- "Attention-heavy, interest-weak"
- "Visibility exists, but signal quality is low"
- "Audience mismatch is reducing transition probability"
- "Reach is being counted as progress without evidence of movement"

---

### 10.2 T2 — Interest → Desire

**Intent Formation Standard**

T2 measures whether engagement crystallizes into preference, intent, motivation, or commercial desire.

**Core Question**

> Did curiosity become preference?

**Strong T2 Signals**

- product comparison,
- pricing exploration,
- repeat content consumption,
- feature-specific engagement,
- brand-specific search,
- saved product or wishlist behavior,
- demo page exploration,
- review consumption,
- return visits with deeper intent,
- sales or product inquiry behavior.

**Weak T2 Signals**

- passive reading,
- non-commercial engagement,
- repeat visits without deeper movement,
- comparison without preference,
- high content consumption with no intent signal,
- educational traffic with no offer relevance,
- weak differentiation.

**T2 Failure Modes**

Initial governed failure modes:

- Passive Engagement,
- Comparison Stall,
- Preference Dilution,
- Intent Evaporation,
- Value Ambiguity.

**T2 Sub-Signal Rule**

Within ATI, preference and intent are sub-signals inside T2.

They are not separate transition vectors.

This preserves the four-vector structure of ATI while allowing richer diagnosis inside Interest → Desire.

**T2 Intervention Layers**

Common interventions:

- differentiation intervention,
- proof intervention,
- offer clarification,
- comparison support,
- value proposition strengthening,
- product education,
- retargeting sequence refinement.

**T2 Diagnostic Output Examples**

- "Engagement exists, but desire is not forming"
- "Interest is passive rather than commercial"
- "Comparison behavior is not resolving into preference"
- "The user understands the category but not why this offer should be chosen"

---

### 10.3 T3 — Desire → Action

**Conversion Friction Standard**

T3 measures whether formed intent becomes completed action.

**Core Question**

> Did intent become action?

**Strong T3 Signals**

- checkout completion,
- signup completion,
- demo request,
- quote request,
- contact form completion,
- purchase,
- subscription,
- booking,
- sales-qualified movement,
- clear next-step behavior.

**Weak T3 Signals**

- cart abandonment,
- form abandonment,
- repeated pricing visits with no action,
- stalled demo intent,
- hesitation at payment,
- high exit on checkout or contact page,
- repeated visits without commitment,
- intent signals without conversion.

**T3 Failure Modes**

Initial governed failure modes:

- Process Friction,
- Trust Deficit,
- Price Shock,
- Decision Delay,
- Complexity Wall,
- Objection Residue.

**T3 Intervention Layers**

Common interventions:

- UX simplification,
- trust proof,
- pricing clarity,
- objection handling,
- checkout repair,
- CTA improvement,
- risk reversal,
- sales-assist timing,
- urgency design.

**T3 Diagnostic Output Examples**

- "Desire exists, but conversion friction is blocking action"
- "The offer is wanted, but the next step is not trusted"
- "Intent is present, but urgency is too weak"
- "Process complexity is destroying formed demand"

---

### 10.4 T4 — Action → Loyalty

**Retention Extension Standard**

T4 measures whether completed action becomes continuity, repeat value, loyalty, advocacy, or durable customer relationship.

**Core Question**

> Did conversion become continuity?

**Strong T4 Signals**

- repeat purchase,
- product activation,
- returning customer behavior,
- subscription continuation,
- referral,
- review,
- account expansion,
- usage depth,
- lifecycle email engagement,
- low churn risk,
- advocacy behavior.

**Weak T4 Signals**

- one-time purchase,
- inactive account after signup,
- silent churn,
- no onboarding completion,
- no repeat engagement,
- no referral or review behavior,
- weak lifecycle communication,
- support contact without recovery,
- post-purchase abandonment.

**T4 Failure Modes**

Initial governed failure modes:

- One-Transaction Funnel,
- Silent Churn,
- Loyalty Blindness,
- Advocacy Vacuum,
- Lifecycle Disconnect.

**T4 Intervention Layers**

Common interventions:

- onboarding intervention,
- lifecycle messaging,
- retention sequence,
- customer success trigger,
- product activation,
- loyalty program,
- referral system,
- post-purchase trust reinforcement,
- churn prevention.

**T4 Diagnostic Output Examples**

- "Action is being captured, but continuity is not being created"
- "The funnel converts transactions but does not build durable value"
- "Post-action signals are insufficient to measure retention"
- "Customer movement stops after the first conversion"

---

## 11. Composite ATI Scoring

The composite ATI score is calculated as:

```
ATI = (T1 + T2 + T3 + T4) / 4
```

Default v1.1 uses equal vector weighting.

Each vector score must be accompanied by an Evidence Confidence qualifier.

**Example**

```
T1 = 76 / E2
T2 = 48 / E2
T3 = 62 / E1
T4 = 39 / E1

ATI = (76 + 48 + 62 + 39) / 4
ATI = 56.25
```

Composite diagnostic class:

```
ATI 56.25 — Transition Unstable
Composite Evidence Confidence: Mixed E1–E2
```

Vector diagnosis:

- T1: Functional / E2
- T2: Constrained / E2
- T3: Unstable / E1
- T4: Critical / E1

Interpretation:

Attention is becoming interest with observable evidence. Interest is not reliably becoming desire. Conversion friction remains unstable but is supported mainly by self-reported evidence. Post-action continuity is structurally weak, but evidence is still provisional.

Composite scores summarize.

Vector scores diagnose.

Failure modes explain.

Evidence Confidence qualifies reliability.

---

## 12. ATI Diagnostic Classes

The scanner, reports, and reference outputs may use the following diagnostic classes.

### 12.1 Transition Strong

**Score:** 85–100

Meaning:

Movement is healthy, clear, measurable, and commercially useful.

Action:

Maintain, monitor, and optimize selectively.

---

### 12.2 Transition Functional

**Score:** 70–84

Meaning:

Movement exists and is generally healthy, but there are visible optimization gaps.

Action:

Identify friction, improve velocity, and strengthen evidence.

---

### 12.3 Transition Unstable

**Score:** 55–69

Meaning:

Movement occurs inconsistently or depends on weak, fragmented, or unstable signals.

Action:

Classify failure modes and prioritize intervention.

---

### 12.4 Transition Constrained

**Score:** 40–54

Meaning:

Movement is weak, delayed, or structurally blocked.

Action:

Treat as a strategic funnel problem requiring focused correction.

---

### 12.5 Transition Critical

**Score:** 0–39

Meaning:

Movement is failing, unmeasured, or commercially ineffective.

Action:

Diagnose immediately before scaling traffic, spend, or automation.

---

## 13. Failure Mode Assignment Rules

Failure modes must be assigned only when there is sufficient supporting evidence.

### 13.1 Single Failure Mode

Assigned when one dominant weakness explains the vector score.

Example:

> T3 score is low because checkout abandonment and trust concerns dominate.

Assigned mode:

> Trust Deficit

---

### 13.2 Multiple Failure Modes

Assigned when multiple weaknesses interact.

Example:

> T2 is weak because users compare repeatedly but do not prefer the offer, and value remains unclear.

Assigned modes:

> Comparison Stall + Value Ambiguity

---

### 13.3 Measurement Gap

Assigned when the framework cannot confidently detect movement because data is missing.

Example:

> The organization measures traffic and sales but not intermediate signals of desire.

Assigned mode:

> Measurement Gap

Measurement Gap may appear across T1–T4.

It is not a transition vector.

It is not a normal failure mode.

It is a diagnostic constraint.

---

### 13.4 No Unsupported Diagnosis

The system must not assign a failure mode only because it sounds plausible.

Every diagnosis must be grounded in:

- scanner answer,
- observed signal,
- user-provided data,
- analytics evidence,
- CRM evidence,
- or documented absence of measurement.

---

## 14. Intervention Layer Mapping

Every failure mode must map to at least one intervention layer.

Allowed intervention layers:

| Intervention Layer | Description |
|---|---|
| Audience Intervention | Adjust who is being reached |
| Message Intervention | Clarify what is being communicated |
| Offer Intervention | Improve value, packaging, or proposition |
| Proof Intervention | Add evidence, authority, reviews, or trust signals |
| UX Intervention | Reduce path complexity or interface friction |
| Pricing Intervention | Improve pricing clarity, framing, or risk perception |
| Timing Intervention | Improve when prompts, offers, or follow-ups occur |
| Attribution Intervention | Repair measurement visibility |
| Lifecycle Intervention | Extend value after first action |
| Sales-Assist Intervention | Add human or automated assistance at high-friction points |

Interventions must remain class-level recommendations unless sufficient evidence supports specific tactical advice.

ATI diagnoses the class of problem.

It does not fabricate certainty.

---

## 15. Scanner v1 Implementation Rules

The first public implementation of ATI shall be the **AIDAtanaly Transition Scanner v1**.

Scanner v1 is rules-governed.

It does not require live data integrations.

### 15.1 Scanner v1 Input Types

Allowed inputs:

- structured yes/no questions,
- multiple-choice answers,
- confidence self-rating,
- funnel-type selection,
- channel selection,
- lifecycle model selection,
- measurement availability,
- observed symptoms,
- conversion context,
- retention context.

### 15.2 Scanner v1 Output Requirements

Each scanner output must include:

- composite ATI class,
- T1–T4 scores or score bands,
- evidence confidence per vector,
- weakest vector,
- strongest vector,
- assigned failure modes,
- explanation of each failure mode,
- evidence confidence level,
- recommended intervention layers,
- links to canonical reference pages,
- optional paid report path.

### 15.3 Scanner v1 Output Prohibitions

Scanner v1 must not claim:

- revenue lift guarantees,
- exact causal certainty,
- industry benchmark authority without data,
- platform-specific attribution certainty,
- or AI-generated precision unsupported by input evidence.

Scanner v1 is a governed diagnostic.

It is not a fortune-telling tool.

---

## 16. Report Output Model

ATI outputs may appear in three formats.

### 16.1 Free ATI Snapshot

Purpose:

- public utility,
- trust-building,
- lead qualification,
- reference engagement,
- usage signal accumulation.

Includes:

- ATI class,
- vector-level profile,
- weakest transition,
- likely failure class,
- evidence confidence level,
- basic intervention layer.

---

### 16.2 Paid Transition Diagnostic Brief

Purpose:

- respectable monetization,
- deeper utility,
- professional use.

Includes:

- full T1–T4 profile,
- dimension-level scoring,
- assigned failure modes,
- evidence confidence,
- intervention map,
- priority sequence,
- reference links,
- executive summary.

---

### 16.3 Advanced Transition Audit

Purpose:

- high-value assessment,
- manual or semi-automated audit,
- future enterprise offer.

Includes:

- deeper signal intake,
- funnel map,
- analytics review,
- CRM or lifecycle review where available,
- custom diagnosis,
- transition failure model,
- commercial consequence analysis,
- intervention roadmap.

---

## 17. Reference Page Requirements

Every ATI-related page must be internally connected.

### 17.1 Vector Page Requirements

Each vector page must include:

- vector definition,
- core question,
- strong signals,
- weak signals,
- scoring dimensions,
- failure modes,
- intervention layers,
- scanner relationship,
- related vectors,
- canonical link to ATI standard.

### 17.2 Failure Mode Page Requirements

Each failure-mode page must include:

- definition,
- affected vector,
- symptoms,
- causes,
- detection signals,
- scoring impact,
- AI instrumentation,
- intervention layer,
- related failure modes,
- scanner output language,
- canonical internal links.

### 17.3 Standard Page Requirements

The ATI standard page must link to:

- Foundation Doctrine,
- Asset Thesis,
- all vector pages,
- TFO ontology,
- scanner,
- methodology,
- governance,
- monetization boundary where relevant.

No orphan ATI pages are permitted.

---

## 18. Governance Rules

ATI is governed by the following rules:

1. ATI must always score transitions, not stages.
2. T1–T4 names are fixed.
3. Preference and intent remain sub-signals inside T2.
4. T4 remains Action → Loyalty and must not be removed.
5. Scanner outputs must map to T1–T4.
6. Failure modes must map to TFO.
7. Evidence Confidence must be reported separately from ATI score.
8. Evidence Confidence must never be mathematically included in ATI score.
9. E0 outputs must not issue numeric scores.
10. E1 outputs must use provisional language.
11. E2 outputs must use indicative language.
12. E3–E4 outputs may use stronger confidence language but must not imply guaranteed causality.
13. Unsupported certainty is prohibited.
14. Revenue guarantees are prohibited.
15. Score changes between versions must be logged.
16. Future scoring changes must preserve backward interpretability.
17. Public claims must distinguish introduced standard from adopted industry standard.
18. Monetized outputs must preserve trust and reference authority.
19. Any API or agent-readable endpoint must use the governed terminology of this standard.
20. Any interface visualization must represent movement, friction, resilience, and transition health accurately.

---

## 19. Versioning and Change Control

ATI is versioned.

AIDAtanaly uses sequential document versioning.

Change severity is recorded in the decision log as Patch Change, Minor Change, or Major Change and is not encoded directly into the version number.

Changes must be classified as follows:

### 19.1 Patch Change

Small wording, explanation, or route updates that do not affect scoring.

Example:

- definition clarification,
- typo correction,
- internal link update.

### 19.2 Minor Change

Additive change that preserves scoring compatibility.

Example:

- new failure mode,
- new intervention layer,
- new scanner question,
- new report format.

### 19.3 Major Change

Change that affects scoring interpretation.

Example:

- vector weight changes,
- dimension weight changes,
- diagnostic threshold changes,
- vector definition changes,
- removal or addition of scoring dimensions.

Major changes require:

- decision log entry,
- version update,
- compatibility statement,
- public note where relevant,
- backward interpretability statement where applicable.

The governance decision for the ATI v1.1 Evidence Confidence separation is archived at:

`governance/decisions/DECISION_ATI_STANDARD_1_1_EVIDENCE_CONFIDENCE_SEPARATION.md`

---

## 20. Public Claim Language

Allowed language:

> "AIDAtanaly introduces the AIDA Transition Index."

> "ATI is a governed framework for measuring transition health across AIDA vectors."

> "The scanner provides a rules-governed diagnostic profile based on available input signals."

> "ATI helps classify where funnel movement weakens, stops, or becomes inefficient."

Prohibited language:

> "ATI is the industry standard."

> "ATI guarantees conversion improvement."

> "AIDAtanaly proves the exact cause of revenue loss."

> "This score is definitive without analytics data."

> "AI knows exactly why your funnel fails."

Authority must be earned through consistency, usefulness, and adoption.

---

## 21. Agent-Readable Structure

ATI must be designed for human readers and AI agents.

Required future machine-readable structures:

- `/data/ati-standard.json`
- `/data/ati-vectors.json`
- `/data/tfo-failure-modes.json`
- `/data/intervention-layers.json`
- `/data/scanner-model.json`

Each JSON file must use stable IDs.

Example ID structure:

```
ati.vector.t1
ati.vector.t2
ati.vector.t3
ati.vector.t4

tfo.t1.attention_noise
tfo.t2.comparison_stall
tfo.t3.trust_deficit
tfo.t4.silent_churn
```

Agent-readable definitions must match public reference page language.

No hidden contradictory definitions are permitted.

Scanner and agent-readable outputs must separate score from evidence confidence.

Correct structure:

```json
{
  "vector_id": "ati.vector.t2",
  "score": 48,
  "diagnostic_class": "Transition Constrained",
  "evidence_confidence": {
    "level": "E2",
    "name": "Observable Evidence"
  },
  "failure_modes": [
    "tfo.t2.comparison_stall",
    "tfo.t2.value_ambiguity"
  ]
}
```

Incorrect structure:

```json
{
  "vector_id": "ati.vector.t2",
  "score": 48,
  "evidence_confidence_weight": 0.10
}
```

Evidence Confidence is metadata about reliability.

It is not a score component.

---

## 22. Closing Standard Declaration

ATI exists because funnel analytics has long counted movement around stages without governing the transitions themselves as the primary unit of intelligence.

AIDAtanaly changes the unit of measurement.

Not the stage.

The transition.

The AIDA Transition Index measures that transition health across:

- Signal Conversion,
- Intent Formation,
- Conversion Friction,
- Retention Extension.

This standard turns the doctrine into an operational system.

> Stages are states. Value lives in transitions.

---

**AIDAtanaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.**
