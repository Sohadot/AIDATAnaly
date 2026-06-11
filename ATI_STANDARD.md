# ATI_STANDARD.md — Version 1.1 Hardening Patch
 
## AIDAtanaly.com — Evidence Confidence Separation
 
**Patch Class:** Measurement Integrity Patch **Applies to:** `ATI_STANDARD.md` **Previous Version:** 1.0 **New Version:** 1.1 **Status:** Ratified Patch **Date:** 2026-06-11
  
## 1. Patch Purpose
 
This patch resolves a measurement contradiction in ATI Standard v1.0.
 
In v1.0, **Evidence Confidence** was described as separate from score, but also included as 10% of the vector scoring formula.
 
That creates a conceptual error:
 
 
- the ATI score should measure **transition quality**;
 
- the evidence level should measure **confidence in the score**.
 

 
A funnel with strong movement but weak measurement should not receive a lower movement score simply because evidence is incomplete. It should receive a movement score marked with lower evidence confidence.
 
Therefore, Version 1.1 removes Evidence Confidence from the mathematical score and treats it as a mandatory parallel qualifier.
  
## 2. Governing Rule
 
 
**ATI measures movement quality. Evidence Confidence qualifies the reliability of that measurement.**
 
 
The two must not be merged.
 
Correct output:
 `T2 Score: 48 / E2 Observable Evidence ` 
Incorrect output:
 `T2 Score reduced because evidence confidence is weak ` 
Low evidence confidence limits claim strength.
 
It does not automatically reduce the transition score.
  
## 3. Replacement for Section 7 — Core Scoring Dimensions
 
Replace Section 7 with the following:
  
## 7. Core Scoring Dimensions
 
Each vector is scored using seven governed dimensions.
 
Evidence Confidence is not part of the score. It is reported as a parallel qualifier under Section 9.
 
  
 
Dimension
 
Weight
 
Scoring Direction
 
   
 
D1 — Signal Quality
 
17%
 
Higher is better
 
 
 
D2 — Movement Probability
 
23%
 
Higher is better
 
 
 
D3 — Transition Velocity
 
11%
 
Higher is better
 
 
 
D4 — Friction Resilience
 
17%
 
Higher is better
 
 
 
D5 — Drop-Off Resilience
 
12%
 
Higher is better
 
 
 
D6 — Commercial Consequence
 
10%
 
Higher is better
 
 
 
D7 — Intervention Clarity
 
10%
 
Higher is better
 
  
 
Total: **100%**
 
Each dimension is scored from 0 to 100.
 
The vector score is calculated as:
 `Vector Score = (D1 × 0.17) + (D2 × 0.23) + (D3 × 0.11) + (D4 × 0.17) + (D5 × 0.12) + (D6 × 0.10) + (D7 × 0.10) ` 
All seven dimensions are positive-direction dimensions.
 
A higher score always indicates stronger transition health.
 
Evidence Confidence is reported separately as **E0–E4**.
  
## 4. Dimension Naming Correction
 
The following naming changes are adopted for conceptual consistency:
 
### Old
 
 
- D4 — Friction Resistance
 
- D5 — Drop-Off Exposure
 

 
### New
 
 
- D4 — Friction Resilience
 
- D5 — Drop-Off Resilience
 

 
Reason:
 
Both dimensions should be positive-direction scoring dimensions.
 
 
- High **Friction Resilience** means the transition can withstand or overcome friction.
 
- High **Drop-Off Resilience** means the transition is less exposed to abandonment.
 

 
This removes the need for inverted scoring language and makes the model easier to implement in scanner logic.
  
## 5. Replacement for D4 Definition
 
Replace the old D4 definition with the following:
  
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
  
## 6. Replacement for D5 Definition
 
Replace the old D5 definition with the following:
  
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
  
## 7. Remove D8 from Scoring
 
Remove the old D8 section from the scoring dimensions.
 
D8 — Evidence Confidence is retired as a scoring dimension.
 
Evidence Confidence remains mandatory, but it becomes an independent qualifier governed by Section 9.
  
## 8. Replacement for Section 9 — Evidence Confidence Qualifier
 
Replace Section 9 with the following:
  
## 9. Evidence Confidence Qualifier
 
Evidence Confidence measures the reliability of the evidence supporting an ATI score.
 
Confidence is not the same as score.
 
The ATI score measures transition quality.
 
Evidence Confidence measures how much trust should be placed in that score.
 
Every ATI output must include or imply an evidence confidence level.
 
  
 
Level
 
Name
 
Description
 
Output Treatment
 
   
 
E0
 
Absent Evidence
 
No meaningful evidence available
 
Numeric score should not be issued
 
 
 
E1
 
Self-Reported Evidence
 
Based mainly on user answers or internal belief
 
Provisional score allowed
 
 
 
E2
 
Observable Evidence
 
Based on visible metrics, behavior, or reported funnel data
 
Indicative score allowed
 
 
 
E3
 
Multi-Source Evidence
 
Based on multiple signals across channels or systems
 
Strong score allowed
 
 
 
E4
 
Validated Evidence
 
Based on tracked, repeated, and verifiable data patterns
 
Validated score allowed
 
  
 
### 9.1 E0 Rule
 
If Evidence Confidence is **E0**, ATI should not issue a numeric score.
 
Correct output:
 `T3: Unscorable / E0 Absent Evidence ` 
Incorrect output:
 `T3: 22 / E0 Absent Evidence ` 
When evidence is absent, the correct diagnosis is a measurement gap, not a numeric certainty.
 
### 9.2 E1 Rule
 
E1 scores are allowed but must be described as provisional.
 
Example:
 `T2 Score: 46 / E1 Self-Reported Evidence ` 
Public language:
 
 
“This is a provisional diagnostic score based on self-reported inputs.”
 
 
### 9.3 E2 Rule
 
E2 scores are allowed as indicative.
 
Example:
 `T1 Score: 72 / E2 Observable Evidence ` 
Public language:
 
 
“This score is indicative and based on observable or reported funnel signals.”
 
 
### 9.4 E3–E4 Rule
 
E3 and E4 scores may be described with stronger confidence language.
 
However, even E4 does not permit revenue guarantees or unsupported causal certainty.
 
Evidence Confidence strengthens the reliability of the interpretation.
 
It does not turn the score into a guarantee.
  
## 9. Replacement for Section 11 Example
 
Replace the example in Section 11 with the following:
  
## 11. Composite ATI Scoring
 
The composite ATI score is calculated as:
 `ATI = (T1 + T2 + T3 + T4) / 4 ` 
Default v1.1 uses equal vector weighting.
 
Each vector score must be accompanied by an Evidence Confidence qualifier.
 
### Example
 `T1 = 76 / E2 T2 = 48 / E2 T3 = 62 / E1 T4 = 39 / E1  ATI = (76 + 48 + 62 + 39) / 4 ATI = 56.25 ` 
Composite diagnostic class:
 `ATI 56.25 — Transition Unstable Composite Evidence Confidence: Mixed E1–E2 ` 
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
  
## 10. Replacement for Section 18 Governance Rules
 
Add or replace the relevant governance rules with the following:
  
## 18. Governance Rules
 
ATI is governed by the following rules:
 
 
1. ATI must always score transitions, not stages.
 
2. T1–T4 names are fixed.
 
3. Preference and intent remain sub-signals inside T2.
 
4. T4 remains Action → Loyalty and must not be removed.
 
5. Scanner outputs must map to T1–T4.
 
6. Failure modes must map to TFO.
 
7. Evidence Confidence must be reported separately from ATI score.
 
8. Evidence Confidence must never be mathematically included in the ATI score.
 
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
 

  
## 11. JSON Model Update
 
The scanner model should separate `score` from `evidence_confidence`.
 
Correct structure:
 `{   "vector_id": "ati.vector.t2",   "score": 48,   "diagnostic_class": "Transition Constrained",   "evidence_confidence": {     "level": "E2",     "name": "Observable Evidence"   },   "failure_modes": [     "tfo.t2.comparison_stall",     "tfo.t2.value_ambiguity"   ] } ` 
Incorrect structure:
 `{   "vector_id": "ati.vector.t2",   "score": 48,   "evidence_confidence_weight": 0.10 } ` 
Evidence Confidence is metadata about reliability.
 
It is not a score component.
  
## 12. Version Status
 
After applying this patch, `ATI_STANDARD.md` should be treated as:
 
**Status:** Ratified **Version:** 1.1 **Date:** 2026-06-11 **Document Class:** Measurement Standard **Layer:** 2 — Index / Standard Layer
  
## 13. Closing Patch Declaration
 
This patch strengthens ATI by preserving the conceptual purity of the standard.
 
The score measures movement.
 
The evidence level measures confidence.
 
The two are connected, but they are not the same.
 
 
**ATI Score = transition health** **Evidence Level = reliability of the score**
 
 
This separation makes the AIDA Transition Index more rigorous, more auditable, more implementable, and more trustworthy.
 
*AIDAtanaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.*
