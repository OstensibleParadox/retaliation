"""
Constraint Cascade: Airy Turning-Point Visualization
=====================================================
Plots ψ(z) = Ai(-z) showing the two regimes:
  z < 0  (ρ > 0): Survival zone — exponential decay, no zero crossings
  z > 0  (ρ < 0): Collapse zone — oscillatory with decaying amplitude

For Cascade v2 paper.
"""

import os
from pathlib import Path

OUTPUT_DIR = Path(__file__).resolve().parent / "results"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
os.environ.setdefault("MPLCONFIGDIR", str(OUTPUT_DIR / ".mplconfig"))

import numpy as np
from scipy.special import airy
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyArrowPatch

# --- Compute Ai(-z) ---
z = np.linspace(-8, 18, 4000)
# scipy.special.airy(x) returns (Ai(x), Ai'(x), Bi(x), Bi'(x))
ai_vals, _, _, _ = airy(-z)  # Ai(-z)

# --- Find zero crossings in the collapse zone (z > 0) ---
sign_changes = np.where(np.diff(np.sign(ai_vals)))[0]
zero_z = []
for idx in sign_changes:
    # Linear interpolation for precise zero
    z0 = z[idx] - ai_vals[idx] * (z[idx+1] - z[idx]) / (ai_vals[idx+1] - ai_vals[idx])
    zero_z.append(z0)
zero_z = np.array(zero_z)

# --- Envelope: ±|z|^{-1/4} / sqrt(pi) for z > 1 ---
z_env = np.linspace(1.5, 18, 500)
envelope = 1.0 / (np.sqrt(np.pi) * z_env**0.25)

# --- Plot ---
fig, ax = plt.subplots(figsize=(14, 5.5))

# Background zones
ax.axvspan(-8, 0, alpha=0.08, color='#2166ac', zorder=0)
ax.axvspan(0, 18, alpha=0.08, color='#b2182b', zorder=0)

# Turning point
ax.axvline(0, color='#333333', linewidth=2.0, linestyle='-', alpha=0.7, zorder=1)
ax.text(0, ax.get_ylim()[0] if ax.get_ylim()[0] != 0 else -0.1, r'$\rho = 0$',
        ha='center', va='top', fontsize=13, fontweight='bold',
        bbox=dict(boxstyle='round,pad=0.3', facecolor='white', edgecolor='#333', alpha=0.9))

# Main curve
ax.plot(z, ai_vals, color='#1a1a2e', linewidth=1.8, zorder=3, label=r'$\psi(z) = \mathrm{Ai}(-z)$')

# Envelope
ax.plot(z_env, envelope, '--', color='#b2182b', linewidth=1.0, alpha=0.6, label=r'Envelope $\pm\, z^{-1/4}/\sqrt{\pi}$')
ax.plot(z_env, -envelope, '--', color='#b2182b', linewidth=1.0, alpha=0.6)

# Zero crossings
for i, zc in enumerate(zero_z):
    if zc > 0:
        ax.plot(zc, 0, 'o', color='#b2182b', markersize=5, zorder=4)

# Zone labels
ax.text(-4.0, 0.38, 'SURVIVAL ZONE\n' + r'$\rho_i > 0$' + '\n\nExponential decay\nNo zero crossings\n"Exhausted but standing"',
        ha='center', va='top', fontsize=10, color='#2166ac',
        bbox=dict(boxstyle='round,pad=0.4', facecolor='white', edgecolor='#2166ac', alpha=0.8))

ax.text(11.0, 0.38, 'COLLAPSE ZONE\n' + r'$\rho_i < 0$' + '\n\nOscillatory, amplitude → 0\nZero crossings = brief resistance\n"Quiet subjects, peaceful rule"',
        ha='center', va='top', fontsize=10, color='#b2182b',
        bbox=dict(boxstyle='round,pad=0.4', facecolor='white', edgecolor='#b2182b', alpha=0.8))

# Turning point label
ax.annotate(r'Critical threshold $x_c$' + '\n' + r'First agent reaches $\rho = 0$',
            xy=(0, 0.355), xytext=(3.5, 0.52),
            fontsize=9.5, ha='left', color='#333',
            arrowprops=dict(arrowstyle='->', color='#333', lw=1.2),
            bbox=dict(boxstyle='round,pad=0.3', facecolor='#ffffcc', edgecolor='#333', alpha=0.9))

# Annotate zero crossings
if len(zero_z[zero_z > 0]) >= 3:
    zc_pos = zero_z[zero_z > 0]
    ax.annotate('Airy zeros:\nbrief collective resistance\n(frequency ↑, amplitude ↓)',
                xy=(zc_pos[2], 0), xytext=(zc_pos[2] + 2.5, -0.22),
                fontsize=8.5, ha='left', color='#b2182b',
                arrowprops=dict(arrowstyle='->', color='#b2182b', lw=1.0))

# Asymptotic formulas
ax.text(-6.5, 0.02, r'$\sim e^{-\frac{2}{3}|z|^{3/2}}$',
        fontsize=12, color='#2166ac', ha='center', style='italic')
ax.text(15.5, 0.12, r'$\sim \frac{\sin(\frac{2}{3}z^{3/2}+\frac{\pi}{4})}{z^{1/4}\sqrt{\pi}}$',
        fontsize=11, color='#b2182b', ha='center', style='italic')

ax.set_xlabel(r'$z = (c/\sigma)^{1/3}(x - x_c)$ — Position on proximity-to-power manifold', fontsize=11)
ax.set_ylabel(r'$\psi(z)$ — Effective retaliation field', fontsize=11)
ax.set_title('Constraint Cascade: Airy Turning Point at the Zero-Retaliation Boundary', fontsize=13, fontweight='bold')
ax.set_xlim(-8, 18)
ax.set_ylim(-0.45, 0.62)
ax.legend(loc='upper left', fontsize=9, framealpha=0.9)
ax.grid(True, alpha=0.2)

plt.tight_layout()
plt.savefig(str(OUTPUT_DIR / 'airy_cascade_turning_point.png'), dpi=300, bbox_inches='tight')
plt.savefig(str(OUTPUT_DIR / 'airy_cascade_turning_point.pdf'), bbox_inches='tight')
print(f"Saved to {OUTPUT_DIR / 'airy_cascade_turning_point.png'}")
print(f"Saved to {OUTPUT_DIR / 'airy_cascade_turning_point.pdf'}")

# --- Print zero locations ---
print(f"\nAiry zeros (collapse zone, z > 0):")
for i, zc in enumerate(zero_z[zero_z > 0]):
    print(f"  Zero {i+1}: z = {zc:.4f}")
print(f"\nTotal zeros in collapse zone: {np.sum(zero_z > 0)}")
print(f"Total zeros in survival zone: {np.sum(zero_z < 0)} (should be 0)")

# --- Spacing analysis ---
zc_pos = zero_z[zero_z > 0]
if len(zc_pos) >= 2:
    spacings = np.diff(zc_pos)
    print(f"\nZero spacings (should decrease ~ z^{{-1/2}}):")
    for i, s in enumerate(spacings):
        print(f"  Δz_{i+1} = {s:.4f}")
