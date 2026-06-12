# TFO_ONTOLOGY.md

## AIDAtanaly.com — Transition Failure Ontology

**Document Class:** Ontology Standard
**Layer:** 3 — Failure Mode Ontology Layer
**Asset:** AIDAtanaly.com
**Governed by:** FOUNDATION_DOCTRINE.md, ASSET_THESIS.md, and ATI_STANDARD.md
**Status:** Ratified
**Version:** 1.0
**Date:** 2026-06-11
**Ratified by:** Sohadot — System Operator

---

## 1. Purpose of This Ontology

This document defines the **Transition Failure Ontology — TFO**, the governed taxonomy used by AIDAtanaly to classify failure modes across AIDA transition vectors.

The AIDA Transition Index measures transition health.

The Transition Failure Ontology explains why transition health may be weak.

ATI answers:

> How strong is the movement?

TFO answers:

> What class of movement failure is present?

Together, ATI and TFO convert funnel weakness from vague observation into governed diagnosis.

---

## 2. Governing Doctrine

The governing doctrine of AIDAtanaly states:

> Stages are states. Value lives in transitions.

TFO extends this doctrine by establishing that funnel failure should not be described only as "low conversion," "poor engagement," "weak retention," or "bad performance."

Those are outcomes.

TFO classifies the movement failures that produce those outcomes.

AIDAtanaly does not ask only:

> "Where did users drop off?"

It asks:

> What type of transition failure caused movement to weaken, stop, or collapse?

This ontology exists to standardize that answer.

---

## 3. Relationship to ATI

TFO is subordinate to and operationally dependent on the **AIDA Transition Index — ATI**.

ATI defines the four governed transition vectors:

| Vector | Transition | Transition Name |
|---|---|---|
| T1 | Attention → Interest | Signal Conversion |
| T2 | Interest → Desire | Intent Formation |
| T3 | Desire → Action | Conversion Friction |
| T4 | Action → Loyalty | Retention Extension |

TFO assigns failure modes under these four vectors.

No failure mode may exist outside the T1–T4 structure unless it is explicitly classified as a cross-vector diagnostic constraint.

---

## 4. Ontology Rules

The following rules govern the TFO.

1. Every failure mode must map to exactly one primary ATI vector.
2. A failure mode may have secondary relationships to other vectors, but its primary vector must remain fixed.
3. Failure modes must describe transition weakness, not generic marketing problems.
4. Every failure mode must have a stable ID.
5. Every failure mode must have a canonical route.
6. Every failure mode must map to at least one intervention layer.
7. Every failure mode must define symptoms and detection signals.
8. Every failure mode must link back to its parent vector page.
9. Every scanner diagnosis must use TFO-governed terms.
10. Unsupported failure mode assignment is prohibited.
11. Measurement Gap is not a normal failure mode; it is a cross-vector diagnostic constraint.
12. New failure modes require ontology versioning and decision log entry if they affect scanner outputs.

---

## 5. Stable ID Structure

All TFO entries must use stable machine-readable IDs.

ID format:

```
tfo.{vector}.{failure_mode_slug}
```

Examples:

```
tfo.t1.attention_noise
tfo.t2.comparison_stall
tfo.t3.trust_deficit
tfo.t4.silent_churn
```

Diagnostic constraints use a separate namespace:

```
tfo.constraint.measurement_gap
```

Stable IDs must never be reused for different meanings.

If a failure mode is deprecated, its ID remains reserved.

---

## 6. Canonical Route Structure

Every failure mode receives a canonical public page.

Route format:

```
/failure-modes/{failure-mode-slug}/
```

Examples:

```
/failure-modes/attention-noise/
/failure-modes/comparison-stall/
/failure-modes/trust-deficit/
/failure-modes/silent-churn/
```

Vector pages use:

```
/vectors/attention-to-interest/
/vectors/interest-to-desire/
/vectors/desire-to-action/
/vectors/action-to-loyalty/
```

The ontology overview page uses:

```
/transition-failure-ontology/
```

No failure mode page may be orphaned.

---

## 7. Intervention Layer Registry

Each failure mode must map to one or more approved intervention layers.

Approved intervention layers:

| Intervention Layer | Purpose |
|---|---|
| Audience Intervention | Adjust who is being reached |
| Message Intervention | Clarify what is being communicated |
| Offer Intervention | Improve value, packaging, or proposition |
| Proof Intervention | Add evidence, authority, trust, or credibility signals |
| UX Intervention | Reduce path complexity or interface friction |
| Pricing Intervention | Improve pricing clarity, framing, or risk perception |
| Timing Intervention | Improve when prompts, offers, or follow-ups occur |
| Attribution Intervention | Repair measurement visibility |
| Lifecycle Intervention | Extend value after first action |
| Sales-Assist Intervention | Add human or automated assistance at high-friction points |

No custom intervention layer may be introduced without ontology update.

---

## 8. T1 Failure Modes

### Attention → Interest

**Signal Conversion Failures**

T1 failure modes occur when raw visibility does not become meaningful engagement.

T1 governs the transition from being noticed to becoming interesting.

---

### 8.1 Attention Noise

**Stable ID:** `tfo.t1.attention_noise`
**Primary Vector:** T1 — Attention → Interest
**Canonical Route:** `/failure-modes/attention-noise/`
**Diagnostic Class:** Signal Conversion Failure

**Definition**

Attention Noise occurs when a brand, offer, page, or campaign receives visibility but that visibility does not produce meaningful engagement.

The audience sees something, but the exposure does not become qualified curiosity.

**Core Diagnostic Question**

> Is the funnel counting visibility as progress without evidence of interest?

**Symptoms**

- High impressions with low qualified engagement.
- Large reach but weak click-through quality.
- Social visibility without site continuation.
- Paid exposure that does not produce repeat interaction.
- Traffic spikes with no downstream movement.
- High awareness metrics with low intent signal.

**Detection Signals**

- High impressions paired with low qualified clicks.
- Low scroll depth after traffic arrival.
- Low repeat visit rate.
- Weak search follow-up.
- Weak content continuation.
- Low time-on-page from campaign traffic.
- High bounce from broad campaigns.

**Scoring Impact**

Attention Noise primarily weakens:

- D1 — Signal Quality
- D2 — Movement Probability
- D5 — Drop-Off Resilience

**AI Instrumentation**

AI may assist by:

- separating accidental or passive exposure from meaningful engagement,
- clustering low-quality traffic patterns,
- identifying weak post-exposure behavior,
- detecting sources that create visibility without transition probability.

**Intervention Layers**

- Audience Intervention
- Message Intervention
- Channel Intervention, governed under Audience or Message context
- Attribution Intervention

**Related Failure Modes**

- Vanity Reach
- Audience Mismatch
- Signal Decay
- Message Blur

---

### 8.2 Vanity Reach

**Stable ID:** `tfo.t1.vanity_reach`
**Primary Vector:** T1 — Attention → Interest
**Canonical Route:** `/failure-modes/vanity-reach/`
**Diagnostic Class:** Signal Conversion Failure

**Definition**

Vanity Reach occurs when the funnel produces large audience volume that looks impressive but does not create meaningful transition probability.

The metric looks strong, but the movement is weak.

**Core Diagnostic Question**

> Is reach being treated as value before it proves transition quality?

**Symptoms**

- High campaign reach with weak downstream engagement.
- Broad targeting that inflates awareness metrics.
- Impressions used as proof of traction without interest evidence.
- Large audiences that do not return, click, compare, subscribe, or inquire.
- Marketing reports emphasizing volume over movement.

**Detection Signals**

- High reach-to-engagement gap.
- Weak engagement-to-return behavior.
- Low qualified session rate.
- Weak assisted movement into T2.
- No correlation between reach growth and preference or action signals.

**Scoring Impact**

Vanity Reach primarily weakens:

- D1 — Signal Quality
- D2 — Movement Probability
- D6 — Commercial Consequence

**AI Instrumentation**

AI may assist by:

- identifying audience segments that generate reach without movement,
- comparing engagement quality across traffic sources,
- detecting inflated exposure metrics,
- separating commercially meaningful attention from passive visibility.

**Intervention Layers**

- Audience Intervention
- Message Intervention
- Attribution Intervention

**Related Failure Modes**

- Attention Noise
- Audience Mismatch
- Passive Engagement

---

### 8.3 Audience Mismatch

**Stable ID:** `tfo.t1.audience_mismatch`
**Primary Vector:** T1 — Attention → Interest
**Canonical Route:** `/failure-modes/audience-mismatch/`
**Diagnostic Class:** Signal Conversion Failure

**Definition**

Audience Mismatch occurs when the funnel attracts people who are not aligned with the offer, market, need, buying capacity, timing, or intent profile required for meaningful movement.

The audience may be real, but it is structurally wrong for the transition.

**Core Diagnostic Question**

> Is the funnel reaching people who are unlikely to become interested for the right reasons?

**Symptoms**

- Engagement from irrelevant segments.
- High traffic but weak qualification.
- Campaigns attracting curiosity without buyer fit.
- Content pulling educational or entertainment traffic instead of market-intent traffic.
- Leads that do not match the buyer profile.

**Detection Signals**

- Poor fit between traffic source and offer.
- Weak lead qualification.
- High bounce from misaligned channels.
- Low conversion from high-volume segments.
- Search intent mismatch.
- Geographic, demographic, or firmographic misalignment.

**Scoring Impact**

Audience Mismatch primarily weakens:

- D1 — Signal Quality
- D2 — Movement Probability
- D6 — Commercial Consequence
- D7 — Intervention Clarity, if segmentation data is weak

**AI Instrumentation**

AI may assist by:

- clustering low-fit audience segments,
- comparing behavior by source and intent,
- detecting mismatch between message promise and visitor behavior,
- identifying segments with low transition probability.

**Intervention Layers**

- Audience Intervention
- Message Intervention
- Offer Intervention

**Related Failure Modes**

- Attention Noise
- Vanity Reach
- Value Ambiguity

---

### 8.4 Signal Decay

**Stable ID:** `tfo.t1.signal_decay`
**Primary Vector:** T1 — Attention → Interest
**Canonical Route:** `/failure-modes/signal-decay/`
**Diagnostic Class:** Signal Conversion Failure

**Definition**

Signal Decay occurs when initial attention weakens before it can become sustained interest.

The prospect notices the offer, but the signal loses strength too quickly to create meaningful engagement.

**Core Diagnostic Question**

> Does attention weaken before curiosity has time to form?

**Symptoms**

- Initial clicks without continuation.
- Short-lived campaign response.
- Strong first exposure but weak repeat engagement.
- Users begin interacting but quickly abandon the page or sequence.
- Early curiosity does not survive the first content or landing experience.

**Detection Signals**

- High initial click rate with weak scroll depth.
- Low content continuation after landing.
- Low repeat visit after first exposure.
- High first-page exit.
- Weak retargeting engagement after initial contact.
- Sharp engagement decline within early journey steps.

**Scoring Impact**

Signal Decay primarily weakens:

- D2 — Movement Probability
- D3 — Transition Velocity
- D5 — Drop-Off Resilience

**AI Instrumentation**

AI may assist by:

- detecting engagement drop patterns,
- identifying decay points in early journeys,
- comparing initial signal strength with continuation probability,
- predicting which traffic sources are prone to decay.

**Intervention Layers**

- Message Intervention
- UX Intervention
- Timing Intervention
- Offer Intervention

**Related Failure Modes**

- Message Blur
- Passive Engagement
- Process Friction

---

### 8.5 Message Blur

**Stable ID:** `tfo.t1.message_blur`
**Primary Vector:** T1 — Attention → Interest
**Canonical Route:** `/failure-modes/message-blur/`
**Diagnostic Class:** Signal Conversion Failure

**Definition**

Message Blur occurs when the audience sees the asset but does not clearly understand what it is, why it matters, who it is for, or what problem it addresses.

The message creates exposure but not interpretive clarity.

**Core Diagnostic Question**

> Does the audience understand why the offer deserves interest?

**Symptoms**

- Users arrive but do not continue.
- Page or campaign explains features but not relevance.
- High confusion in user feedback.
- Weak headline-to-content continuity.
- Visitors do not understand the next step.
- Offer appears generic or indistinct.

**Detection Signals**

- Low scroll beyond hero section.
- High bounce on landing pages.
- Weak click-through to explanatory pages.
- Low engagement with value proposition sections.
- Repeated support or sales questions about basic positioning.
- Heatmap or session data showing hesitation near core message areas.

**Scoring Impact**

Message Blur primarily weakens:

- D1 — Signal Quality
- D2 — Movement Probability
- D4 — Friction Resilience
- D7 — Intervention Clarity

**AI Instrumentation**

AI may assist by:

- analyzing message clarity,
- comparing visitor behavior against page sections,
- classifying ambiguity in copy,
- detecting mismatch between search intent and landing message.

**Intervention Layers**

- Message Intervention
- Offer Intervention
- UX Intervention
- Proof Intervention

**Related Failure Modes**

- Attention Noise
- Signal Decay
- Value Ambiguity

---

## 9. T2 Failure Modes

### Interest → Desire

**Intent Formation Failures**

T2 failure modes occur when engagement does not crystallize into preference, intent, motivation, or commercial desire.

T2 governs the transition from curiosity to choice pressure.

Preference and intent are sub-signals inside T2, not separate transition vectors.

---

### 9.1 Passive Engagement

**Stable ID:** `tfo.t2.passive_engagement`
**Primary Vector:** T2 — Interest → Desire
**Canonical Route:** `/failure-modes/passive-engagement/`
**Diagnostic Class:** Intent Formation Failure

**Definition**

Passive Engagement occurs when users consume content or interact with the brand without moving toward preference, intent, or commercial motivation.

The audience appears interested, but the interest remains passive.

**Core Diagnostic Question**

> Is engagement being mistaken for desire?

**Symptoms**

- Users read or watch but do not compare, inquire, save, subscribe, request, or return with deeper intent.
- High content engagement with weak offer engagement.
- Educational traffic that does not move toward product or service relevance.
- Long sessions without commercial next steps.

**Detection Signals**

- High page views with low product exploration.
- High content consumption but weak pricing or demo page visits.
- Low return visits with deeper intent.
- Weak lead conversion from engaged users.
- Low transition from educational pages to offer pages.

**Scoring Impact**

Passive Engagement primarily weakens:

- D1 — Signal Quality
- D2 — Movement Probability
- D6 — Commercial Consequence

**AI Instrumentation**

AI may assist by:

- distinguishing content engagement from commercial intent,
- classifying passive versus motivated behavior,
- detecting non-commercial consumption patterns,
- identifying content paths that fail to generate desire.

**Intervention Layers**

- Offer Intervention
- Message Intervention
- Proof Intervention
- Timing Intervention

**Related Failure Modes**

- Value Ambiguity
- Comparison Stall
- Intent Evaporation

---

### 9.2 Comparison Stall

**Stable ID:** `tfo.t2.comparison_stall`
**Primary Vector:** T2 — Interest → Desire
**Canonical Route:** `/failure-modes/comparison-stall/`
**Diagnostic Class:** Intent Formation Failure

**Definition**

Comparison Stall occurs when prospects remain trapped in evaluation without forming preference.

They compare options, read reviews, revisit pages, or inspect features, but the comparison does not resolve into choice.

**Core Diagnostic Question**

> Is evaluation failing to become preference?

**Symptoms**

- Repeated product or pricing visits without action.
- Long comparison cycles.
- High competitor comparison search.
- Users return multiple times but do not choose.
- Sales conversations stall around alternatives.

**Detection Signals**

- Repeated visits to comparison pages.
- High engagement with feature tables but weak CTA movement.
- Search patterns including competitor names.
- Long delay between product interest and action.
- High assisted but low direct conversion.

**Scoring Impact**

Comparison Stall primarily weakens:

- D2 — Movement Probability
- D3 — Transition Velocity
- D5 — Drop-Off Resilience
- D7 — Intervention Clarity, when competitor context is unclear

**AI Instrumentation**

AI may assist by:

- detecting comparison behavior,
- identifying unresolved evaluation loops,
- classifying competitor-sensitive prospects,
- predicting when comparison is likely to stall.

**Intervention Layers**

- Proof Intervention
- Offer Intervention
- Message Intervention
- Sales-Assist Intervention

**Related Failure Modes**

- Preference Dilution
- Value Ambiguity
- Decision Delay

---

### 9.3 Preference Dilution

**Stable ID:** `tfo.t2.preference_dilution`
**Primary Vector:** T2 — Interest → Desire
**Canonical Route:** `/failure-modes/preference-dilution/`
**Diagnostic Class:** Intent Formation Failure

**Definition**

Preference Dilution occurs when multiple alternatives weaken the prospect's ability to form a clear preference for the offer.

Interest exists, but the offer does not become the preferred choice.

**Core Diagnostic Question**

> Is the prospect interested but not sufficiently biased toward this offer?

**Symptoms**

- Users compare but do not favor the brand.
- Weak differentiation.
- Generic positioning.
- High engagement with alternatives.
- No clear reason to choose.
- Sales or support questions show uncertainty about advantage.

**Detection Signals**

- Competitor comparison searches.
- Low conversion from comparison pages.
- Weak interaction with differentiator sections.
- High engagement with proof content but weak next-step action.
- Repeated evaluation without preference signal.

**Scoring Impact**

Preference Dilution primarily weakens:

- D1 — Signal Quality
- D2 — Movement Probability
- D6 — Commercial Consequence

**AI Instrumentation**

AI may assist by:

- comparing message differentiation against competitor language,
- detecting weak preference signals,
- classifying users likely to switch to alternatives,
- identifying pages where differentiation is unclear.

**Intervention Layers**

- Message Intervention
- Proof Intervention
- Offer Intervention
- Sales-Assist Intervention

**Related Failure Modes**

- Comparison Stall
- Value Ambiguity
- Trust Deficit

---

### 9.4 Intent Evaporation

**Stable ID:** `tfo.t2.intent_evaporation`
**Primary Vector:** T2 — Interest → Desire
**Canonical Route:** `/failure-modes/intent-evaporation/`
**Diagnostic Class:** Intent Formation Failure

**Definition**

Intent Evaporation occurs when early commercial motivation appears but fades before it can become strong desire or action.

The prospect begins moving toward intent, but the motivation does not persist.

**Core Diagnostic Question**

> Does early intent disappear before it becomes durable desire?

**Symptoms**

- Users visit high-intent pages once and do not return.
- Demo or pricing interest appears but no follow-up occurs.
- Retargeting fails after initial intent.
- Leads express interest but disengage quickly.
- Product curiosity does not survive delay.

**Detection Signals**

- Single-session pricing visits.
- Abandoned demo flows.
- No return after high-intent page visit.
- Decline in email engagement after initial inquiry.
- No continuation after quote or product exploration.

**Scoring Impact**

Intent Evaporation primarily weakens:

- D2 — Movement Probability
- D3 — Transition Velocity
- D5 — Drop-Off Resilience

**AI Instrumentation**

AI may assist by:

- detecting early intent signals,
- predicting decay risk,
- identifying timing windows for follow-up,
- clustering users whose interest fades quickly.

**Intervention Layers**

- Timing Intervention
- Offer Intervention
- Sales-Assist Intervention
- Lifecycle Intervention

**Related Failure Modes**

- Signal Decay
- Decision Delay
- Passive Engagement

---

### 9.5 Value Ambiguity

**Stable ID:** `tfo.t2.value_ambiguity`
**Primary Vector:** T2 — Interest → Desire
**Canonical Route:** `/failure-modes/value-ambiguity/`
**Diagnostic Class:** Intent Formation Failure

**Definition**

Value Ambiguity occurs when prospects understand the offer at a surface level but cannot clearly translate it into a reason to choose, pay, act, or prioritize.

Interest exists, but value is not decisive.

**Core Diagnostic Question**

> Does the prospect understand why this offer is worth choosing now?

**Symptoms**

- Users understand the category but not the unique value.
- High engagement with explanation pages but weak intent signals.
- Prospects ask "why this?" or "why now?"
- Offer appears useful but not urgent.
- Benefits are described but not made commercially compelling.

**Detection Signals**

- Low movement from educational pages to conversion pages.
- Weak engagement with offer or pricing sections.
- Repeated visits without intent.
- High comparison behavior.
- Low response to value proposition CTAs.

**Scoring Impact**

Value Ambiguity primarily weakens:

- D1 — Signal Quality
- D2 — Movement Probability
- D6 — Commercial Consequence
- D7 — Intervention Clarity

**AI Instrumentation**

AI may assist by:

- analyzing offer clarity,
- detecting weak value language,
- comparing user intent with page messaging,
- identifying missing proof or urgency signals.

**Intervention Layers**

- Message Intervention
- Offer Intervention
- Proof Intervention
- Pricing Intervention

**Related Failure Modes**

- Message Blur
- Preference Dilution
- Passive Engagement

---

## 10. T3 Failure Modes

### Desire → Action

**Conversion Friction Failures**

T3 failure modes occur when formed desire, intent, or motivation fails to become completed action.

T3 governs the transition from wanting to doing.

---

### 10.1 Process Friction

**Stable ID:** `tfo.t3.process_friction`
**Primary Vector:** T3 — Desire → Action
**Canonical Route:** `/failure-modes/process-friction/`
**Diagnostic Class:** Conversion Friction Failure

**Definition**

Process Friction occurs when the required path to act is too long, confusing, slow, broken, or cognitively heavy.

The prospect may want to act, but the process weakens or prevents completion.

**Core Diagnostic Question**

> Is the action path harder than the prospect's motivation can withstand?

**Symptoms**

- Form abandonment.
- Checkout abandonment.
- Long or confusing signup flows.
- Unclear CTA sequence.
- Too many required fields.
- Technical errors.
- Users revisit action pages without completing.

**Detection Signals**

- High abandonment on forms or checkout.
- Session recordings showing hesitation.
- Drop-off at required fields.
- High exit on action pages.
- Repeated action-page visits without completion.
- Support questions about how to proceed.

**Scoring Impact**

Process Friction primarily weakens:

- D4 — Friction Resilience
- D5 — Drop-Off Resilience
- D3 — Transition Velocity

**AI Instrumentation**

AI may assist by:

- detecting abandonment patterns,
- identifying high-friction fields or steps,
- predicting completion probability,
- classifying UX obstacles from user behavior.

**Intervention Layers**

- UX Intervention
- Timing Intervention
- Sales-Assist Intervention

**Related Failure Modes**

- Complexity Wall
- Decision Delay
- Trust Deficit

---

### 10.2 Trust Deficit

**Stable ID:** `tfo.t3.trust_deficit`
**Primary Vector:** T3 — Desire → Action
**Canonical Route:** `/failure-modes/trust-deficit/`
**Diagnostic Class:** Conversion Friction Failure

**Definition**

Trust Deficit occurs when the prospect wants the offer but does not trust the seller, product, process, proof, payment, claim, or next step enough to act.

Desire exists, but trust is insufficient.

**Core Diagnostic Question**

> Is lack of trust blocking action after desire forms?

**Symptoms**

- Users return to proof, reviews, security, or guarantee sections.
- Prospects hesitate near payment or contact.
- High exit near purchase or signup.
- Sales questions focus on legitimacy, risk, or reliability.
- Conversion improves when proof is added.

**Detection Signals**

- Repeated proof-page visits.
- Abandonment near payment.
- High interaction with trust elements but low action.
- Low conversion for new visitors compared to returning users.
- Surveys or support tickets mentioning doubt.

**Scoring Impact**

Trust Deficit primarily weakens:

- D4 — Friction Resilience
- D5 — Drop-Off Resilience
- D6 — Commercial Consequence

**AI Instrumentation**

AI may assist by:

- detecting hesitation around trust-sensitive steps,
- classifying trust-related objections,
- identifying missing proof elements,
- predicting risk-sensitive user segments.

**Intervention Layers**

- Proof Intervention
- UX Intervention
- Sales-Assist Intervention
- Pricing Intervention, where risk perception is pricing-related

**Related Failure Modes**

- Objection Residue
- Price Shock
- Preference Dilution

---

### 10.3 Price Shock

**Stable ID:** `tfo.t3.price_shock`
**Primary Vector:** T3 — Desire → Action
**Canonical Route:** `/failure-modes/price-shock/`
**Diagnostic Class:** Conversion Friction Failure

**Definition**

Price Shock occurs when desire weakens or collapses when cost becomes explicit.

The problem is not necessarily that the offer is too expensive. The problem is that value, timing, trust, or framing does not support the price at the moment of decision.

**Core Diagnostic Question**

> Does price exposure break movement from desire to action?

**Symptoms**

- High exit from pricing pages.
- Cart abandonment after price reveal.
- Prospects request discounts immediately.
- Sales conversations stall at cost.
- Users compare cheaper alternatives.
- Strong product interest but weak payment completion.

**Detection Signals**

- Pricing-page exit spikes.
- Checkout abandonment after total cost display.
- Low conversion from pricing visitors.
- Coupon-seeking behavior.
- Repeated pricing visits without action.
- Objections mentioning cost, risk, or unclear value.

**Scoring Impact**

Price Shock primarily weakens:

- D4 — Friction Resilience
- D5 — Drop-Off Resilience
- D6 — Commercial Consequence

**AI Instrumentation**

AI may assist by:

- detecting price-sensitive behavior,
- identifying price reveal drop-off points,
- clustering users by price tolerance,
- comparing value engagement before price exposure.

**Intervention Layers**

- Pricing Intervention
- Offer Intervention
- Proof Intervention
- Sales-Assist Intervention

**Related Failure Modes**

- Value Ambiguity
- Trust Deficit
- Decision Delay

---

### 10.4 Decision Delay

**Stable ID:** `tfo.t3.decision_delay`
**Primary Vector:** T3 — Desire → Action
**Canonical Route:** `/failure-modes/decision-delay/`
**Diagnostic Class:** Conversion Friction Failure

**Definition**

Decision Delay occurs when intent exists but urgency is insufficient to produce timely action.

The prospect may still want the offer, but the decision remains deferred.

**Core Diagnostic Question**

> Is intent present but not urgent enough to become action?

**Symptoms**

- Repeated visits without conversion.
- Long delay between high-intent behavior and action.
- Users save, compare, or inquire but do not commit.
- Sales opportunities remain open without progress.
- Prospects say "later" or "not now."

**Detection Signals**

- High returning visitor rate with low conversion.
- Multiple pricing visits over time.
- Long sales cycle without movement.
- Abandoned carts that remain unresolved.
- Follow-up engagement without commitment.

**Scoring Impact**

Decision Delay primarily weakens:

- D3 — Transition Velocity
- D5 — Drop-Off Resilience
- D2 — Movement Probability

**AI Instrumentation**

AI may assist by:

- identifying delayed-intent patterns,
- predicting follow-up timing,
- detecting urgency gaps,
- clustering prospects likely to defer.

**Intervention Layers**

- Timing Intervention
- Offer Intervention
- Sales-Assist Intervention
- Message Intervention

**Related Failure Modes**

- Intent Evaporation
- Price Shock
- Objection Residue

---

### 10.5 Complexity Wall

**Stable ID:** `tfo.t3.complexity_wall`
**Primary Vector:** T3 — Desire → Action
**Canonical Route:** `/failure-modes/complexity-wall/`
**Diagnostic Class:** Conversion Friction Failure

**Definition**

Complexity Wall occurs when the prospect cannot complete action because the decision, process, product, pricing, configuration, or implementation appears too complex.

The prospect may want the outcome but cannot easily cross the action threshold.

**Core Diagnostic Question**

> Is complexity preventing intent from becoming action?

**Symptoms**

- Users hesitate around configuration or plan selection.
- Prospects request explanation before buying.
- Forms or product choices feel overwhelming.
- High abandonment in multi-step workflows.
- Sales conversations stall around implementation or setup.
- Users fail to understand what to choose.

**Detection Signals**

- Exit from configuration pages.
- High support or sales questions about complexity.
- Low completion of multi-step flows.
- Strong interest in guides but weak action.
- Long time spent before abandonment.
- Click patterns showing indecision.

**Scoring Impact**

Complexity Wall primarily weakens:

- D4 — Friction Resilience
- D5 — Drop-Off Resilience
- D7 — Intervention Clarity

**AI Instrumentation**

AI may assist by:

- identifying complexity-heavy interaction patterns,
- detecting user indecision,
- recommending simplified paths,
- classifying which step creates cognitive overload.

**Intervention Layers**

- UX Intervention
- Message Intervention
- Sales-Assist Intervention
- Offer Intervention

**Related Failure Modes**

- Process Friction
- Decision Delay
- Value Ambiguity

---

### 10.6 Objection Residue

**Stable ID:** `tfo.t3.objection_residue`
**Primary Vector:** T3 — Desire → Action
**Canonical Route:** `/failure-modes/objection-residue/`
**Diagnostic Class:** Conversion Friction Failure

**Definition**

Objection Residue occurs when unresolved doubts remain after desire forms and continue blocking action.

The prospect may be convinced enough to want the offer, but not enough to proceed.

**Core Diagnostic Question**

> Are unresolved doubts preventing action after desire has already formed?

**Symptoms**

- Prospects ask repeated questions before action.
- Users revisit FAQ, reviews, guarantees, or support pages.
- Sales conversations circle around the same doubts.
- Intent exists but commitment does not occur.
- Trust or risk concerns remain unresolved.

**Detection Signals**

- High interaction with FAQ or objection-handling content.
- Repeated visits to proof pages.
- Support or sales tickets with recurring objections.
- Long delay after quote or demo.
- Abandonment after reviewing terms or guarantees.

**Scoring Impact**

Objection Residue primarily weakens:

- D4 — Friction Resilience
- D5 — Drop-Off Resilience
- D7 — Intervention Clarity

**AI Instrumentation**

AI may assist by:

- classifying repeated objections,
- detecting unresolved doubt patterns,
- mapping objection types to content gaps,
- predicting which objections block action.

**Intervention Layers**

- Proof Intervention
- Message Intervention
- Sales-Assist Intervention
- UX Intervention

**Related Failure Modes**

- Trust Deficit
- Price Shock
- Decision Delay

---

## 11. T4 Failure Modes

### Action → Loyalty

**Retention Extension Failures**

T4 failure modes occur when completed action does not become continuity, repeat value, loyalty, advocacy, or durable relationship.

T4 governs the transition from transaction to continuity.

---

### 11.1 One-Transaction Funnel

**Stable ID:** `tfo.t4.one_transaction_funnel`
**Primary Vector:** T4 — Action → Loyalty
**Canonical Route:** `/failure-modes/one-transaction-funnel/`
**Diagnostic Class:** Retention Extension Failure

**Definition**

One-Transaction Funnel occurs when the system successfully creates a first action but fails to generate repeat value or continued relationship.

The funnel converts once but does not extend value.

**Core Diagnostic Question**

> Does the funnel create transactions without continuity?

**Symptoms**

- First purchase or signup occurs, but repeat behavior is weak.
- No post-purchase engagement strategy.
- One-time customers do not return.
- Lifecycle messaging is absent or generic.
- Revenue depends heavily on new acquisition.

**Detection Signals**

- Low repeat purchase rate.
- Low second-session activation.
- Weak post-action engagement.
- High acquisition dependence.
- Low customer lifetime value.
- No structured retention measurement.

**Scoring Impact**

One-Transaction Funnel primarily weakens:

- D2 — Movement Probability
- D5 — Drop-Off Resilience
- D6 — Commercial Consequence

**AI Instrumentation**

AI may assist by:

- identifying one-time customer patterns,
- predicting repeat probability,
- detecting missing post-action triggers,
- clustering customers unlikely to return.

**Intervention Layers**

- Lifecycle Intervention
- Timing Intervention
- Offer Intervention
- Proof Intervention

**Related Failure Modes**

- Silent Churn
- Loyalty Blindness
- Lifecycle Disconnect

---

### 11.2 Silent Churn

**Stable ID:** `tfo.t4.silent_churn`
**Primary Vector:** T4 — Action → Loyalty
**Canonical Route:** `/failure-modes/silent-churn/`
**Diagnostic Class:** Retention Extension Failure

**Definition**

Silent Churn occurs when customers leave, stop using, stop buying, or disengage without visible complaint or explicit cancellation signal.

The relationship fades without a clear alarm.

**Core Diagnostic Question**

> Are customers leaving without being detected early enough to intervene?

**Symptoms**

- Users stop engaging after initial action.
- Customers disappear without feedback.
- Usage declines quietly.
- Repeat purchase does not occur.
- Churn is discovered after value has already been lost.

**Detection Signals**

- Declining usage frequency.
- No return after first action.
- Reduced email or product engagement.
- Missed renewal or repeat windows.
- No response to lifecycle communication.
- Drop in account activity without support ticket.

**Scoring Impact**

Silent Churn primarily weakens:

- D2 — Movement Probability
- D3 — Transition Velocity
- D5 — Drop-Off Resilience
- D7 — Intervention Clarity

**AI Instrumentation**

AI may assist by:

- detecting churn risk signals,
- predicting disengagement,
- identifying inactivity patterns,
- recommending lifecycle interventions before value loss.

**Intervention Layers**

- Lifecycle Intervention
- Timing Intervention
- Sales-Assist Intervention
- Offer Intervention

**Related Failure Modes**

- One-Transaction Funnel
- Loyalty Blindness
- Lifecycle Disconnect

---

### 11.3 Loyalty Blindness

**Stable ID:** `tfo.t4.loyalty_blindness`
**Primary Vector:** T4 — Action → Loyalty
**Canonical Route:** `/failure-modes/loyalty-blindness/`
**Diagnostic Class:** Retention Extension Failure

**Definition**

Loyalty Blindness occurs when the organization measures first action but lacks visibility into whether that action becomes durable value.

The business counts conversion but does not govern continuity.

**Core Diagnostic Question**

> Is the organization measuring action while ignoring loyalty formation?

**Symptoms**

- Reports focus on acquisition and first conversion.
- Retention is not connected to funnel performance.
- Customer lifetime value is missing or poorly integrated.
- Repeat behavior is not tracked by source or segment.
- Marketing success is declared before retention is known.

**Detection Signals**

- No retention dashboard.
- No link between acquisition source and repeat value.
- Weak customer lifecycle metrics.
- No cohort retention analysis.
- No post-action engagement scoring.
- No loyalty or advocacy measurement.

**Scoring Impact**

Loyalty Blindness primarily weakens:

- D7 — Intervention Clarity
- D6 — Commercial Consequence
- Evidence Confidence for T4 outputs

**AI Instrumentation**

AI may assist by:

- identifying missing retention signals,
- linking acquisition cohorts to lifecycle outcomes,
- detecting measurement gaps,
- classifying segments with unknown loyalty behavior.

**Intervention Layers**

- Attribution Intervention
- Lifecycle Intervention
- Measurement Governance, governed under Attribution context

**Related Failure Modes**

- One-Transaction Funnel
- Silent Churn
- Measurement Gap

---

### 11.4 Advocacy Vacuum

**Stable ID:** `tfo.t4.advocacy_vacuum`
**Primary Vector:** T4 — Action → Loyalty
**Canonical Route:** `/failure-modes/advocacy-vacuum/`
**Diagnostic Class:** Retention Extension Failure

**Definition**

Advocacy Vacuum occurs when satisfied or retained customers do not become referrers, reviewers, case-study subjects, community participants, or public trust signals.

Continuity exists, but it does not amplify.

**Core Diagnostic Question**

> Does loyalty exist without becoming market-facing proof?

**Symptoms**

- Customers stay but do not refer.
- Few reviews despite satisfaction.
- Weak case study pipeline.
- Low user-generated proof.
- No advocacy program.
- Positive customer experience remains private.

**Detection Signals**

- High retention but low referral.
- Low review rate.
- Low social proof creation.
- Weak community participation.
- Low testimonial capture.
- No structured advocacy prompts.

**Scoring Impact**

Advocacy Vacuum primarily weakens:

- D6 — Commercial Consequence
- D7 — Intervention Clarity
- D2 — Movement Probability for loyalty extension

**AI Instrumentation**

AI may assist by:

- identifying likely advocates,
- detecting satisfied but inactive promoters,
- recommending advocacy timing,
- classifying customers suitable for reviews, referrals, or case studies.

**Intervention Layers**

- Lifecycle Intervention
- Timing Intervention
- Proof Intervention
- Offer Intervention

**Related Failure Modes**

- Loyalty Blindness
- Lifecycle Disconnect
- One-Transaction Funnel

---

### 11.5 Lifecycle Disconnect

**Stable ID:** `tfo.t4.lifecycle_disconnect`
**Primary Vector:** T4 — Action → Loyalty
**Canonical Route:** `/failure-modes/lifecycle-disconnect/`
**Diagnostic Class:** Retention Extension Failure

**Definition**

Lifecycle Disconnect occurs when post-action communication, onboarding, success, education, or re-engagement fails to continue the relationship after the first action.

The customer acts, but the system does not guide them into continuity.

**Core Diagnostic Question**

> Does the relationship lose structure after the first action?

**Symptoms**

- No effective onboarding after signup or purchase.
- Generic post-purchase messaging.
- Customers do not know the next step.
- Product activation is weak.
- Repeat behavior is not encouraged.
- Lifecycle communication is disconnected from customer state.

**Detection Signals**

- Low onboarding completion.
- Low product activation.
- Weak repeat purchase rate.
- Poor email lifecycle engagement.
- Drop in engagement after first conversion.
- Support tickets showing confusion after purchase or signup.

**Scoring Impact**

Lifecycle Disconnect primarily weakens:

- D2 — Movement Probability
- D3 — Transition Velocity
- D5 — Drop-Off Resilience
- D7 — Intervention Clarity

**AI Instrumentation**

AI may assist by:

- detecting post-action drop-off,
- predicting lifecycle stage needs,
- recommending next-best actions,
- identifying onboarding gaps,
- classifying customers by continuity probability.

**Intervention Layers**

- Lifecycle Intervention
- Timing Intervention
- UX Intervention
- Sales-Assist Intervention

**Related Failure Modes**

- Silent Churn
- One-Transaction Funnel
- Loyalty Blindness

---

## 12. Cross-Vector Diagnostic Constraint

### 12.1 Measurement Gap

**Stable ID:** `tfo.constraint.measurement_gap`
**Primary Classification:** Diagnostic Constraint
**Canonical Route:** `/failure-modes/measurement-gap/`
**Applies Across:** T1, T2, T3, T4

**Definition**

Measurement Gap occurs when the system cannot confidently assess a transition because the required evidence is missing, fragmented, inaccessible, or not tracked.

Measurement Gap is not a normal failure mode.

It is a diagnostic constraint that limits the confidence of ATI interpretation.

**Core Diagnostic Question**

> Is movement weak, or is the organization unable to measure movement clearly?

**Symptoms**

- Traffic and sales are measured, but intermediate movement is not.
- Engagement is tracked without intent signals.
- Retention is not connected to acquisition source.
- CRM and analytics data are disconnected.
- No evidence exists for a vector.
- Scanner responses rely only on belief or guesswork.

**Detection Signals**

- E0 or E1 evidence confidence.
- Missing analytics events.
- No CRM-stage linkage.
- No retention tracking.
- No vector-specific signals.
- Inconsistent reporting across systems.
- Unsupported claims about funnel performance.

**Scoring Impact**

Measurement Gap does not directly reduce ATI score.

Instead, it affects Evidence Confidence.

If evidence is E0, no numeric score should be issued.

If evidence is E1, the score must be described as provisional.

**AI Instrumentation**

AI may assist by:

- identifying missing signals,
- mapping disconnected measurement systems,
- detecting unsupported claims,
- suggesting which events or data sources must be captured.

**Intervention Layers**

- Attribution Intervention
- Measurement Governance under Attribution context
- Lifecycle Intervention when retention data is missing
- UX Intervention if event capture is tied to interaction design

**Related Failure Modes**

- Loyalty Blindness
- Attention Noise
- Passive Engagement
- Process Friction

---

## 13. Failure Mode Page Template

Every failure mode page must follow this structure.

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

This structure is mandatory for reference consistency.

---

## 14. Scanner Output Language

Scanner outputs must use controlled TFO language.

Correct:

> "Your weakest vector is T2 — Interest → Desire. The likely failure modes are Comparison Stall and Value Ambiguity."

Incorrect:

> "Your funnel is bad at converting people."

Correct:

> "This diagnosis is based on E1 Self-Reported Evidence and should be treated as provisional."

Incorrect:

> "AI knows why your funnel is failing."

Correct:

> "Measurement Gap limits the confidence of this diagnosis."

Incorrect:

> "No data means your funnel is broken."

---

## 15. Internal Linking Requirements

Every failure mode page must link to:

1. the parent vector page,
2. the ATI Standard,
3. the TFO overview page,
4. the scanner,
5. at least two related failure modes where applicable,
6. at least one intervention-layer page where applicable,
7. methodology or governance page where evidence rules are discussed.

Every vector page must link to all failure modes under that vector.

Every scanner result must link to the relevant failure mode pages.

No orphan nodes.

No dead ends.

The internal linking graph must make the ontology navigable for humans and AI agents.

---

## 16. SEO and Reference Architecture Rules

TFO pages are reference pages, not keyword pages.

A failure mode page may target search demand, but search demand does not justify the page.

The ontology justifies the page.

Allowed SEO behavior:

- precise definitions,
- durable URLs,
- structured headings,
- internal links,
- schema-friendly summaries,
- glossary support where useful,
- canonical vector relationships,
- comparison between related failure modes.

Prohibited SEO behavior:

- thin failure-mode pages,
- duplicate definitions,
- generated bulk pages,
- vague marketing advice,
- unrelated MarTech trend pages,
- affiliate-driven tool lists,
- keyword stuffing,
- orphaned glossary entries,
- fake benchmark claims.

SEO must emerge from reference authority.

---

## 17. Agent-Readable Ontology Structure

TFO must be available in machine-readable form.

Required future file:

- `/data/tfo-failure-modes.json`

Recommended object structure:

```json
{
  "id": "tfo.t3.trust_deficit",
  "name": "Trust Deficit",
  "vector_id": "ati.vector.t3",
  "transition": "Desire → Action",
  "diagnostic_class": "Conversion Friction Failure",
  "canonical_route": "/failure-modes/trust-deficit/",
  "definition": "Trust Deficit occurs when the prospect wants the offer but does not trust the seller, product, process, proof, payment, claim, or next step enough to act.",
  "intervention_layers": [
    "Proof Intervention",
    "UX Intervention",
    "Sales-Assist Intervention"
  ],
  "related_failure_modes": [
    "tfo.t3.objection_residue",
    "tfo.t3.price_shock",
    "tfo.t2.preference_dilution"
  ]
}
```

Machine-readable definitions must match public page definitions.

No hidden contradictory definitions are permitted.

---

## 18. Launch Ontology Inventory

Initial ratified TFO v1.0 contains 21 failure modes and 1 cross-vector diagnostic constraint.

**T1 — Signal Conversion Failures**

1. `tfo.t1.attention_noise`
2. `tfo.t1.vanity_reach`
3. `tfo.t1.audience_mismatch`
4. `tfo.t1.signal_decay`
5. `tfo.t1.message_blur`

**T2 — Intent Formation Failures**

1. `tfo.t2.passive_engagement`
2. `tfo.t2.comparison_stall`
3. `tfo.t2.preference_dilution`
4. `tfo.t2.intent_evaporation`
5. `tfo.t2.value_ambiguity`

**T3 — Conversion Friction Failures**

1. `tfo.t3.process_friction`
2. `tfo.t3.trust_deficit`
3. `tfo.t3.price_shock`
4. `tfo.t3.decision_delay`
5. `tfo.t3.complexity_wall`
6. `tfo.t3.objection_residue`

**T4 — Retention Extension Failures**

1. `tfo.t4.one_transaction_funnel`
2. `tfo.t4.silent_churn`
3. `tfo.t4.loyalty_blindness`
4. `tfo.t4.advocacy_vacuum`
5. `tfo.t4.lifecycle_disconnect`

**Cross-Vector Constraint**

1. `tfo.constraint.measurement_gap`

---

## 19. Governance and Versioning

TFO is versioned.

AIDAtanaly uses sequential document versioning.

Change severity is recorded in the decision log as Patch Change, Minor Change, or Major Change and is not encoded directly into the version number.

### 19.1 Patch Change

A wording correction or clarification that does not affect failure mode meaning, scanner outputs, or route structure.

Examples:

- typo correction,
- definition clarification,
- internal link update.

### 19.2 Minor Change

An additive change that preserves compatibility.

Examples:

- adding a new related failure mode,
- adding an example,
- adding a detection signal,
- adding a route note,
- adding a non-scoring explanation.

### 19.3 Major Change

A change that affects ontology meaning, scanner classification, or public reference structure.

Examples:

- adding a new failure mode,
- removing a failure mode,
- changing a failure mode's primary vector,
- changing stable ID structure,
- changing canonical route structure,
- changing Measurement Gap classification,
- changing intervention-layer registry.

Major changes require:

- decision log entry,
- version update,
- compatibility statement,
- route impact statement where applicable,
- scanner impact statement where applicable.

---

## 20. Public Claim Language

Allowed language:

> "AIDAtanaly introduces the Transition Failure Ontology."

> "TFO is a governed taxonomy for classifying movement failure across AIDA transition vectors."

> "TFO helps explain why transition health may be weak."

> "Scanner outputs use TFO-governed failure mode language."

Prohibited language:

> "TFO is the industry standard."

> "TFO proves the exact cause of funnel failure."

> "This failure mode guarantees revenue loss."

> "AI knows the cause without evidence."

> "All funnels fail for these reasons only."

Authority must be earned through consistent use, reference quality, and adoption.

---

## 21. Closing Ontology Declaration

The Transition Failure Ontology exists because funnel weakness should not remain vague.

AIDAtanaly does not merely say that a funnel is weak.

It identifies which transition is weak, what class of failure is present, what evidence supports the diagnosis, and which intervention layer is indicated.

ATI measures transition health.

TFO explains transition failure.

Together they turn funnel analytics into governed movement intelligence.

> Stages are states. Value lives in transitions.

---

**AIDAtanaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.**
