# DECISION_SCANNER_MODEL_1_0_INITIAL_RATIFICATION.md

## AIDAtanaly.com — Scanner Model v1.0 Initial Ratification Decision

**Document Class:** Governance Decision Log
**Asset:** AIDAtanaly.com
**Applies to:** `SCANNER_MODEL.md`
**Decision ID:** SCAN-MOD-001
**Decision Type:** Initial Ratification
**Status:** Ratified
**Ratified by:** Sohadot — System Operator
**Date:** 2026-06-12
**Resulting Version:** Scanner Model v1.0

---

## 1. Decision Summary

This decision ratifies `SCANNER_MODEL.md` as the governing operational model for the AIDAtanaly Transition Scanner v1.

The scanner model converts AIDAtanaly's doctrine, measurement standard, failure ontology, route architecture, and interface governance into a controlled diagnostic engine.

The scanner operationalizes the governing thesis:

> Stages are states. Value lives in transitions.

Scanner Model v1.0 is ratified as the first governed diagnostic engine layer for AIDAtanaly.

---

## 2. Ratified Scope

Scanner Model v1.0 ratifies:

- the six scanner input categories,
- the five-point answer scale,
- the Evidence Confidence assignment model,
- the D1–D7 scoring dimensions,
- the ATI vector scoring formula,
- the equal-weight composite ATI model,
- the diagnostic class thresholds,
- the T1–T4 question models,
- the TFO failure-mode mappings,
- the Measurement Gap handling rule,
- the failure-mode assignment logic,
- the intervention-layer mapping,
- the scanner output model,
- the agent-readable output structure,
- the scanner UI governance rules,
- the reference-linking requirements,
- the monetization boundary,
- and the quality gate checklist.

---

## 3. Relationship to Prior Governance

Scanner Model v1.0 is governed by:

- `FOUNDATION_DOCTRINE.md`
- `ASSET_THESIS.md`
- `ATI_STANDARD.md`
- `TFO_ONTOLOGY.md`
- `ROUTE_MAP.md`
- `INTERFACE_GOVERNANCE.md`

The scanner must not contradict any ratified doctrine, standard, ontology, route rule, or interface rule.

Specifically:

- it must measure transitions, not stages,
- it must use ATI D1–D7 scoring dimensions,
- it must keep Evidence Confidence separate from score,
- it must use TFO-governed failure mode IDs,
- it must link outputs to canonical routes,
- and it must visually separate score from evidence confidence.

---

## 4. Ratified Evidence Confidence Handling

Scanner Model v1.0 ratifies Evidence Confidence as mandatory for every vector output.

Evidence Confidence must be reported separately from ATI score.

Evidence Confidence must never be mathematically included in ATI score.

The scanner must use the E0–E4 scale:

- E0 — Absent Evidence
- E1 — Self-Reported Evidence
- E2 — Observable Evidence
- E3 — Multi-Source Evidence
- E4 — Validated Evidence

E0 outputs must not display numeric scores.

E1 outputs must use provisional language.

E2 outputs must use indicative language.

E3 and E4 may use stronger confidence language but must not imply guaranteed causality.

---

## 5. Partial Profile Rule

This decision explicitly ratifies the Partial Profile Rule.

If one or more ATI vectors are assigned E0 Absent Evidence, the scanner must not issue a clean composite ATI score.

Instead, the scanner must issue a partial profile.

Correct output:

```
ATI Profile: Partial
Scorable vectors: T1, T2, T3
Unscorable vector: T4 / E0 Absent Evidence
```

Incorrect output:

```
ATI Score: 61.5
```

when any vector is E0.

This rule is an operational extension of ATI Standard v1.1's E0 principle.

It preserves measurement integrity by preventing missing evidence from being disguised as a complete diagnostic score.

---

## 6. Ratified Scoring Model

Scanner Model v1.0 uses the seven ATI scoring dimensions:

| Dimension | Weight |
|---|---|
| D1 — Signal Quality | 17% |
| D2 — Movement Probability | 23% |
| D3 — Transition Velocity | 11% |
| D4 — Friction Resilience | 17% |
| D5 — Drop-Off Resilience | 12% |
| D6 — Commercial Consequence | 10% |
| D7 — Intervention Clarity | 10% |

Total: 100%

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

Evidence Confidence is not part of this formula.

---

## 7. Ratified Diagnostic Classes

Scanner Model v1.0 uses the ATI diagnostic classes exactly as defined in `ATI_STANDARD.md`.

| Score Range | Diagnostic Class |
|---|---|
| 85–100 | Transition Strong |
| 70–84 | Transition Functional |
| 55–69 | Transition Unstable |
| 40–54 | Transition Constrained |
| 0–39 | Transition Critical |

The scanner interface must not visually exaggerate or soften these classes.

A score of 48 must not look like a score of 85.

---

## 8. Ratified Failure-Mode Mapping

Scanner Model v1.0 maps scanner answers to the 21 ratified TFO failure modes and the Measurement Gap diagnostic constraint.

The scanner may assign only failure modes already ratified in `TFO_ONTOLOGY.md`.

No scanner output may invent a new failure mode.

No scanner output may assign a failure mode without sufficient pattern support.

Measurement Gap remains a diagnostic constraint, not a normal failure mode.

---

## 9. Output Governance

Scanner outputs must include:

- composite ATI status or partial profile status,
- T1 vector result,
- T2 vector result,
- T3 vector result,
- T4 vector result,
- weakest vector,
- strongest vector,
- Evidence Confidence per vector,
- primary failure mode,
- secondary failure mode where applicable,
- recommended intervention layer,
- and reference links.

Scanner outputs must use controlled diagnostic language.

They must not claim exact causality, guaranteed revenue improvement, or unsupported AI certainty.

---

## 10. Reference Linking Rule

Every scanner result must link to canonical routes once the public pages exist.

Required links include:

- ATI score → `/aida-transition-index/`
- Evidence Confidence → `/evidence-confidence/`
- vector names → `/vectors/{vector-route}/`
- TFO failure modes → `/failure-modes/{slug}/`
- intervention layers → `/intervention-layers/`
- Measurement Gap → `/failure-modes/measurement-gap/`
- methodology explanation → `/methodology/`

No scanner output may mention a governed failure mode without linking to its canonical reference page after public launch.

---

## 11. Interface Compliance

Scanner Model v1.0 must comply with `INTERFACE_GOVERNANCE.md`.

The scanner interface must:

- show the transition axis,
- represent T1–T4 as movement,
- keep score and Evidence Confidence visually separate,
- show E0 as Unscorable,
- avoid gamified scoring,
- avoid decorative motion,
- support reduced motion,
- and remain understandable without hidden interactions.

The scanner must feel like a governed diagnostic system, not a marketing quiz.

---

## 12. Monetization Boundary

Scanner Model v1.0 may support monetization through:

- free ATI Snapshot,
- paid Transition Diagnostic Brief,
- advanced Transition Audit intake,
- downloadable structured report,
- professional audit request,
- future API access,
- and future licensing path.

The scanner must not use:

- fear-based manipulation,
- fake urgency,
- guaranteed revenue claims,
- paid ranking of tools,
- generic affiliate banners,
- unqualified lead selling,
- or intentionally weakened free outputs.

The free scanner must provide real diagnostic value.

Paid outputs may deepen the diagnosis but must not repair an intentionally incomplete free experience.

---

## 13. Quality Gate Ratification

The Scanner Model v1.0 quality gates are ratified as required pre-release checks.

The scanner must verify:

- D1–D7 weights total 100%,
- vector weights total 100%,
- Evidence Confidence is not included in score,
- E0 does not output numeric score,
- diagnostic class thresholds match ATI Standard,
- composite score is not issued when any vector is E0,
- every failure mode ID exists in TFO,
- every failure mode has a canonical route in Route Map,
- Measurement Gap is treated as a diagnostic constraint,
- score and Evidence Confidence are visually separate,
- and scanner result links point only to valid public routes.

---

## 14. Compatibility Statement

This is the initial ratification of Scanner Model v1.0.

No prior public scanner model was issued.

No public scanner outputs, reports, APIs, or user-facing diagnostic results depend on an earlier scanner model.

No migration is required.

Future scanner implementation must comply with this model.

---

## 15. Governance Impact

This decision strengthens AIDAtanaly by establishing the first operational engine layer.

It converts the asset from a governed reference system into a diagnostic system.

The scanner creates:

- usable transition intelligence,
- structured failure classification,
- evidence-qualified outputs,
- reference-linked diagnosis,
- monetization-ready reporting,
- future JSON/API readiness,
- and buyer-facing proof that the asset is not merely content.

The scanner is the operational bridge between category doctrine and category utility.

---

## 16. Repository Handling

The final root-level scanner model must remain:

```
SCANNER_MODEL.md
```

This decision record must be archived under:

```
governance/decisions/DECISION_SCANNER_MODEL_1_0_INITIAL_RATIFICATION.md
```

This preserves both:

1. a clean readable scanner model,
2. an auditable governance trail for its initial ratification.

---

## 17. Future JSON Implementation

This decision confirms that a future machine-readable implementation may be created at:

```
/data/scanner-model.json
```

That JSON file must match `SCANNER_MODEL.md`.

It must not introduce hidden contradictory scoring logic.

It must preserve:

- vector IDs,
- question IDs,
- dimension mappings,
- answer scale,
- Evidence Confidence rules,
- failure mode mappings,
- intervention mappings,
- diagnostic thresholds,
- output templates,
- and canonical routes.

---

## 18. Closing Decision

Scanner Model v1.0 is ratified as the governing operational diagnostic model for AIDAtanaly.

ATI measures transition health.

TFO explains transition failure.

The scanner turns both into usable diagnostic output.

It measures movement.

It qualifies confidence.

It classifies failure.

It links diagnosis to reference architecture.

It supports monetization without degrading trust.

> Stages are states. Value lives in transitions.

---

**AIDAtanaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.**
