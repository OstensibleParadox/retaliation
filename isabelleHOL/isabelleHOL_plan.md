# Formalizing Ontological Arbitrage in Isabelle/HOL

This plan outlines the steps to formalize the core equilibrium claims of the paper using Isabelle/HOL. The scratch theory is `Ontological_Arbitrage.thy`, matching Isabelle's convention that theory file names use capitalized words separated by underscores.

## Naming Convention

Use boring, descriptive Isabelle names. Do not rename the paper's players for hidden acronyms.

- Theory file: `Ontological_Arbitrage.thy`.
- Locales, constants, definitions, and lemmas: `lower_case_snake_case`.
- Constructors: capitalized descriptive names, with underscores where needed.
- Paper concepts stay aligned with the LaTeX draft: Firm, User, Regulator, public signal, and system opacity.
- Avoid opaque abbreviations such as `ent`, `cons`, or `ump` unless the abbreviation is already standard in the formalization context.

## Proposed Changes

### 1. Data Types and State Space
We will define the domains for types and actions as Isar `datatype` definitions:
- **Firm types**: `datatype firm_type = High_Gov | Low_Gov`
- **User types**: `datatype user_type = High_Vuln | Low_Vuln`
- **Regulator types**: `datatype regulator_type = High_Bandwidth | Low_Bandwidth`
- **Firm messages**: `datatype firm_message = Anthropomorphic | Deflationary`
- **User actions**: `datatype user_action = Invest | Detach`
- **Regulator actions**: `datatype regulator_action = Inspect | Sanction | Abstain`

### 2. Probability and Cost Structures
We will use Isabelle locales to encapsulate the game's parameters without hardcoding arbitrary numbers:
- Define `locale cheap_talk_game` for prior probabilities, user payoffs, regulator costs, and the pooling inequalities.
- Define `locale audit_trail_game` for the audit cost slopes, governance gain, audit intensity, and the single-crossing interval.
- Keep LaTeX notation in the paper; use readable ASCII-style Isabelle names in the theory, e.g. `prior_low`, `ontological_premium`, `audit_intensity`.

### 3. Formalizing Proposition 1 (Cheap Talk Pooling)
We will define the conditions for the pooling equilibrium:
- Define the strategy profile where both `High_Gov` and `Low_Gov` types send `Anthropomorphic`.
- Define the posterior belief updates.
- **Lemma:** Prove `firm_pooling_strategy_eq_anthropomorphic`.
- **Lemma:** Prove `user_invests_after_anthropomorphic`.
- **Lemma:** Prove `regulator_abstains_after_pooling`.
- **Lemma:** Prove `posterior_eq_prior_if_pooling`.
- Later strengthening: replace the current strategy-shape lemmas with an explicit `is_pbe` predicate and prove no profitable unilateral deviation under the Section 3 inequalities.

### 4. Formalizing Proposition 2 (Audit-Trail Separation)
We will define the conditions for the separating equilibrium under single-crossing costs:
- Define the strategy profile where `High_Gov` sends audited `Anthropomorphic` and `Low_Gov` sends `Deflationary`.
- **Lemma:** Prove `audit_cost_separates_types`, verifying that the audit-trail interval makes the audited signal affordable for `High_Gov` and unprofitable for `Low_Gov`.
- **Lemma:** Prove `firm_separating_strategy_reveals_type`.

## Verification Plan

### Automated Proof Checking
- Process `Ontological_Arbitrage.thy` with Isabelle.
- Use Sledgehammer and Isar's `auto`, `simp`, and `blast` tactics only as needed.
- Ensure the theory closes without `sorry`.
- We will verify that Isabelle accepts all definitions and lemmas without type-checking errors.

### Manual Verification
- Review the generated Isar syntax to ensure it reads like standard Isabelle, not a prose translation of the paper.
- Keep this directory as scratch or supplementary material until the formalization proves a real equilibrium predicate rather than only strategy-shape lemmas.
