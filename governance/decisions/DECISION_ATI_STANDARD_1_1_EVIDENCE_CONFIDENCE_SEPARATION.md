# DECISION_ATI_STANDARD_1_1_EVIDENCE_CONFIDENCE_SEPARATION.md
 
## AIDAtanaly.com — ATI Standard v1.1 Major Change Decision
 
**Document Class:** Governance Decision Log **Asset:** AIDAtanaly.com **Applies to:** `ATI_STANDARD.md` **Decision ID:** ATI-STD-001 **Decision Type:** Major Change **Status:** Ratified **Ratified by:** Sohadot — System Operator **Date:** 2026-06-11 **Supersedes:** ATI Standard v1.0 scoring model **Resulting Version:** ATI Standard v1.1
  
## 1. Decision Summary
 
This decision ratifies a Major Change to the AIDA Transition Index Standard.
 
ATI Standard v1.0 included **Evidence Confidence** as a scoring dimension worth 10% of each vector score, while also stating that confidence is not the same as score.
 
That created a measurement contradiction.
 
ATI Standard v1.1 resolves the contradiction by separating transition health from evidence reliability.
 
 
**ATI Score = transition health** **Evidence Confidence = reliability of the score**
 
 
Evidence Confidence is no longer included in the mathematical scoring formula.
 
It is now reported as a mandatory parallel qualifier using the E0–E4 evidence confidence scale.
  
## 2. Classification
 
This change is classified as a **Major Change** under the ATI Standard change-control rules because it changes the mathematical interpretation of the scoring model.
 
The change includes:
 
 
1. removal of Evidence Confidence as a scoring dimension,
 
2. redistribution of scoring weights across the remaining seven dimensions,
 
3. renaming of D4 and D5 for positive-direction consistency,
 
4. separation of score from reliability metadata,
 
5. revised scanner output structure,
 
6. revised governance rules for evidence confidence handling.
 

  
## 3. Versioning Note
 
AIDAtanaly uses sequential document versioning.
 
Change severity is recorded in the decision log as **Patch Change**, **Minor Change**, or **Major Change** and is not encoded directly into the version number.
 
Therefore, a Major Change may result in a sequential version update such as **v1.0 → v1.1** when no public outputs, external consumers, or migration obligations exist.
  
## 4. Compatibility Statement
 
**No public outputs were issued under ATI Standard v1.0; no migration is required.**
 
ATI Standard v1.0 was ratified internally before public deployment, scanner release, report generation, API output, or external diagnostic use.
 
Therefore:
 
 
- no public score needs recalculation,
 
- no user report needs migration,
 
- no scanner output needs correction,
 
- no API consumer is affected,
 
- and no public compatibility notice is required beyond this governance decision.
 

  
## 5. Problem Identified
 
The v1.0 model stated:
 
 
“Confidence is not the same as score.”
 
 
However, Evidence Confidence was also included as **D8**, weighted at 10% of the vector score.
 
This created a double-penalty problem:
 
 
- a funnel with strong transition movement but weak measurement evidence could receive a lower movement score,
 
- while also being marked with low evidence confidence.
 

 
This mixed two distinct concepts:
 
 
1. the quality of the movement,
 
2. the reliability of the measurement.
 

 
The model needed to preserve both without conflating them.
  
## 6. Ratified Resolution
 
ATI Standard v1.1 adopts the following rule:
 
 
**ATI measures movement quality. Evidence Confidence qualifies the reliability of that measurement.**
 
 
The scoring model now uses seven dimensions:
 
  
 
Dimension
 
Weight
 
   
 
D1 — Signal Quality
 
17%
 
 
 
D2 — Movement Probability
 
23%
 
 
 
D3 — Transition Velocity
 
11%
 
 
 
D4 — Friction Resilience
 
17%
 
 
 
D5 — Drop-Off Resilience
 
12%
 
 
 
D6 — Commercial Consequence
 
10%
 
 
 
D7 — Intervention Clarity
 
10%
 
  
 
Total: **100%**
 
Evidence Confidence is reported separately as:
 
 
- **E0 — Absent Evidence**
 
- **E1 — Self-Reported Evidence**
 
- **E2 — Observable Evidence**
 
- **E3 — Multi-Source Evidence**
 
- **E4 — Validated Evidence**
 

  
## 7. Naming Correction
 
The following dimension names are updated for scoring-direction consistency.
 
### Previous
 
 
- D4 — Friction Resistance
 
- D5 — Drop-Off Exposure
 

 
### Ratified
 
 
- D4 — Friction Resilience
 
- D5 — Drop-Off Resilience
 

 
### Reason
 
Both dimensions must be positive-direction scoring dimensions.
 
A higher value should always indicate stronger transition health.
 
 
- High **Friction Resilience** indicates that friction is low, controlled, or unlikely to block movement.
 
- High **Drop-Off Resilience** indicates that the transition is less exposed to abandonment before the next state is reached.
 

 
This removes inverted scoring ambiguity and improves scanner implementability.
  
## 8. Evidence Confidence Rules
 
The following evidence rules are ratified:
 
 
1. Evidence Confidence must be reported separately from ATI score.
 
2. Evidence Confidence must never be mathematically included in ATI score.
 
3. E0 outputs must not issue numeric scores.
 
4. E1 outputs must use provisional language.
 
5. E2 outputs must use indicative language.
 
6. E3 and E4 outputs may use stronger confidence language but must not imply guaranteed causality.
 
7. Evidence Confidence qualifies the interpretation of the score but does not change the score itself.
 

 
Correct output:
 `T2 Score: 48 / E2 Observable Evidence ` 
Incorrect output:
 `T2 Score reduced because evidence confidence is weak ` 
Low evidence confidence limits claim strength.
 
It does not automatically reduce the transition score.
  
## 9. Scanner and JSON Implications
 
Scanner and agent-readable outputs must separate score from evidence confidence.
 
Correct structure:
 `{   "vector_id": "ati.vector.t2",   "score": 48,   "diagnostic_class": "Transition Constrained",   "evidence_confidence": {     "level": "E2",     "name": "Observable Evidence"   },   "failure_modes": [     "tfo.t2.comparison_stall",     "tfo.t2.value_ambiguity"   ] } ` 
Incorrect structure:
 `{   "vector_id": "ati.vector.t2",   "score": 48,   "evidence_confidence_weight": 0.10 } ` 
Evidence Confidence is metadata about reliability.
 
It is not a score component.
  
## 10. Repository Handling
 
The final root-level standard must be a single clean file:
 `ATI_STANDARD.md ` 
It must contain the unified ATI Standard v1.1 content.
 
The patch itself must not remain as a competing root-level standard.
 
This decision record should be archived under:
 `governance/decisions/DECISION_ATI_STANDARD_1_1_EVIDENCE_CONFIDENCE_SEPARATION.md ` 
This preserves both:
 
 
1. a clean readable standard,
 
2. an auditable governance trail.
 

  
## 11. Governance Impact
 
This decision strengthens the ATI Standard by improving:
 
 
- measurement integrity,
 
- scoring purity,
 
- scanner implementability,
 
- agent-readable structure,
 
- auditability,
 
- public claim restraint,
 
- and buyer-facing trust.
 

 
The resulting standard is more rigorous because it separates what is being measured from how confidently it is being measured.
  
## 12. Resulting ATI v1.1 Scoring Model
 
ATI Standard v1.1 uses the following vector score formula:
 `Vector Score = (D1 × 0.17) + (D2 × 0.23) + (D3 × 0.11) + (D4 × 0.17) + (D5 × 0.12) + (D6 × 0.10) + (D7 × 0.10) ` 
Where:
 
 
- **D1 — Signal Quality**
 
- **D2 — Movement Probability**
 
- **D3 — Transition Velocity**
 
- **D4 — Friction Resilience**
 
- **D5 — Drop-Off Resilience**
 
- **D6 — Commercial Consequence**
 
- **D7 — Intervention Clarity**
 

 
All seven dimensions are positive-direction dimensions.
 
A higher score always indicates stronger transition health.
 
Evidence Confidence is not part of this formula.
  
## 13. Required Integration into ATI_STANDARD.md
 
The unified `ATI_STANDARD.md` v1.1 must reflect this decision by:
 
 
1. removing Evidence Confidence as D8,
 
2. replacing the old eight-dimension scoring model with the seven-dimension model,
 
3. renaming D4 and D5,
 
4. treating Evidence Confidence as a mandatory parallel qualifier,
 
5. prohibiting numeric scores for E0 outputs,
 
6. separating `score` from `evidence_confidence` in scanner and JSON structures,
 
7. updating governance rules to prevent Evidence Confidence from being mathematically included in ATI score,
 
8. preserving a clean root-level standard without patch language.
 

  
## 14. Closing Decision
 
ATI Standard v1.1 is ratified as the governing measurement standard for AIDAtanaly.
 
The score measures movement.
 
The evidence level measures confidence.
 
The two remain connected, but they are not the same.
 
 
**Stages are states. Value lives in transitions.**
 
 
*AIDAtanaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.
