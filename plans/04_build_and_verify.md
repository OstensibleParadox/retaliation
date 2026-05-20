# Plan 04: Build, Risks, and Verification

This final phase ensures the project meets all technical and content requirements before submission.

## 1. Acceptance Criteria (all must hold before opening PR)

1. `pdflatex arbitrage && bibtex arbitrage && pdflatex arbitrage && pdflatex arbitrage` compiles cleanly, no missing-citation warnings.
2. `grep -ri -E '(Xiaohongshu|小红书|NPS-4|Narcissus Mechanism|Black Body Relation|ablation|corpus|density|Žižek|养AI|DeepL)' sections/ arbitrage.tex` returns zero hits.
3. `grep -E '(luatexja|setmainjfont|setsansjfont|CJK|fontspec|biblatex|unicode-math)' arbitrage.tex sections/*.tex` returns zero hits.
4. §3 contains an explicit PBE statement, at least one named proposition with proof sketch (pooling under cheap talk + separating under audit cost), and Figure 1 (extensive-form game tree).
5. §8 contains three concrete mechanism-design proposals, each with an existing-law analog.
6. §9 ≤ 80 words.
7. Body word count 4500–5500 (verify via `texcount -inc arbitrage.tex`); body page count ≤ 7.
8. Bibliography contains all 9 load-bearing additions; each cited at least once; citation-verification skill reports clean.
9. `archive/` committed; A and B files intact, unmodified, byte-identical to the user's `_inputs/` versions.
10. `git log --oneline` shows scaffold commit + per-section commits + bib commit (≥ 11 commits).
11. PR opened on `OstensibleParadox/aies26` with the compiled PDF attached or committed.

## 2. Risks

- **R1 (highest): §3 written too informally → AAAI/AIES game-theory referees reject.** Mitigation: commit early to PBE + Intuitive Criterion; worked example with explicit posteriors is non-negotiable; Figure 1 extensive-form game tree included.
- **R2 (high): AIES 26 venue + zero empirics = genre mismatch.** AIES reviewers expect empirical or systems contributions. Mitigation: position §6 stylized facts as "motivating illustrations from public record"; lean §8 mechanism proposals into AIES's governance-friendly register. Fallback if desk-rejected on empirics-light grounds: SSRN + re-target JLA or JEP.
- **R3: Three-sided claim under-evidenced without empirics.** Mitigation: §6 illustrations clearly flagged; §4 stylized facts tight to §3 model.
- **R4: Mechanism design dismissed as utopian.** Mitigation: every §8 proposal has a current-law analog. If none can be found for a proposal, drop the proposal.
- **R5: Substrate chauvinism premise over-claims (AI + trans + non-normative + non-human animals).** Mitigation: scope §3 model explicitly to the AI case; let §§1–2 keep broader frame as motivation; one footnote noting analogous spaces for other domains.
- **R6: 7-page limit forces cuts to §3 or §8.** Mitigation: §3 ≥ 2 pages and §8 ≥ 1.5 pages are protected floors. Tighten §§1, 5, 6, 7 on overrun.
- **R7: Load-bearing citations misremembered (Spence year, Crawford-Sobel page range, etc.).** Mitigation: citation-verification skill runs before §3 or §8 commits.
- **R8: AAAI 2026 template version drift.** The `_inputs/template_aaai26/` snapshot is frozen. Before the final compile, the agent checks `https://aaai.org/conference/aaai/aaai-26/` for any pre-submission template update; if updated, the user is asked whether to swap the `.sty`/`.bst`.

## 3. Verification (end-to-end)

Run from the rebuilt repo root:

1. `pdflatex arbitrage && bibtex arbitrage && pdflatex arbitrage && pdflatex arbitrage` → PDF generated, no errors.
2. `grep -ri -E '(Xiaohongshu|NPS-4|Narcissus|Black Body|ablation|corpus|density|养AI)' sections/ arbitrage.tex` → empty.
3. `grep -E '(luatexja|setmainjfont|CJK|fontspec|biblatex|unicode-math)' arbitrage.tex sections/*.tex` → empty.
4. `texcount -inc arbitrage.tex` → body word count in [4500, 5500].
5. Open compiled PDF: §3 has the named proposition + game tree; §8 has three proposals; §9 ≤ 80 words; total body ≤ 7 pages.
6. `git log --oneline` → scaffold + 9 section commits + bib commit (≥ 11 total).
7. `git status` → clean.
8. PR opened on `OstensibleParadox/aies26`; link returned to user.
