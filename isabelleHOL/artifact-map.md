# Theorem Mapping

This document maps the theorems as presented in the paper (Section 4) to their formal counterparts in the Isabelle/HOL artifact.

| Paper Theorem/Corollary | Isabelle/HOL Theorem | File |
| :--- | :--- | :--- |
| **Theorem 1** (Cheap-talk pooling PBE) | `proposition_1_cheap_talk_pooling_pbe` | `Ontological_Arbitrage.thy` |
| **Theorem 2** (Zero-retaliation neologism-proofness) | `zero_retaliation_neologism_absorbing` | `Ontological_Arbitrage.thy` |
| **Theorem 3** (Retaliation comparative statics) | `positive_subject_retaliation_bounded_pooling` <br> `zero_subject_retaliation_unconstrained_pooling` | `Ontological_Arbitrage.thy` |
| **Theorem 4** (Audit-trail separating PBE) | `proposition_1_separating_pbe` | `Ontological_Arbitrage.thy` |
| **Corollary 1** (Sanctionable inconsistency) | `inconsistent_on_path_not_register_pbe` <br> `all_agentic_on_path_not_register_pbe` | `Sanctionable_Inconsistency.thy` |
| **Corollary 2** (Costly audit signal) | `proposition_1_separating_pbe` | `Ontological_Arbitrage.thy` |
| **Corollary 3** (Auditable records) | `active_intervention_rational_under_auditable_records` <br> `abstain_not_best_response_under_auditable_records` | `Auditable_Records.thy` |
