theory Auditable_Records
  imports Ontological_Arbitrage
begin

section \<open>Mechanism: Auditable Records\<close>

text \<open>
  This theory formalizes the "Auditable Records" mechanism. Auditable records
  lower the regulator's cost of verification by a factor \<lambda> and increase the expected 
  detection value by \<eta>. When the inspection cost drops below the expected damage 
  from the low-governance type, abstention is no longer the regulator's best response.
\<close>

locale auditable_records_game = cheap_talk_game +
  fixes record_cost_reduction :: "regulator_type \<Rightarrow> real"
    and record_detection_boost :: real
  assumes reduction_pos: "\<And>r. 0 < record_cost_reduction r"
    and boost_pos: "0 < record_detection_boost"
    and record_cost_reduction_bounded: "\<And>r. record_cost_reduction r \<le> regulator_cost r"
    and inspection_becomes_rational: 
      "\<And>r. regulator_cost r - record_cost_reduction r < prior_low * (regulatory_damage + record_detection_boost)"
begin

text \<open>
  We define a modified regulator payoff that incorporates the reduced inspection cost
  and the boosted detection value.
\<close>

definition auditable_regulator_payoff :: "regulator_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> real \<Rightarrow> real" where
  "auditable_regulator_payoff r m u a p_high =
    (if a = Abstain then 0
     else - (regulator_cost r - record_cost_reduction r) + (1 - p_high) * (regulatory_damage + record_detection_boost))"

definition is_best_response_auditable_regulator ::
    "regulator_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> real \<Rightarrow> bool" where
  "is_best_response_auditable_regulator r m u a p_high \<longleftrightarrow>
     (\<forall>a' \<in> regulator_actions. auditable_regulator_payoff r m u a p_high \<ge> auditable_regulator_payoff r m u a' p_high)"

text \<open>
  Under the pooling belief (where posterior high governance equals prior high),
  active intervention (represented by Inspect) becomes a best response for the regulator.
  Note that in this baseline payoff structure, all non-Abstain (active intervention)
  actions share the same payoff representation, meaning Inspect and Sanction are both
  optimal. This represents active intervention becoming rational under auditable records.
\<close>

theorem active_intervention_rational_under_auditable_records:
  assumes "p_high = prior_high"
  shows "is_best_response_auditable_regulator r Anthropomorphic Invest Inspect p_high"
proof -
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  have "0 \<le> - (regulator_cost r - record_cost_reduction r) + prior_low * (regulatory_damage + record_detection_boost)"
    using inspection_becomes_rational[of r] by linarith
  then show ?thesis
    unfolding is_best_response_auditable_regulator_def regulator_actions_def auditable_regulator_payoff_def
    using assms prior_eq by auto
qed

theorem abstain_not_best_response_under_auditable_records:
  assumes "p_high = prior_high"
  shows "\<not> is_best_response_auditable_regulator r Anthropomorphic Invest Abstain p_high"
proof -
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  have "auditable_regulator_payoff r Anthropomorphic Invest Abstain p_high <
        auditable_regulator_payoff r Anthropomorphic Invest Inspect p_high"
    unfolding auditable_regulator_payoff_def
    using assms prior_eq inspection_becomes_rational[of r] by simp
  moreover have "Inspect \<in> regulator_actions"
    unfolding regulator_actions_def by simp
  ultimately show ?thesis
    unfolding is_best_response_auditable_regulator_def regulator_actions_def by auto
qed

end

end
