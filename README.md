# Project: Ontological Arbitrage (AIES 26 Submission)

This project is a clean-rebuild of the "Ontological Arbitrage" paper, retitled **"Ontological Arbitrage: Bayesian Equilibrium under Substrate Chauvinism"**, specifically formatted for AIES 26 submission using the AAAI 2026 template.

The implementation plan has been broken down into sequential phases to ensure structural integrity and formal rigor, incorporating recommendations from a structural logician audit.

## Execution Plans

1.  **[✅Done✅Phase 1: Scaffold and Configuration](plans/01_scaffold.md)**
    *   Setup target directory structure and archive source inputs.
    *   Configure LaTeX environment with AAAI 2026 styles.
    *   Establish the modular document structure.

2.  **[Phase 2: Draft Core Sections (Load-Bearing)](plans/02_draft_core.md)**
    *   **§4 Three-Sided Arbitrage**: Defining player intuition.
    *   **§3 Bayesian Signaling Equilibrium**: The formal mathematical contribution.
    *   **§7 Why Cheap Talk Persists**: Structural justification for the model.
    *   **§8 Mechanism Design**: The operative governance proposals.

3.  **[Phase 3: Draft Supporting Sections and Bibliography](plans/03_draft_supporting.md)**
    *   **§1 Introduction** & **§2 Conceptual Core**.
    *   **§5 Stylized Facts**: Consolidating market theory and illustrative arena.
    *   **§9 Epilogue**: Final synthesis.
    *   Reconcile and verify the bibliography.

4.  **[Phase 4: Build, Risks, and Verification](plans/04_build_and_verify.md)**
    *   Final compilation and acceptance checks.
    *   Risk mitigation strategies.
    *   End-to-end verification protocol.

## Build Command

Compile from the `paper/` directory so the PDF, `.aux`, and bibliography artifacts stay there:

```bash
cd paper && pdflatex arbitrage && bibtex arbitrage && pdflatex arbitrage && pdflatex arbitrage
```

## Isabelle Scope & Limitations

The formalization of the "Ontological Arbitrage" model in Isabelle/HOL has the following characteristics:

* **Strategic Opacity in `bayes_update`**:
  The `bayes_update` function conditions on a predicate over `firm_type` rather than the joint `firm_private_type` (which includes `opacity`). This models Bayes' rule under the assumption that message transmission is independent of opacity (i.e., for any governance type, either all opacities send the message or none do). While mathematically sound for the pooling and separating equilibria analyzed in the paper, it restricts the general use of the update function for strategies that vary across opacity levels.

* **Indifference-Based Off-Path Behavior**:
  In the cheap-talk game, the user's payoff from investing after the off-path `Deflationary` message is hardcoded to `0`. Consequently, the user is indifferent between investing and detaching, which allows the candidate strategy (detach after deflationary) to be formally proved as a best response by indifference.

* **Register Game Simplifications**:
  The multi-channel register game in [Sanctionable_Inconsistency.thy](file:///Users/ostensible_paradox/Documents/aies26/isabelleHOL/Sanctionable_Inconsistency.thy) is modeled as a decision-theoretic optimization problem. Rather than computing dynamic equilibrium responses of users and regulators, their actions are modeled as static expected payoffs (`ontological_premium` and `expected_sanction`). This isolates the firm's incentives to choose between consistent and inconsistent registers under varying enforcement regimes but does not model the full extensive-form feedback loop.
