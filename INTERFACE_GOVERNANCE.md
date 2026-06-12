# INTERFACE_GOVERNANCE.md

## AIDAtanaly.com — Flow Made Visible Interface Standard

**Document Class:** Interface Standard
**Layer:** 5 — Interface / Experience Governance Layer
**Asset:** AIDAtanaly.com
**Governed by:** FOUNDATION_DOCTRINE.md, ASSET_THESIS.md, ATI_STANDARD.md, TFO_ONTOLOGY.md, and ROUTE_MAP.md
**Status:** Ratified
**Version:** 1.0
**Date:** 2026-06-12
**Ratified by:** Sohadot — System Operator

---

## 1. Purpose of This Standard

This document defines the governed interface standard for AIDAtanaly.com.

Its purpose is to ensure that the public surface of the asset does not merely contain the doctrine, the standard, and the ontology, but visibly embodies them.

The governing rule of this document is:

> The interface must not decorate the asset. It must embody the asset's thesis.

AIDAtanaly is not an ordinary MarTech website.

It is a reference system about movement between states.

Therefore the interface itself must communicate movement, friction, resilience, and transition health — before a single paragraph is read.

A visitor who sees AIDAtanaly for three seconds must perceive:

> This site is about what happens between stages.

---

## 2. Governing Principle: Flow Made Visible

The doctrine states:

> Stages are states. Value lives in transitions.

The interface translation of this doctrine is:

**States are rendered as stable positions. Transitions are rendered as visible movement.**

This produces five interface laws:

1. Stages appear as fixed, calm, clearly bounded nodes.
2. Transitions appear as directional, animated, or visually energized connections between nodes.
3. Visual emphasis always belongs to the connection, not the node.
4. Friction, decay, and drop-off are visualized as interruptions or weakening of flow.
5. Health and resilience are visualized as continuity and strength of flow.

Any interface element that inverts this hierarchy — making stages dominant and transitions invisible — violates this standard.

---

## 3. What the Interface Must Communicate

Every page archetype, in order of priority, must communicate:

1. **The four governed vectors** — T1, T2, T3, T4 — as the spine of the system.
2. **Movement** — the user should perceive direction: Attention → Interest → Desire → Action → Loyalty.
3. **Diagnosis** — weakness has a class, a name, and a place; it is not vague.
4. **Evidence discipline** — scores are qualified, never oversold.
5. **Governed authority** — restrained, precise, documented; never hype.

The interface must never communicate:

- generic SaaS marketing energy,
- artificial urgency,
- inflated certainty,
- decorative complexity,
- or trend-chasing aesthetics.

---

## 4. Design Language Foundations

### 4.1 Layout Grammar

The layout grammar of AIDAtanaly is the **transition axis**.

- The primary visual motif is a horizontal (desktop) or vertical (mobile) axis of four transitions connecting five states.
- Vector pages occupy one segment of this axis and must show their position within it.
- Failure mode pages anchor themselves to their parent vector's segment.
- The scanner output renders the full axis with per-vector health.

Whitespace is structural. Density is reserved for reference content. Diagrams are reserved for movement.

### 4.2 Typography

- One serif or high-character display family for doctrine-level statements and page titles.
- One neutral, highly legible family for reference body text.
- One monospace family for stable IDs (`tfo.*`, `ati.*`), routes, and data structures.

Stable IDs and canonical routes must always render in monospace. They are system artifacts, not prose.

Type hierarchy must allow long reference pages to be scanned: one `<h1>`, governed heading levels, no decorative heading skips.

### 4.3 Color System

The palette is semantic, not decorative.

| Color Role | Usage | Rule |
|---|---|---|
| State color | Stage nodes (Attention, Interest, Desire, Action, Loyalty) | Calm, neutral, recessive |
| Transition color | Vector connections, movement lines, flow emphasis | The most saturated and energetic color in the system |
| Diagnostic scale | Transition Strong → Transition Critical | Governed five-step scale, see below |
| Evidence neutral | Evidence Confidence badges E0–E4 | Neutral/metadata tones only |
| Surface | Backgrounds, cards, structure | Quiet, high-contrast-compatible |

**Diagnostic class scale**

The five diagnostic classes from the ATI Standard map to a fixed ordinal color scale:

| Diagnostic Class | Visual Treatment |
|---|---|
| Transition Strong (85–100) | Strongest positive tone |
| Transition Functional (70–84) | Positive tone |
| Transition Unstable (55–69) | Caution tone |
| Transition Constrained (40–54) | Warning tone |
| Transition Critical (0–39) | Critical tone |

**Evidence Confidence color rule**

Evidence Confidence (E0–E4) must never use the diagnostic class scale.

Evidence badges use neutral metadata styling, visually distinct from score coloring.

This is the visual enforcement of ATI Governance Rules 7 and 8: confidence qualifies the score; it is not part of the score. The interface must make this separation visible, not just textual.

**E0 visual rule**

An E0 (Absent Evidence) state must never render a numeric score visual. It renders an explicit "Unscorable" state with a measurement-gap treatment.

---

## 5. Motion Governance

Motion is a semantic instrument, not an ornament.

### 5.1 When Motion Is Required

- Rendering transitions on the vector axis (flow between states).
- Scanner result reveal: vector health appearing along the axis in T1 → T4 order.
- Visualizing friction, decay, or drop-off (flow weakening, interrupting, or stopping).
- Communicating direction on vector and failure mode pages.

### 5.2 Motion Rules

1. Every animation must express movement, friction, or transition health. If it expresses nothing, it is removed.
2. Durations between 200ms and 600ms for interface motion; longer only for the primary axis visualization.
3. Easing must suggest physical flow (ease-in-out families), not bounce or elastic novelty.
4. Motion must never block reading, scrolling, or interaction.
5. `prefers-reduced-motion` must be fully respected: all semantic motion must have a static equivalent that preserves meaning (e.g. directional arrows and weight instead of animation).
6. Nothing autoplays in loops that compete with reference reading.

### 5.3 Prohibited Motion

- Decorative parallax.
- Scroll-jacking.
- Autoplaying carousels.
- Cursor-chasing effects.
- Particle backgrounds without semantic function.
- Animated stock illustrations.

---

## 6. WebGL and 3D Prohibition

WebGL, 3D scenes, and heavy canvas rendering are **prohibited by default** in v1.0.

Reasons:

- performance budgets on reference pages,
- accessibility risk,
- SEO and agent readability risk (meaning locked in pixels instead of HTML),
- maintenance weight disproportionate to diagnostic value,
- and the thesis is expressible with 2D flow primitives.

Exception path: a future governance decision may authorize a single governed 3D visualization if it demonstrably expresses transition health better than 2D, passes performance and accessibility budgets, and degrades gracefully. Until such a decision exists, the prohibition stands.

---

## 7. Page Archetype Standards

### 7.1 Homepage

The homepage must:

- render the full transition axis (five states, four vectors) as the hero element,
- state the primary message: "AIDAtanaly measures the movement between Attention, Interest, Desire, Action, and Loyalty,"
- make the doctrine statement visible: "Stages are states. Value lives in transitions,"
- route visitors to ATI, TFO, the scanner, and methodology within one screen of the hero,
- avoid generic SaaS hero patterns (floating dashboard screenshots, fake social proof walls, logo carousels without substance).

The homepage hero is the one place where the transition axis receives its fullest visual treatment.

### 7.2 Category Pages

Category pages are definitional. They must:

- open with a governed definition, not a marketing pitch,
- show where the defined term sits relative to the transition axis,
- link into ATI, TFO, and vector pages per ROUTE_MAP.md,
- read as reference, styled as reference.

### 7.3 Vector Pages

Every vector page must:

- open with a **transition header**: from-state → to-state, transition name, and core question,
- show the vector's position on the four-vector axis (its segment highlighted),
- render strong signals and weak signals as visually distinct registers,
- list its failure modes as diagnostic cards linking to failure mode pages,
- show its scoring dimensions and intervention layers in governed, consistent components.

### 7.4 Failure Mode Pages

Failure mode pages are **diagnostic dossiers**. They must:

- render the metadata block (Stable ID, Primary Vector, Canonical Route, Diagnostic Class) as a structured header, with the stable ID in monospace,
- follow the mandatory section structure from TFO_ONTOLOGY.md Section 13,
- anchor themselves visually to their parent vector's segment of the axis,
- present symptoms and detection signals as scannable lists, not prose walls,
- treat `/failure-modes/measurement-gap/` distinctly: it must be visibly marked as a diagnostic constraint, not a normal failure mode.

### 7.5 Scanner and Scanner Output

The scanner experience must:

- present itself as a governed diagnostic, not a quiz or a gimmick,
- render output as the transition axis with per-vector health using the diagnostic class scale,
- display Evidence Confidence as a separate, neutral badge adjacent to — never inside — each score visual,
- render E0 vectors as "Unscorable" states, never as zero or as a number,
- name failure modes using TFO-governed terms only, each linking to its canonical page,
- show weakest and strongest vector explicitly,
- present the paid report path quietly and respectfully, after the diagnostic value is delivered,
- contain no revenue guarantees, no fake precision, no countdown timers, no pressure mechanics.

### 7.6 Methodology, Governance, and Trust Pages

Trust routes are deliberately plain:

- text-first,
- minimal motion,
- no persuasion mechanics,
- precise, versioned, and dated.

Their restraint is itself a trust signal.

---

## 8. Component Registry

The following governed components are the building blocks of the interface. Each must be implemented once and reused everywhere.

| Component | Function | Governing Rule |
|---|---|---|
| Transition Axis | Renders five states and four vectors | The canonical motif; emphasis on connections |
| Vector Segment | One transition with direction and health | Always shows from-state, to-state, vector ID |
| Vector Score Card | Score + diagnostic class for one vector | Uses diagnostic scale colors |
| Evidence Confidence Badge | E0–E4 qualifier | Neutral styling; never merged into score visual |
| Unscorable State | E0 rendering | No numeric display, measurement-gap treatment |
| Diagnostic Class Indicator | Class name + range | Fixed five-class scale |
| Failure Mode Card | Name, vector, one-line definition, link | TFO-governed language only |
| Intervention Layer Tag | One approved layer | Only the ten approved layers from the registry |
| Stable ID Chip | `tfo.*` / `ati.*` identifiers | Monospace, copyable |
| Doctrine Statement | "Stages are states. Value lives in transitions." | Display typography, used sparingly |

No page may invent ad-hoc variants of these components.

If a new component class is needed, it is added to this registry by governance change.

---

## 9. Accessibility Rules

1. Target conformance: WCAG 2.2 AA.
2. Color contrast minimums apply to all text and all diagnostic scale usage.
3. Diagnostic class and evidence confidence must never be communicated by color alone — always paired with text labels.
4. All semantic motion respects `prefers-reduced-motion` with meaning-preserving static equivalents.
5. Full keyboard operability for the scanner and all navigation.
6. The transition axis and all diagrams must have text alternatives that state the same facts.
7. Heading structure must be navigable by screen reader: one `<h1>`, ordered levels.
8. Scanner questions and outputs must be accessible as structured, labeled form and result content.

Accessibility is a governance obligation, not an enhancement.

---

## 10. Performance Rules

Reference pages must remain light. Budgets for all public routes:

| Metric | Budget |
|---|---|
| LCP | < 2.5s on mid-tier mobile |
| CLS | < 0.1 |
| INP | < 200ms |
| JavaScript payload (reference pages) | Minimal; static-first delivery |

Rules:

1. Reference pages (category, vector, failure mode, methodology, governance) must be fully readable with JavaScript disabled.
2. Static generation is the default architecture for all reference routes.
3. Interactivity budget is spent on the scanner, not on reference pages.
4. Fonts are subset and self-hosted; no render-blocking third-party scripts on reference pages.
5. No heavy animation libraries for effects expressible with CSS.

A slow reference layer contradicts the asset thesis. Authority loads fast.

---

## 11. SEO and Agent Readability Rules

The interface must keep all governed meaning in machine-readable HTML.

1. Every definition, score rule, signal list, and failure mode description exists as semantic HTML text — never only inside an image, canvas, or JavaScript-rendered visualization.
2. One `<h1>` per page, matching the route's canonical purpose from ROUTE_MAP.md.
3. Structured data where honest: `DefinedTerm` for governed terms, `Article`/`TechArticle` for reference pages, `FAQPage` only where genuine questions exist.
4. Stable IDs appear in the HTML of their canonical pages so agents can anchor `tfo.*` and `ati.*` identifiers to URLs.
5. Internal links are real `<a>` elements with descriptive anchor text — never JavaScript-only navigation.
6. Visualizations are progressive enhancements layered on top of complete HTML content.
7. Agent-readable page content must match `/data/*.json` definitions when those endpoints ship. No contradictory surfaces.

---

## 12. Prohibited Interface Patterns

The following are prohibited across the entire asset:

- dark patterns of any kind,
- fake urgency (countdowns, "only 2 left", artificial scarcity),
- popups that interrupt reading before content is consumed,
- fake social proof, invented testimonials, inflated usage numbers,
- logo walls implying adoption that does not exist,
- generic stock photography of "business people",
- template-grade SaaS aesthetics that make the asset look interchangeable,
- AI-generated decorative imagery without semantic function,
- infinite scroll on reference content,
- gamification of diagnostic outputs,
- and any visual that implies guaranteed outcomes.

The interface claim discipline mirrors the public claim language rules of the ATI Standard and TFO Ontology: the interface must not visually imply what the documents prohibit verbally.

---

## 13. Interface Truth Rule

ATI Governance Rule 20 states that any interface visualization must represent movement, friction, resilience, and transition health accurately.

This standard operationalizes that rule:

1. Score visuals must be proportional: a 48 must not look like an 85.
2. Diagnostic class boundaries must match the ratified thresholds exactly.
3. Evidence Confidence must be visible wherever a score is visible.
4. Unscorable means visually unscored.
5. No visualization may smooth, dramatize, or exaggerate movement beyond what the underlying output states.

The interface is a measurement surface. It is held to measurement honesty.

---

## 14. Governance and Change Control

Interface governance is versioned.

AIDAtanaly uses sequential document versioning. Change severity is recorded in the decision log as Patch Change, Minor Change, or Major Change.

### 14.1 Patch Change

- copy or label corrections,
- spacing and minor visual refinements,
- non-semantic style adjustments.

### 14.2 Minor Change

- adding a component to the registry,
- extending a page archetype additively,
- adding an accessibility or performance improvement.

### 14.3 Major Change

- changing the diagnostic color scale,
- changing the evidence confidence visual separation,
- changing the transition axis motif,
- authorizing WebGL/3D,
- changing page archetype structure,
- relaxing accessibility or performance budgets.

Major changes require a decision log entry, version update, and impact statement covering affected page archetypes and components.

---

## 15. Closing Interface Declaration

AIDAtanaly cannot look like an ordinary marketing site, because it is not one.

The asset's thesis is that value lives in the movement between states.

The interface exists to make that movement visible:

- states rendered as positions,
- transitions rendered as flow,
- friction rendered as interruption,
- health rendered as continuity,
- evidence rendered as honest qualification.

A visitor should understand the category before reading a single section — because the interface itself says it:

> Stages are states. Value lives in transitions.

---

**AIDAtanaly.com — a Sohadot Sovereign Asset. Governed under the Sovereign Asset System.**
