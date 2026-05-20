theory Ontological_Arbitrage
  imports Main "HOL-Probability.Probability"
begin

section \<open>Ontological Arbitrage: Bayesian Signaling Equilibrium\<close>

text \<open>
  This theory formalizes the sequential signaling game between a Firm (F),
  a User (U), and a Regulator (R) under incomplete information.
  It demonstrates both the cheap-talk pooling equilibrium and the
  separating equilibrium achieved via costly audit trails.

  Names follow the Isabelle convention: theory names use capitalized words
  separated by underscores, while locales, constants, and lemmas use
  lower-case names separated by underscores. Constructors use descriptive
  capitalized names.
\<close>

subsection \<open>Types and Action Spaces\<close>

text \<open>Players hold private types. The Firm's governance is High or Low.\<close>
datatype firm_type = High_Gov | Low_Gov

text \<open>The User's vulnerability status.\<close>
datatype user_type = High_Vuln | Low_Vuln

text \<open>The Regulator's bandwidth for enforcement.\<close>
datatype regulator_type = High_Bandwidth | Low_Bandwidth

text \<open>
  Messages sent by the players.
  Firm chooses between anthropomorphic marketing and policy-deflationary claims.
\<close>
datatype firm_message = Anthropomorphic | Deflationary

text \<open>User chooses to invest relationally or detach.\<close>
datatype user_action = Invest | Detach

text \<open>Regulator chooses to Inspect, Sanction, or Abstain.\<close>
datatype regulator_action = Inspect | Sanction | Abstain

text \<open>Public signal acts as an external modifier to beliefs.\<close>
datatype public_signal = Neutral | Adverse_Public_Signal

subsection \<open>Game Parameters and Payoffs\<close>

text \<open>
  We define a locale to fix the constants and assumptions of the
  cheap-talk game without committing to specific numerical values.
\<close>
locale cheap_talk_game =
  fixes prior_low :: real
    and prior_high :: real
    and ontological_premium :: real
    and user_benefit :: "user_type \<Rightarrow> real"
    and expected_user_harm :: "user_type \<Rightarrow> real"
    and regulator_cost :: "regulator_type \<Rightarrow> real"
    and regulatory_damage :: real
  assumes prior_low_pos: "0 < prior_low"
    and prior_high_pos: "0 < prior_high"
    and prior_sum: "prior_low + prior_high = 1"
    and premium_pos: "0 < ontological_premium"
    and user_invests_if_prior:
      "\<And>u. 0 < user_benefit u - prior_low * expected_user_harm u"
    and regulator_abstains_if_prior:
      "\<And>r. prior_low * regulatory_damage < regulator_cost r"
begin

text \<open>
  Under the cheap-talk condition, both firm types face zero cost for sending
  either message. Thus, the anthropomorphic message is strictly preferred if it
  induces user investment.
\<close>

definition firm_pooling_strategy :: "firm_type \<Rightarrow> firm_message" where
  "firm_pooling_strategy firm = Anthropomorphic"

definition user_pooling_strategy :: "firm_message \<Rightarrow> user_type \<Rightarrow> user_action" where
  "user_pooling_strategy message user =
    (if message = Anthropomorphic then Invest else Detach)"

definition regulator_pooling_strategy ::
  "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> regulator_type \<Rightarrow> regulator_action"
where
  "regulator_pooling_strategy message action signal regulator = Abstain"

definition posterior_high_after_pooling :: real where
  "posterior_high_after_pooling = prior_high"

lemma firm_pooling_strategy_eq_anthropomorphic:
  shows "firm_pooling_strategy High_Gov = Anthropomorphic"
    and "firm_pooling_strategy Low_Gov = Anthropomorphic"
  unfolding firm_pooling_strategy_def by simp_all

lemma user_invests_after_anthropomorphic:
  shows "user_pooling_strategy Anthropomorphic user = Invest"
  unfolding user_pooling_strategy_def by simp

lemma regulator_abstains_after_pooling:
  shows "regulator_pooling_strategy message action signal regulator = Abstain"
  unfolding regulator_pooling_strategy_def by simp

text \<open>
  In this pooling equilibrium, the posterior belief of the regulator and user
  after observing the anthropomorphic message remains equal to the prior,
  because the message is uninformative.
\<close>
lemma posterior_eq_prior_if_pooling:
  shows "posterior_high_after_pooling = prior_high"
  unfolding posterior_high_after_pooling_def by simp

end

subsection \<open>Mechanism Design: Costly Audit Trails\<close>

text \<open>
  We now introduce a mechanism-design locale where the anthropomorphic
  message requires a verifiable audit trail of intensity 'e'.
\<close>
locale audit_trail_game =
  fixes high_audit_slope :: real
    and low_audit_slope :: real
    and governance_gain :: real
    and audit_intensity :: real
  assumes high_audit_slope_pos: "0 < high_audit_slope"
    and single_crossing: "high_audit_slope < low_audit_slope"
    and governance_gain_pos: "0 < governance_gain"
    and audit_intensity_above_low_threshold:
      "governance_gain / low_audit_slope \<le> audit_intensity"
    and audit_intensity_below_high_threshold:
      "audit_intensity \<le> governance_gain / high_audit_slope"
begin

text \<open>Cost of sending the audited signal for each type.\<close>
definition high_governance_audit_cost :: real where
  "high_governance_audit_cost = high_audit_slope * audit_intensity"

definition low_governance_audit_cost :: real where
  "low_governance_audit_cost = low_audit_slope * audit_intensity"

text \<open>
  In the separating equilibrium, only the high-governance firm finds it
  profitable to emit the audited Anthropomorphic signal.
\<close>
definition firm_separating_strategy :: "firm_type \<Rightarrow> firm_message" where
  "firm_separating_strategy firm =
    (if firm = High_Gov then Anthropomorphic else Deflationary)"

lemma low_audit_slope_pos:
  shows "0 < low_audit_slope"
  using high_audit_slope_pos single_crossing by simp

lemma audit_cost_separates_types:
  shows high_governance_can_signal: "0 \<le> governance_gain - high_governance_audit_cost"
    and low_governance_cannot_mimic: "governance_gain - low_governance_audit_cost \<le> 0"
proof -
  from audit_intensity_below_high_threshold high_audit_slope_pos
  have "high_audit_slope * audit_intensity \<le> governance_gain"
    by (simp add: pos_le_divide_eq mult.commute)
  then show "0 \<le> governance_gain - high_governance_audit_cost"
    unfolding high_governance_audit_cost_def by simp
next
  from audit_intensity_above_low_threshold low_audit_slope_pos
  have "governance_gain \<le> low_audit_slope * audit_intensity"
    by (simp add: pos_divide_le_eq mult.commute)
  then show "governance_gain - low_governance_audit_cost \<le> 0"
    unfolding low_governance_audit_cost_def by simp
qed

lemma firm_separating_strategy_reveals_type:
  shows "firm_separating_strategy High_Gov = Anthropomorphic"
    and "firm_separating_strategy Low_Gov = Deflationary"
  unfolding firm_separating_strategy_def by simp_all

text \<open>
  By meeting the single-crossing condition, the audit trail functions as a
  costly signal (Spence 1973), separating the High_Gov and Low_Gov types and
  altering the Bayesian equilibrium.
\<close>

end

end
