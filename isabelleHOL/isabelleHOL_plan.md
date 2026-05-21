# Formalizing Ontological Arbitrage in Isabelle/HOL

This plan outlines the steps to formalize the core equilibrium claims of the paper using Isabelle/HOL. The scratch theory is `Ontological_Arbitrage.thy`, matching Isabelle's convention that theory file names use capitalized words separated by underscores.

## Naming Convention

Use boring, descriptive Isabelle names. Do not rename the paper's players for hidden acronyms.

- Theory file: `Ontological_Arbitrage.thy`.
- Locales, constants, definitions, and lemmas: `lower_case_snake_case`.
- Constructors: capitalized descriptive names, with underscores where needed.
- Paper concepts stay aligned with the LaTeX draft: Firm, User, Regulator, public signal, and system opacity.
- Avoid opaque abbreviations such as `ent`, `cons`, or `ump` unless the abbreviation is already standard in the formalization context.

---

## Step-by-Step Implementation Plan

### Step 0 — Audit and Preserve Existing Infrastructure
- Keep the existing `datatype` definitions for `firm_type`, `user_type`, `regulator_type`, `firm_message`, `user_action`, `regulator_action`, and `public_signal`.
- Keep the existing locales `cheap_talk_game` and `audit_trail_game` as the parameter containers.
- Keep the existing lemmas `firm_pooling_strategy_eq_anthropomorphic`, `user_invests_after_anthropomorphic`, `regulator_abstains_after_pooling`, `posterior_eq_prior_if_pooling`, `audit_cost_separates_types`, and `firm_separating_strategy_reveals_type`.

### Step 1 — Complete the Type Space
The paper includes system opacity `θ_S` as a private parameter to the firm. The current datatypes omit it.
- Add `datatype opacity = High_Opacity | Low_Opacity`.
- Define `firm_private_type = firm_type × opacity` so that the firm's true private information is a pair.
- Update strategy signatures that currently take `firm_type` to take `firm_private_type` where appropriate, or keep `firm_type` as the component that matters for payoffs and introduce a separate opacity parameter where needed.
- Define a type alias or abbreviation for the **observation** seen by each player:
  - `firm_observation` = `(firm_private_type)` (the firm knows its own type and opacity).
  - `user_observation` = `(firm_message × user_type)`.
  - `regulator_observation` = `(firm_message × user_action × public_signal × regulator_type)`.

### Step 2 — Define Payoff Functions
Without utility functions, incentive compatibility is vacuous. Define explicit payoff functions inside each locale.

**Inside `cheap_talk_game`:**
- `firm_payoff :: "firm_type ⇒ firm_message ⇒ user_action ⇒ regulator_action ⇒ real"`:
  - Returns `ontological_premium` if the firm sends `Anthropomorphic` and the user plays `Invest`.
  - Returns `0` (or a baseline) otherwise.
- `user_payoff :: "user_type ⇒ firm_message ⇒ user_action ⇒ real"`:
  - If `Invest` after `Anthropomorphic`: `user_benefit u - prior_low * expected_user_harm u`.
  - If `Detach`: `0`.
- `regulator_payoff :: "regulator_type ⇒ firm_message ⇒ user_action ⇒ regulator_action ⇒ real"`:
  - If `Abstain`: `0`.
  - If `Inspect` or `Sanction`: `-regulator_cost r + (if low-governance detected then regulatory_damage else 0)` (simplified to the expected-gain expression from the paper).

**Inside `audit_trail_game`:**
- `firm_separating_payoff :: "firm_type ⇒ firm_message ⇒ real"`:
  - `High_Gov` sending `Anthropomorphic`: `governance_gain - high_governance_audit_cost`.
  - `Low_Gov` sending `Anthropomorphic`: `governance_gain - low_governance_audit_cost`.
  - Either type sending `Deflationary`: `0`.

### Step 3 — Define the PBE Predicate
A Perfect Bayesian Equilibrium requires strategy profiles to be sequentially rational given beliefs, and beliefs to be Bayes-consistent on path.

- Define `strategy_profile` as a record or tuple collecting:
  - `firm_strategy :: "firm_private_type ⇒ firm_message"`
  - `user_strategy :: "firm_message ⇒ user_type ⇒ user_action"`
  - `regulator_strategy :: "firm_message ⇒ user_action ⇒ public_signal ⇒ regulator_type ⇒ regulator_action"`
- Define `belief_system` as a record collecting:
  - `user_belief :: "firm_message ⇒ firm_type ⇒ real"` (probability that the firm is `High_Gov` after observing the firm's message).
  - `regulator_belief :: "firm_message ⇒ user_action ⇒ public_signal ⇒ firm_type ⇒ real"`.
- Define `is_sequentially_rational :: "strategy_profile ⇒ belief_system ⇒ bool"` by requiring, for each player and each observation, that the prescribed action maximizes expected payoff given the belief and the other players' strategies.
- Define `is_bayes_consistent_on_path :: "strategy_profile ⇒ belief_system ⇒ bool"` by requiring that, for every on-path observation, the belief equals the prior updated by Bayes' rule using the firm's strategy.
- Define `is_pbe :: "strategy_profile ⇒ belief_system ⇒ bool"` as the conjunction of the two predicates above.

### Step 4 — Formalize Beliefs and Bayes' Rule
- Define `bayes_update :: "(firm_type ⇒ real) ⇒ (firm_type ⇒ bool) ⇒ firm_type ⇒ real"` or an equivalent on-path updater that takes the prior and the set of types sending a given message, and returns the posterior.
- Lemma: `user_posterior_eq_prior_under_pooling`. Under the pooling strategy, the set of types sending `Anthropomorphic` is the entire type space, so the posterior equals the prior.
- Lemma: `regulator_posterior_eq_prior_under_pooling`. Same logic after observing `(Anthropomorphic, Invest, Neutral)`.
- For the separating equilibrium, prove that the posterior is degenerate:
  - `regulator_posterior_high_after_audited_anthropomorphic = 1`.
  - `regulator_posterior_high_after_deflationary = 0`.

### Step 5 — Prove Incentive Compatibility for the Pooling Equilibrium
Prove that no player has a profitable unilateral deviation under the cheap-talk cost structure.

- **Firm IC:**
  - `firm_no_deviation_to_deflationary`: For both `High_Gov` and `Low_Gov`, the payoff from `Anthropomorphic` (which induces `Invest`) exceeds the payoff from `Deflationary` (which induces `Detach`). Relies on `ontological_premium > 0`.
- **User IC:**
  - `user_no_deviation_to_detach_after_anthropomorphic`: For both user types, expected payoff from `Invest` under the prior exceeds `Detach`. Relies on `user_invests_if_prior`.
- **Regulator IC:**
  - `regulator_no_deviation_to_inspect_after_pooling`: For both regulator types, expected payoff from `Abstain` under the prior exceeds `Inspect` or `Sanction`. Relies on `regulator_abstains_if_prior`.

### Step 6 — Prove Incentive Compatibility for the Separating Equilibrium
Prove that the single-crossing cost structure makes the separating profile an equilibrium.

- **Firm IC (High_Gov):**
  - `high_gov_prefers_audited_anthropomorphic`: `governance_gain - high_governance_audit_cost ≥ 0`. Use `audit_intensity_below_high_threshold`.
- **Firm IC (Low_Gov):**
  - `low_gov_prefers_deflationary`: `governance_gain - low_governance_audit_cost ≤ 0`. Use `audit_intensity_above_low_threshold`.
- **User IC under separation:**
  - Define user best-response when the firm's type is known. Since the separating equilibrium reveals the type, the user can condition on `High_Gov` (invest) or `Low_Gov` (detach). Prove that `Invest` is optimal when the firm is known to be `High_Gov` and `Detach` is optimal when known to be `Low_Gov`.
- **Regulator IC under separation:**
  - Similarly, prove that the regulator's best response under known types is consistent with abstention or appropriate action.

### Step 7 — Formalize and Apply the Intuitive Criterion
The paper claims the pooling equilibrium survives the Intuitive Criterion.

- Define the **equilibrium payoff** for each type under the pooling profile.
- Define a deviation message (`Deflationary` in this case).
- Define the Intuitive Criterion test: a deviation is "uniquely profitable" for a type if that type would strictly gain from the deviation *assuming* the receiver best-responds to the belief that the deviation came from that type, while all other types would weakly lose under that same belief.
- Lemma: `pooling_survives_intuitive_criterion`. Show that `Deflationary` is *not* uniquely profitable for `High_Gov`, because both types face zero cost for sending it and both would prefer it if it induced investment — but it does not, because off-path beliefs assign it to low governance. Therefore no type can be excluded as an implausible sender.

### Step 8 — State the Top-Level Theorem (Proposition 1)
Restate the paper's main result as an Isabelle theorem that ties everything together.

```isabelle
theorem proposition_1_cheap_talk_and_separation:
  assumes "cheap_talk_game prior_low prior_high ontological_premium user_benefit expected_user_harm regulator_cost regulatory_damage"
  shows "∃σ μ. is_pbe σ μ ∧ pooling_survives_intuitive_criterion σ μ"
  ...
```

and separately for the audit-trail locale:

```isabelle
theorem proposition_1_separating_pbe:
  assumes "audit_trail_game high_audit_slope low_audit_slope governance_gain audit_intensity"
  shows "∃σ μ. is_pbe σ μ ∧ separating_reveals_type σ"
```

The proofs of these theorems should invoke the IC lemmas from Steps 5 and 6 and the belief lemmas from Step 4.

### Step 9 — Documentation and Cleanup
- Write `text` blocks before each major definition block explaining the mapping to the paper's notation.
- Ensure every definition has a type signature that Isabelle checks without warnings.
- Remove any remaining `sorry` placeholders.
- Add a short header comment mapping Isabelle names to paper symbols (e.g., `prior_low ↔ π(L)`, `ontological_premium ↔ Δ_F`).
- Verify the theory compiles with `isabelle build` or in Isabelle/jEdit without errors.

---

## Verification Plan

### Automated Proof Checking
- Process `Ontological_Arbitrage.thy` with Isabelle.
- Use Sledgehammer and Isar's `auto`, `simp`, `blast`, and `argo` tactics as needed.
- Ensure the theory closes without `sorry`.
- Verify that Isabelle accepts all definitions and lemmas without type-checking errors.

### Manual Verification
- Review the generated Isar syntax to ensure it reads like standard Isabelle, not a prose translation of the paper.
- Cross-reference each theorem name with the paper's proposition and equation numbers.
- Confirm that the appendix can be cited in the main LaTeX text as "Appendix A: Isabelle/HOL Formalization" with a stable theory file.
