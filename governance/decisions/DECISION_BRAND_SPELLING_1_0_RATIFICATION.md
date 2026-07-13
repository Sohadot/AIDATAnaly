# DECISION_BRAND_SPELLING_1_0_RATIFICATION.md

## AIDATAnaly.com — Canonical Brand Spelling

**Document Class:** Governance Decision Log
**Asset:** AIDATAnaly.com
**Applies to:** all repository documents, public pages, structured data, external copy, validators
**Decision ID:** BRAND-001
**Decision Type:** Brand Normalization
**Status:** Ratified
**Ratified by:** Sohadot — System Operator
**Date:** 2026-07-13

---

## 1. Decision Summary

The canonical brand spelling is fixed:

> **Canonical brand spelling: AIDATAnaly.**
> **Canonical domain URL: https://aidatanaly.com/**

The capital **T** carries the name logic explicitly: **AIDA + T + Analy = AIDATAnaly**, where **T = Transition**.

## 2. Historical Note (whitelisted legacy spelling)

Documents and pages produced before this decision used the mixed-case spelling **AIDAtanaly**. On 2026-07-13 every occurrence in the repository (593 across documents, pages, data registries, scripts, and structured data) was normalized to **AIDATAnaly**. This section is the only place in the repository where the legacy spelling may appear, as a historical record; the brand validator whitelists this file alone.

## 3. Ratified Rules

1. **Brand text** — always `AIDATAnaly` (and `AIDATAnaly.com` when displaying the brand with its TLD).
2. **URLs** — always lowercase: `https://aidatanaly.com/` and route URLs under it. URLs are never re-cased.
3. **First external mention** — `AIDATAnaly — AIDA Transition Analytics` (unchanged from the Name Binding Rules).
4. **Enforcement** — `scripts/validate-brand.ps1` fails the quality gate on any occurrence of the legacy spelling outside this decision log, and verifies the canonical spelling and lowercase canonical URL are present where required.

## 4. Non-Goals

This decision does not change routes, URLs, scoring, ontology IDs (which are lowercase system identifiers, e.g. `tfo.t1.attention_noise`), or any governed definition.

---

*Ratified as BRAND-001 — Canonical Brand Spelling.*
