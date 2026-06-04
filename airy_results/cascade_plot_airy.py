import numpy as np
import matplotlib.pyplot as plt
from scipy.special import airy
import matplotlib.gridspec as gridspec

# ==========================================
# Aesthetic configuration for "Dismal Science"
# ==========================================
plt.rcParams['font.family'] = 'serif'
plt.rcParams['axes.linewidth'] = 1.2
colors = {'safe': '#2a5b84', 'abyss': '#d64161', 'potential': '#333333', 'zero': '#f7b731'}

# ==========================================
# Domain Definition: The Singular Horizon
# ==========================================
# z represents depth of cascade. 
# z < 0: The "Safe/Strain" Zone (x < x_c, rho_s > 0)
# z > 0: The "Abyss/Changgui" Zone (x > x_c, rho_s < 0)
z = np.linspace(-5, 12, 1000)

# The Schrödinger solution at linear turning point is Ai(-z) 
# Note: standard form psi'' + z*psi = 0 yields Ai(-z)
ai, aip, bi, bip = airy(-z)
psi = ai  # The survival wavefunction

# Potential V(z) ~ -z
V = -z

# ==========================================
# Plotting the Cascade Phenomenon
# ==========================================
fig = plt.figure(figsize=(12, 8))
gs = gridspec.GridSpec(2, 1, height_ratios=[1, 2])

# ---- Panel 1: The Macroscopic Societal Potential ----
ax1 = plt.subplot(gs[0])
ax1.plot(z, V, color=colors['potential'], lw=2.5, linestyle='--')
ax1.fill_between(z, V, 0, where=(z < 0), color=colors['safe'], alpha=0.1)
ax1.fill_between(z, V, 0, where=(z > 0), color=colors['abyss'], alpha=0.1)
ax1.axvline(0, color='black', lw=1.5, zorder=3)
ax1.set_xlim(-5, 12)
ax1.set_ylim(-13, 6)
ax1.set_ylabel(r"Effective Potential $V(x)$", fontsize=12)
ax1.set_title("The Constraint Cascade: Macro Potential & Quantum Collapse", fontsize=14, fontweight='bold', pad=15)
ax1.text(-2.5, 3, r"Survival Zone ($\rho_S > 0$)", ha='center', color=colors['safe'], fontweight='bold', fontsize=11)
ax1.text(6, 3, r"Abyss / 'Changgui' Zone ($\rho_S < 0$)", ha='center', color=colors['abyss'], fontweight='bold', fontsize=11)
ax1.axis('off')

# ---- Panel 2: The Airy Wavefunction (Individual Agency / Power) ----
ax2 = plt.subplot(gs[1])
ax2.plot(z, psi, color=colors['safe'], lw=2, label="Evanescent Decay", zorder=4)
# Highlight the oscillating abyss
ax2.plot(z[z>0], psi[z>0], color=colors['abyss'], lw=2, label="Oscillatory Shattering", zorder=5)

# Fill under the curve for dramatic effect
ax2.fill_between(z, psi, 0, where=(z < 0), color=colors['safe'], alpha=0.3)
ax2.fill_between(z, psi, 0, where=(z > 0), color=colors['abyss'], alpha=0.3)

# Mark the zeroes (The mutual destruction points)
from scipy.optimize import fsolve
roots = []
for i in range(1, 6):
    # Approximation of Airy zeroes
    root_guess = (3 * np.pi / 8 * (4 * i - 1)) ** (2/3)
    exact_root = fsolve(lambda val: airy(-val)[0], root_guess)[0]
    roots.append(exact_root)
    ax2.plot(exact_root, 0, 'o', color=colors['zero'], markersize=8, markeredgecolor='black', zorder=6)
    if i <= 3:
        ax2.text(exact_root, 0.1, f"$a_{i}$", ha='center', fontsize=11, color=colors['potential'])

ax2.axvline(0, color='black', lw=1.5, label="Turning Point ($x_c$)", zorder=3)
ax2.axhline(0, color='gray', lw=1, linestyle='-', zorder=2)

# Annotations
ax2.annotate('Evanescent Tail:\nContinuous Strain,\nNo Intersection', xy=(-2.5, 0.1), xytext=(-3.5, 0.4),
             arrowprops=dict(facecolor='black', shrink=0.05, width=1, headwidth=6),
             fontsize=11, color=colors['safe'], ha='center')

ax2.annotate('The Negative Zeroes:\nDestructive Interference\n(Internal Societal Conflict)', xy=(roots[1], 0), xytext=(4.5, -0.4),
             arrowprops=dict(facecolor='black', shrink=0.05, width=1, headwidth=6),
             fontsize=11, color=colors['abyss'], ha='left')

ax2.annotate(r'High Frequency Flattening: $\lim \rightarrow 0$', xy=(10, 0), xytext=(8.5, 0.4),
             arrowprops=dict(facecolor='black', shrink=0.05, width=1, headwidth=6),
             fontsize=11, style='italic', color=colors['abyss'], ha='center')

ax2.set_xlabel(r"Normalized Proximity-to-Power ($z = k(x - x_c)$)", fontsize=12)
ax2.set_ylabel(r"Effective Resistance Field $\psi(z)$", fontsize=12)
ax2.set_xlim(-5, 12)
ax2.set_ylim(-0.6, 0.6)
ax2.legend(loc='lower left', fontsize=11, framealpha=0.9)
ax2.grid(True, alpha=0.2)

plt.tight_layout()
plt.savefig('airy_cascade_plot.png', dpi=300, bbox_inches='tight')
plt.show()
