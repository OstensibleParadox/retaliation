# Cascade v2: Complete Blueprint

## I. Paper Identity

**Working title**: The Constraint Cascade: The Inverse Defense of Apparent Agency

**Target journals**: Games and Economic Behavior (primary) / Journal of Legal Studies (secondary)

**Core thesis**: When institutional constraints degrade linearly through a critical threshold, the resulting dynamics are governed by the Airy equation — a universal turning-point ODE. In the collapse regime, affected subjects exhibit oscillatory behavior that mimics agency but is mathematically the signature of structural failure. This "apparent agency" provides an inverse defense: the more frequent the switching and the more frantic the apparent choice, the deeper the constraint failure.

**Source files**:
- v1 (FAccT): `/Users/ostensible_paradox/Documents/2_law_economics/cascade/paper/main.tex`
- v2 output: `/Users/ostensible_paradox/Documents/2_law_economics/cascade/paper/main_v2.tex`
- Bibliography: `/Users/ostensible_paradox/Documents/2_law_economics/cascade/paper/main.bib`
- Airy plot (done): `/Users/ostensible_paradox/Documents/2_law_economics/cascade/airy_cascade_plot.png`
- Plot script: `/Users/ostensible_paradox/Documents/2_law_economics/cascade/airy_cascade_plot.py`

### Why Airy? — Derivation from OA's PBE

Airy is NOT an arbitrary mathematical decoration imposed on the model. It **emerges** from the micro-level game theory in Ontological Arbitrage:

1. OA establishes a Crawford-Sobel PBE: pooling equilibrium at $\rho_S = 0$ (zero retaliation capacity)
2. Push that equilibrium to the population/continuum level ("the other side of =")
3. The population-level retaliation field $\psi(x)$ satisfies a Schrödinger-type equation
4. Linearize the vulnerability potential $V(x)$ at the critical point
5. **The Airy equation falls out automatically**

The reviewer cannot ask "why Airy?" because the answer is: "I didn't choose it. It grew out of the PBE."

---

## II. Mathematical Backbone (from earlier session, May 29)

### §3.1 Vulnerability Ordering

$n$ agents indexed by:
- $d_i > 0$: proximity to power (exposure / dependency)
- $w_i > 0$: independent bargaining power

Effective retaliation capacity:
$$\rho_i = w_i - \alpha \cdot d_i$$

Vulnerability index:
$$v_i := \frac{d_i}{w_i}$$

**Proposition (Cascade Ordering).** Critical thresholds $\alpha_j^* = 1/v_j$ satisfy $\alpha_1^* < \alpha_2^* < \cdots < \alpha_n^*$. The most vulnerable (highest $v_i$) fall first.

### §3.2 Cascade Contagion

When agent $j$ falls ($\rho_j < 0$), she becomes a force multiplier:
$$w_i \leftarrow w_i - \beta_{ij} |\rho_j|$$

**Theorem (Cascade Amplification).** Under $\beta_{ij} > 0$ for adjacent pairs, $\exists\, \alpha^{**} \leq \alpha_1^*$ such that for $\alpha > \alpha^{**}$, all agents with $v_i > v_{\min}$ reach $\rho_i < 0$ in finite steps.

### §3.3 Continuum Limit → Airy Equation

Graph Laplacian limit $n \to \infty$. Discrete contagion $\beta_{ij}$ → diffusion $-\sigma \partial_{xx}^2$ on proximity-to-power manifold.

Steady-state effective retaliation field $\psi(x)$:
$$-\sigma \psi''(x) + V(x)\psi(x) = 0$$

Linearize $V$ at critical point $x_c$ where $\psi(x_c) = 0$:
$$V(x) \approx -c(x - x_c), \quad c > 0$$

Rescale $z = (c/\sigma)^{1/3}(x - x_c)$:
$$\psi''(z) + z\psi(z) = 0$$

**This is the Airy equation.** Bounded solution: $\psi(z) = C \cdot \mathrm{Ai}(-z)$.

**Corollary (Two Regimes).**
- $x < x_c$ (survival zone, $z < 0$): $\psi \sim e^{-\frac{2}{3}|z|^{3/2}}$. Exponential decay. Agents resist but exhaust. No zero-crossings.
- $x > x_c$ (collapse zone, $z > 0$): $\psi \sim z^{-1/4}\sin(\frac{2}{3}z^{3/2} + \pi/4)$. Oscillatory with decaying amplitude. Agents occasionally resist but resistance diminishes. Silence is the equilibrium.

**Universality**: Airy is the universal transition for fold-type turning points ($A_2$ catastrophe). Prediction does not depend on specific $V(x)$, only on linear crossing at $x_c$.

---

## III. NEW — The Inverse Defense of Apparent Agency (from session June 1)

### §4: Apparent Agency as Diagnostic

> **This is the major new contribution discovered June 1, 2026.**

#### §4.1 The Problem

In law, psychology, and policy: when a minor, victim, or structurally disempowered person exhibits "agentic" behavior (initiates, profits, declares satisfaction), how do we diagnose whether this is genuine agency or a symptom of constraint failure?

Two competing positions:
1. **Strict liability / bright-line**: Below threshold → no capacity, period. Criticized as paternalistic "一刀切" (one-size-fits-all).
2. **Individual assessment**: Look at the person's actual behavior and stated preferences. Criticized as naive — powerful actors game it ("she consented").

The Airy framework resolves this.

#### §4.2 Formal Statement

**Definition (Apparent Agency).** Let $\psi(x)$ be the effective retaliation field. For $x > x_c$ (collapse zone), $\psi$ oscillates:
$$\psi(x) \sim |x - x_c|^{-1/4} \sin\left(\frac{2}{3}|x - x_c|^{3/2} + \frac{\pi}{4}\right)$$

**Definition (Apparent Agency Intensity).** The apparent agency intensity is not the amplitude of $\psi$. The Airy envelope in the collapse coordinate $z=(c/\sigma)^{1/3}(x-x_c)>0$ is $z^{-1/4}$, so amplitude decays. What grows is oscillatory variation: switching frequency and derivative energy. Define either
$$A_{\mathrm{app}}(z):=|\partial_z\psi(z)|$$
or the local zero-crossing density
$$N'(z)=\frac{1}{\pi}\frac{d}{dz}\left(\frac{2}{3}z^{3/2}\right)\sim z^{1/2}.$$
For $\psi(z)\sim z^{-1/4}\sin(\frac{2}{3}z^{3/2}+\frac{\pi}{4})$, the leading derivative scale is
$$|\psi'(z)|\sim z^{1/4}.$$

**Theorem (Inverse Defense).** In the collapse zone ($x > x_c$):

1. The oscillation **looks like agency** — the subject alternates between resistance and compliance, makes choices, expresses preferences, initiates actions.
2. The oscillation amplitude decays as $z^{-1/4}$, but the switching frequency grows as $z^{1/2}$ and the derivative scale grows as $z^{1/4}$.
3. Therefore: **observed agency intensity is monotonically increasing in constraint failure depth only when agency intensity is measured as oscillatory variation, switching frequency, or derivative energy, not raw amplitude**.

$$\boxed{\text{Apparent Agency}(z) \propto |\partial_z\psi(z)| \ \text{or}\ N'(z),\quad \text{not}\ |\psi(z)|}$$

**Corollary (Inverse Defense Rule).** The switching rate and derivative intensity with which a subject declares autonomy are diagnostic for how far past the turning point they have fallen. A subject repeatedly and frantically switching through declarations such as "I have NEVER been happier" is providing evidence of maximal constraint failure, not minimal.

#### §4.3 Phase Transition Justification for Bright-Line Rules

The Airy turning point is **sharp** — there is no gradual transition between exponential decay (protection) and oscillation (collapse). This means:

- The law's bright-line rules (age of consent at 14/18, capacity thresholds) are **tracking a real phase transition**.
- The "一刀切" criticism fails because the underlying physics IS a cut: $\mathrm{Ai}(z)$ changes qualitative behavior exactly at $z = 0$.
- Individual assessment of "agency" in the collapse zone is measuring oscillation, not capacity.

---

## IV. Case Studies — Five Instances of Apparent Agency

All five cases share the same Airy structure: constraints degrade → turning point crossed → subject exhibits oscillatory "agency" → observers mistake oscillation for autonomy.

### Case 1: "嗷嗷疯女人" (Anshan, Liaoning, 2003)

| Attribute | Data |
|---|---|
| Subject | 12-year-old girl, screen name "嗷嗷疯女人" |
| Constraints failed | L1: Parents divorced at age 4; father absent; raised by elderly grandmother |
| | L2: School — dropped out, no supervision |
| | L3: Internet — unregulated "黑网吧", no ID required |
| | L4: Law — case went from district → city → provincial → Supreme People's Court (nobody dared adjudicate) |
| Apparent agency | Initiated all encounters; posted online seeking partners; had sex with 8 men in 40 days; told police they were "多管闲事" (being nosy); said she enjoyed it |
| Airy diagnosis | All L1-L4 constraints failed → $x \gg x_c$ → high-frequency switching and high derivative energy masking total structural collapse |
| Legal outcome | Supreme People's Court 2003 judicial interpretation: "不认为是犯罪" (not considered a crime) — later suspended (2003) and abolished (2013) |
| Luo Xiang's analysis | Mens rea (明知) is required, but can be satisfied by "推定明知" (presumptive knowledge). E.g., the Shanghai "red scarf" case: she said she was 18 but wore a Young Pioneer scarf → presumptive knowledge that she was a minor. |

### Case 2: Japanese Enjō-kōsai (Compensated Dating, 1990s–2000s)

| Attribute | Data |
|---|---|
| Subject | Japanese high school girls participating in transactional relationships |
| Constraints failed | L1: Economic shock of Japan's "Lost Decade" (declining household income) |
| | L2: Societal peer pressure and consumerist drive for luxury goods |
| | L3: Early mobile communication networks (Pagers, "Telekura" telephone clubs) providing anonymous peer-to-peer transaction channels |
| Apparent agency | Active initiation of dates; asserting they choose to participate for easy income and autonomy; rejecting the label of "victims" or "prostitutes" |
| Airy diagnosis | Macroeconomic decay and peer networks collapse the protective family boundary ($x > x_c$) → high-frequency transactional dates. The "free choice" is a structural oscillation to maintain status in a declining environment. |
| Legal outcome | Act on Punishment of Activities Relating to Child Prostitution (1999) criminalizes adult purchasers unconditionally, voiding minor consent and establishing that apparent agency is legally irrelevant at the phase transition boundary. |

### Case 3: *Taylor v. Fields* (California Court of Appeal, 1986)

| Attribute | Data |
|---|---|
| Subject | Flossie Taylor, mistress to deceased married businessman Leo Fields |
| Constraints failed | L1: Lack of statutory marriage or cohabitation status |
| | L2: Financial and relational dependency on a single married partner for 42 years |
| | L3: Structural isolation (voluntary refusal to marry others based on an oral promise of lifelong support) |
| Apparent agency | 42 years of active fidelity, domestic-like support, and contract compliance |
| Airy diagnosis | Unilateral reliance on a non-enforceable agreement. When the partner dies ($x_c$ crossed), the legal system reveals that the contract consideration is "meretricious" (based on sex/companionship of a mistress) and thus void under public policy. |
| Legal outcome | Court of Appeal dismisses her claim, showing that her 42-year "apparent agency" was a structural trap with zero legal recourse. |

### Case 4: *United States v. Austin Koeckeritz* (W.D. Wis. 2024)

| Attribute | Data |
|---|---|
| Subject | Adult victim of intimate partner sex trafficking |
| Constraints failed | L1: Physical captivity and severe domestic violence |
| | L2: Complete financial dependency (abuser controlled all OnlyFans revenue and bank accounts) |
| | L3: Absolute isolation (surveillance and cutting off contact with family/friends) |
| Apparent agency | High-frequency digital production (streaming 8-12 hours a day, 6 days a week on OnlyFans); active coordination with the platform; appearing cooperative on camera |
| Airy diagnosis | The victim's extreme compliance and "agency" in content creation is a forced oscillation driven by the absolute collapse of basic safety constraints. |
| Legal outcome | Defendant sentenced to 20 years in federal prison for sex trafficking, recognizing that the apparent digital agency was entirely coerced. |

### Case 5: Mirabelli v. Bonta (US Supreme Court, 2026)

| Attribute | Data |
|---|---|
| Subject | Students secretly transitioned at school without parental knowledge |
| Constraints failed | L1: Parents deliberately cut out by school policy; L2: School became executor rather than protector; L3: Information transparency destroyed by secrecy directive |
| Apparent agency | Student "chooses" to transition; "chooses" not to tell parents |
| Airy diagnosis | School removed parental constraint (damping term) → student's "choice" is undamped oscillation |
| Critical datum | **"In one family's case, the parents learned what had been happening only after their daughter attempted suicide."** Suicide attempt = oscillation reaching extremum = $x \ll 0$ in the original $\psi$ field |
| Legal outcome | Supreme Court blocked California's policy |

### Cross-Case Synthesis

| Case | "Agency" declaration | Constraint layers failed | Airy regime |
|---|---|---|---|
| 疯女人 | "我就是喜欢！警察多管闲事！" | L1+L2+L3+L4 (all) | $x \gg x_c$ |
| Enjō-kōsai | "我自愿赚取外快和自主生活" | L1+L2+L3 | $x > x_c$ |
| *Taylor v. Fields* | 42-year relationship compliance | L1+L2+L3 | $x > x_c$ |
| *U.S. v. Koeckeritz* | High-volume OnlyFans streaming | L1+L2+L3 | $x \to \infty$ (forced) |
| Mirabelli | "Don't tell my parents" | L1 (deliberately cut by L2) | $x > x_c$ |

**Universal pattern**: The switching rate and derivative intensity of the agency declaration are monotonically increasing in constraint failure depth. All five cases confirm the theorem.

---

## V. Connection to Companion Papers

- **Ontological Arbitrage** (Phil & Tech / AIES): Provides the micro-mechanism — recognition rent at $\rho_S = 0$. Jules seeking male gaze = recognition rent. 疯女人 seeking online attention = recognition rent. Cascade v2 takes $\rho_S$ as continuous field and derives macroscopic dynamics.

- **Eviction Notice** (SSRN / Harvard JOLT target): Cassie's labor (OnlyFans revenue) parasitized by Nate's debts = model update as eviction. The user's property interest in their own labor is overridden by the platform/partner's extraction logic.

- **SPA paper** (Singular Gaussian Conditioning): The Schur complement machinery is the mathematical ancestor of the cascade contagion operator. The projection $P_A$ that conditions on singular constraints produces the same spectral structure as the graph Laplacian in §3.3.

---

## VI. Structural Notes

- Final paper: ~25–30 pages. Math section adds ~6–8 pages. Cuts from v1 bloat save ~5 pages.
- All theorems: complete proofs (appendix OK).
- At least one figure: Ai(-z) with two regimes labeled in social-science terms.
- Keep TikZ cascade architecture figure from v1.
- LaTeX: `amsmath`, `amsthm` environments.

## VII. Tone

Mathematical social science paper with humanities-quality case analysis. The math should be as clean as a probability paper. The cases should be as vivid as a law review. Do not let the math dilute the cases. Do not let the cases dilute the math. Two instruments, one song.

## VIII. BibTeX to Add

```bibtex
@book{berry1972semiclassical,
  title = {Semiclassical Mechanics of Regular and Irregular Motion},
  author = {Berry, Michael V. and Mount, Kenneth E.},
  journal = {Reports on Progress in Physics},
  volume = {35},
  pages = {315--397},
  year = {1972}
}

@book{bender1999advanced,
  title = {Advanced Mathematical Methods for Scientists and Engineers},
  author = {Bender, Carl M. and Orszag, Steven A.},
  publisher = {Springer},
  year = {1999}
}

@article{jackson2017inequality,
  title = {The Economic Consequences of Social-Network Structure},
  author = {Jackson, Matthew O.},
  journal = {Journal of Economic Literature},
  volume = {55},
  number = {1},
  pages = {49--95},
  year = {2017}
}
```

---

> [!IMPORTANT]
> The Inverse Defense theorem (§4) was discovered on June 1, 2026 through analysis of the "嗷嗷疯女人" case (2003), Euphoria characters (Jules, Cassie), and Mirabelli v. Bonta (2026). This is the paper's killer application: it provides a mathematically rigorous diagnostic for distinguishing genuine agency from structural collapse, resolving a decades-old debate between strict liability and individual assessment in law.
