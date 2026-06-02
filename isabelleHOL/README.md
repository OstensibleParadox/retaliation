# Isabelle/HOL Formalization of "Ontological Arbitrage"

This directory contains the machine-checked proofs for the theorems in the paper.

## Dependencies

- **Isabelle2024**: The proofs have been developed and verified using Isabelle2024.

## Running the Verification

1. Install Isabelle2024 from the [official website](https://isabelle.in.tum.de/).
2. Start Isabelle/jEdit.
3. Open `Ontological_Arbitrage.thy`, `Sanctionable_Inconsistency.thy`, and `Auditable_Records.thy` in the editor.
4. Isabelle will automatically process the files and verify the proofs.
5. Alternatively, run the following command in this directory to build the session:
   ```bash
   isabelle build -D .
   ```

## Files

- `Ontological_Arbitrage.thy`: Contains the core signaling game, the cheap-talk pooling equilibrium, zero-retaliation neologism-proofness, and the audit-trail separating equilibrium.
- `Sanctionable_Inconsistency.thy`: Formalizes the sanctionable inconsistency mechanism.
- `Auditable_Records.thy`: Formalizes the auditable records mechanism.
- `ROOT`: Isabelle session configuration.
