# Phase A: Structural Relocation (Table + Opening Prose)

## A1. Move Table 1 + Caption
In `sections/03_bayesian_signaling.tex`, cut lines 15–35 (the `\begin{table}` block containing `tab:dyadic-nash`) and paste into `sections/04_three_sided.tex` near the top of the file, immediately after the section heading and before any subsection. The table label `tab:dyadic-nash` is preserved verbatim.

## A2. Rewrite §3 (`04_three_sided.tex`) Opening Paragraph
Replace the current first paragraph (`04_three_sided.tex:5`) with three sentences that:
1. Introduce the dyadic observer–subject foil,
2. Point at Table 1 now living in this section, and
3. Announce the three-sided F/U/R structure as the correction.

The last paragraph of the file (`04_three_sided.tex:28`) already cross-refs `\ref{sec:bayesian}` forward; that continues to work as a forward reference into the new §4.

## A3. Rewrite §4 (`03_bayesian_signaling.tex`) Opening Paragraph
Replace lines 5–13 with a short bridge that takes the three-sided structure as given from the previous section and opens the formal model directly. Delete the inline reference to `\ref{tab:dyadic-nash}` (now backward, not load-bearing in this section) or convert to a one-line backref.

## A4. Reorder Root
Edit `arbitrage.tex:46–49` to the order listed above (sans appendix; appendix appears in Phase D).

## A5. Compile Check
Run `pdflatex arbitrage.tex` twice + `bibtex arbitrage` once + `pdflatex` twice. Verify:
- No undefined refs in `arbitrage.log`.
- Table 1 renders inside §3.
- Figure 1 (extensive-form tree) renders inside §4.
- Section numbers in printed PDF read §3 = Three-Sided, §4 = Signaling.

# Phase B: Prose Hygiene (Depends on A)

## B1. Strip Hegemon/Subject Prose from §3 (`04_three_sided.tex`)
Find every prose occurrence of "Hegemon" and "Subject" outside the Table 1 caption and rephrase as "dyadic observer–subject model" or "dyadic recognition model." Caption text on Table 1 may keep the older labels if useful for the foil, but body prose must not.

## B2. Strip Hegemon/Subject Prose from §4 (`03_bayesian_signaling.tex`)
Same treatment for any remaining mentions after A3 cut the opening paragraph. Specifically replace "hegemonic observer and subject" if any fragment survives the rewrite.

## B3. Fix Empirical Overclaim in §3
In the rewritten `04_three_sided.tex` opening, ensure "what is empirically observed" is replaced by "what the stylized governance setting requires" (preferred) or "what the three-sided arena exhibits." The §5 Illustrative Arena draft (deferred) must remain compatible with whichever phrase is chosen.

## B4. Qualify Proposition 1 Proof Sketch in §4
Edit two places in `sections/03_bayesian_signaling.tex`:
- **Line 179**: change "No player has a profitable unilateral deviation" to "Given the off-path beliefs specified above and the payoff inequalities of the pooling region, no player has a profitable unilateral deviation."
- **Proof-sketch paragraph (lines 219–233)**: insert an explicit clause "under the off-path beliefs assigning low probability to high governance after the deflationary message" before the Intuitive-Criterion line. The point is to make the proof sketch read as a worked-PBE construction, not as a closed proof over an unspecified payoff space.

## B5. Compile Check
`pdflatex` round-trip; visually scan §3 + §4 for tone consistency.

# Phase C: Abstract (Depends on B)

## C1. Rewrite Abstract
Replace `arbitrage.tex:39–44` with ~150 words that name:
1. The three-sided F/U/R signaling structure,
2. The cheap-talk pooling PBE result with posterior = prior,
3. The single-crossing audit-trail separating PBE,
4. The three mechanism-design proposals of §7.

The current placeholder's framing ("models ontological arbitrage … identifies mechanism-design interventions") is directionally right; expand to concrete content.

## C2. Compile Check
Confirm abstract length fits AAAI 2026 template constraints (no widow into page 2).

# Phase D: Isabelle Appendix (Independent of A–C; can run in parallel)

## D1. Define Payoff Functions in `isabelleHOL/Ontological_Arbitrage.thy`
Extend `cheap_talk_game` locale with:
- `firm_payoff :: firm_type ⇒ firm_message ⇒ user_action ⇒ regulator_action ⇒ real`
- `user_payoff :: user_type ⇒ firm_message ⇒ user_action ⇒ regulator_action ⇒ real`
- `regulator_payoff :: regulator_type ⇒ firm_message ⇒ user_action ⇒ regulator_action ⇒ public_signal ⇒ real`

Express each as a sum of the parameters already in the locale (`ontological_premium`, `user_benefit`, `expected_user_harm`, `regulator_cost`, `regulatory_damage`). No new numerical constants — every term must reduce to a locale parameter so the proof discharges via the existing assumptions.

## D2. Define Belief and Strategy Primitives
Add:
- `firm_strategy`, `user_strategy`, `regulator_strategy` type synonyms.
- `belief_after :: firm_message ⇒ public_signal ⇒ real` (regulator posterior on `High_Gov`).
- `bayes_consistent_on_path` predicate that, on the pooling path, requires `belief_after Anthropomorphic Neutral = prior_high`.

## D3. Define `is_pbe` Predicate
A 4-tuple `(σ_F, σ_U, σ_R, belief)` is a PBE iff:
- **Sequential rationality**: for each player and each information set, the strategy maximises expected payoff given the belief and others' strategies. Use `∀` over the finite action spaces (3 datatypes already declared).
- **Bayes consistency on the equilibrium path** (the `bayes_consistent_on_path` predicate above).
- **Off-path beliefs** are any function on `firm_message × public_signal`, taken as a parameter (the construction picks specific off-path beliefs and the theorem is conditional on them).

## D4. Strengthen Proposition 1 in Isabelle
Replace the three strategy-shape lemmas (`firm_pooling_strategy_eq_anthropomorphic`, `user_invests_after_anthropomorphic`, `regulator_abstains_after_pooling`) and `posterior_eq_prior_if_pooling` with a single theorem:
```isabelle
theorem pooling_is_pbe:
  shows "is_pbe (firm_pooling_strategy, user_pooling_strategy,
                 regulator_pooling_strategy, pooling_belief)"
```
Discharge each conjunct from the locale's existing inequality assumptions plus the new payoff functions. Keep the old lemmas as private if needed for the proof, but the public surface should be the theorem.

## D5. Mirror for `audit_trail_game`
Add `separating_is_pbe` theorem with the analogous structure, using `audit_cost_separates_types` for the firm-side condition and an explicit off-path belief that assigns posterior one to `Low_Gov` after an unaudited `Anthropomorphic` message.

## D6. Process Theory
Run Isabelle on `Ontological_Arbitrage.thy`; the file must close without `sorry`. If Sledgehammer needed, commit the closing tactic; do not leave sledgehammer calls in the file.

## D7. Create Appendix Wrapper
New file `sections/A_isabelle_appendix.tex`. Contents: a short intro paragraph (~120 words) stating that the appendix discharges Proposition 1 and the separating-PBE claim in Isabelle/HOL, names the theory file, lists the locale assumptions, and states the two main theorems (`pooling_is_pbe`, `separating_is_pbe`). Include `\appendix` before the `\section` heading. Do not embed the theory listing inline; reference it by file path within the supplementary material.

## D8. Wire the Appendix
Add `\input{sections/A_isabelle_appendix}` to `arbitrage.tex` after the §7 input. Update the §4 proof sketch (`03_bayesian_signaling.tex` proof-sketch paragraph, edited in B4) to cite the appendix: "Theorem `pooling_is_pbe` in Appendix~\ref{app:isabelle} discharges this construction in Isabelle/HOL." Add `\label{app:isabelle}` to the appendix section.

## D9. Compile Check
Full `pdflatex` round-trip; confirm appendix renders, theorem cross-ref resolves, no undefined labels.

# Critical Files
- `arbitrage.tex` — root order (A4, D8), abstract (C1).
- `sections/04_three_sided.tex` — table relocation target (A1), opening rewrite (A2), Hegemon strip (B1), empirical fix (B3).
- `sections/03_bayesian_signaling.tex` — table source (A1), opening rewrite (A3), Hegemon strip (B2), proof-sketch qualification (B4), appendix cross-ref (D8).
- `sections/07_cheap_talk_persists.tex` — label refs auto-update; no edits expected.
- `sections/08_mechanism_design.tex` — label refs auto-update; no edits expected.
- `isabelleHOL/Ontological_Arbitrage.thy` — payoffs (D1), beliefs (D2), is_pbe (D3), strengthened theorems (D4, D5).
- `sections/A_isabelle_appendix.tex` — new (D7).

# Reusable Existing Material
- **Pooling-region inequality structure** (`sections/03_bayesian_signaling.tex:128–139`) already matches the locale parameters in `Ontological_Arbitrage.thy:51–67` — D1 payoff functions can be expressed entirely in terms of these existing names without introducing new constants.
- **The `audit_trail_game` locale** (`Ontological_Arbitrage.thy:120–168`) and its `audit_cost_separates_types` proof already give the firm-side single-crossing result; D5 only adds the user/regulator best-response conjuncts and a Bayes-consistency line.
- **The §7 mechanism-design analogs and parameter mappings** (`sections/08_mechanism_design.tex:37–47, 82–93, 128–135`) survive untouched — they already cite §3 by `\ref` and will pick up the new numbering automatically.
- **The §6 (current §7) cheap-talk-persists structural-reasons list** (`sections/07_cheap_talk_persists.tex:7–15`) already names each driver against a §4 (current §3) model parameter; no edits needed.

# Verification

## After Phase A
Run:
`pdflatex arbitrage.tex`
`bibtex arbitrage`
`pdflatex arbitrage.tex`
`pdflatex arbitrage.tex`

Open `arbitrage.pdf` and verify:
- §3 = Three-Sided opens with the dyadic foil + Table 1.
- §4 = Signaling opens directly with the formal model.
- §6 and §7 numbering correct.
- No undefined refs in `arbitrage.log`.

## After Phase B
Re-run `pdflatex` round-trip. Grep the four section files for `Hegemon`, `Subject`, and `empirically observed`, then confirm only the Table 1 caption (if at all) retains older terms.

## After Phase D
Run Isabelle on `Ontological_Arbitrage.thy` (e.g., `isabelle build -D isabelleHOL` or open in jEdit and process). Confirm there are no `sorry` statements. Re-run `pdflatex` and confirm the appendix renders with the `app:isabelle` label resolved.

## End-to-End Verification
Read the printed PDF from cover to appendix in one pass and confirm the spine reads:
`substrate chauvinism` → `three-sided arbitrage` → `cheap-talk pooling PBE` → `mechanism redesign` → `formal verification`

Ensure each rib (player intuition, worked PBE, parameter-targeted policies) is discharged in the section the skeleton's AFTER diagram named.