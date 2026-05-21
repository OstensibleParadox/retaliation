theory Sanctionable_Inconsistency
  imports Ontological_Arbitrage
begin

section \<open>Mechanism: Sanctionable Inconsistency\<close>

text \<open>
  This theory extends the base ontological arbitrage model to formalize the
  "Sanctionable Inconsistency" mechanism. Firms make claims across multiple
  institutional channels. Inconsistency across these channels (e.g. 
  anthropomorphic marketing vs deflationary liability) becomes sanctionable.
\<close>

datatype claim_channel =
    Marketing
  | Product_UI
  | Safety_Documentation
  | Terms_of_Service
  | Litigation_Position
  | Regulatory_Filing

type_synonym claim_register = "claim_channel \<Rightarrow> firm_message"

definition user_facing :: "claim_channel \<Rightarrow> bool" where
  "user_facing c \<longleftrightarrow> c = Marketing \<or> c = Product_UI"

text \<open>
  Safety_Documentation is left neutral because it occupies an intermediate position 
  between consumer-facing marketing and formal legally binding filings, not directly 
  triggering the simple user_facing/liability_facing dichotomy in our baseline model.
\<close>

definition liability_facing :: "claim_channel \<Rightarrow> bool" where
  "liability_facing c \<longleftrightarrow>
     c = Terms_of_Service \<or> c = Litigation_Position \<or> c = Regulatory_Filing"

definition inconsistent_register :: "claim_register \<Rightarrow> bool" where
  "inconsistent_register r \<longleftrightarrow>
     (\<exists>u l. user_facing u \<and> liability_facing l
        \<and> r u = Anthropomorphic
        \<and> r l = Deflationary)"

record register_strategy_profile =
  register_firm_strategy :: "firm_private_type \<Rightarrow> claim_register"
  register_user_strategy :: "claim_register \<Rightarrow> user_type \<Rightarrow> user_action"
  register_regulator_strategy :: "claim_register \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> regulator_type \<Rightarrow> regulator_action"

record register_belief_system =
  register_prob_high_user :: "claim_register \<Rightarrow> real"
  register_prob_high_regulator :: "claim_register \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> real"

locale sanctionable_inconsistency = cheap_talk_game +
  fixes rho_R :: real
    and sanction_cost :: real
    and catastrophic_liability :: real
  assumes rho_R_bounds: "0 \<le> rho_R \<and> rho_R \<le> 1"
    and sanction_cost_nonneg: "0 \<le> sanction_cost"
    and catastrophic_liability_nonneg: "0 \<le> catastrophic_liability"
begin

definition expected_sanction :: real where
  "expected_sanction = rho_R * sanction_cost"

text \<open>
  A consistent-agentic register sends Anthropomorphic on every channel,
  including liability-facing ones. This avoids the cross-channel
  inconsistency predicate but exposes the firm to catastrophic liability
  because the firm has voluntarily accepted the higher ontological standard
  in its own legal filings.
\<close>
definition consistent_agentic :: "claim_register \<Rightarrow> bool" where
  "consistent_agentic r \<longleftrightarrow>
     (\<forall>c. r c = Anthropomorphic)"

text \<open>
  The payoff for an inconsistent register includes the ontological premium
  from user-facing channels, but incurs an expected sanction cost due to
  cross-channel contradiction. A consistent-agentic register earns the
  ontological premium but incurs the full catastrophic liability cost,
  because the firm has voluntarily extended agentic representations into
  its own liability-facing documents.
\<close>
definition firm_payoff_register :: "claim_register \<Rightarrow> real" where
  "firm_payoff_register r =
    (if inconsistent_register r then ontological_premium - expected_sanction
     else if consistent_agentic r then ontological_premium - catastrophic_liability
     else 0)"

text \<open>
  The baseline harmonized fallback yields zero payoff, as it assumes
  consistent messaging that does not arbitrage user and liability channels
  for the premium.
\<close>
definition is_best_response_register :: "claim_register \<Rightarrow> bool" where
  "is_best_response_register r \<longleftrightarrow>
    (\<forall>r'. firm_payoff_register r \<ge> firm_payoff_register r')"

theorem inconsistent_register_not_best_response:
  assumes "inconsistent_register r"
    and "expected_sanction > ontological_premium"
  shows "\<not> is_best_response_register r"
proof -
  have payoff_r: "firm_payoff_register r = ontological_premium - expected_sanction"
    using assms(1) unfolding firm_payoff_register_def by simp
  
  text \<open>Construct a harmonized register as a profitable deviation.\<close>
  let ?r_harm = "\<lambda>c. Deflationary"
  have "\<not> inconsistent_register ?r_harm"
    unfolding inconsistent_register_def by simp
  moreover have "\<not> consistent_agentic ?r_harm"
    unfolding consistent_agentic_def by auto
  ultimately have payoff_harm: "firm_payoff_register ?r_harm = 0"
    unfolding firm_payoff_register_def by simp

  from assms(2) payoff_r payoff_harm
  have "firm_payoff_register r < firm_payoff_register ?r_harm"
    by simp
  then show ?thesis
    unfolding is_best_response_register_def by (auto simp add: not_le)
qed

text \<open>
  The consistent-agentic strategy (sending Anthropomorphic everywhere) is
  not a best response when the catastrophic liability exceeds the
  ontological premium.  The firm can profitably deviate to the harmonized
  deflationary register.
\<close>
theorem consistent_agentic_not_best_response:
  assumes "consistent_agentic r"
    and "catastrophic_liability > ontological_premium"
  shows "\<not> is_best_response_register r"
proof -
  have not_inconsistent: "\<not> inconsistent_register r"
    using assms(1) unfolding consistent_agentic_def inconsistent_register_def
    by auto
  have payoff_r: "firm_payoff_register r = ontological_premium - catastrophic_liability"
    using assms(1) not_inconsistent unfolding firm_payoff_register_def by simp

  let ?r_harm = "\<lambda>c. Deflationary"
  have "\<not> inconsistent_register ?r_harm"
    unfolding inconsistent_register_def by simp
  moreover have "\<not> consistent_agentic ?r_harm"
    unfolding consistent_agentic_def by auto
  ultimately have payoff_harm: "firm_payoff_register ?r_harm = 0"
    unfolding firm_payoff_register_def by simp

  from assms(2) payoff_r payoff_harm
  have "firm_payoff_register r < firm_payoff_register ?r_harm"
    by simp
  then show ?thesis
    unfolding is_best_response_register_def by (auto simp add: not_le)
qed

text \<open>
  To bridge this game-theoretic result with equilibrium definitions, we introduce
  sequential rationality predicates for the multi-channel register game.
  Note that while the strategy profile and belief system records are defined 
  to represent the full register game structure, the bridge theorem below 
  focuses specifically on firm-side sequential rationality (demonstrating that 
  arbitrage inconsistency is pruned from any equilibrium path), rather than 
  constructing a full register-game PBE.
\<close>

definition register_is_best_response_firm :: "firm_private_type \<Rightarrow> claim_register \<Rightarrow> bool" where
  "register_is_best_response_firm t r \<longleftrightarrow> is_best_response_register r"

definition register_firm_sequentially_rational :: "register_strategy_profile \<Rightarrow> bool" where
  "register_firm_sequentially_rational \<sigma> \<longleftrightarrow>
     (\<forall>t. register_is_best_response_firm t (register_firm_strategy \<sigma> t))"

theorem inconsistent_on_path_not_sequentially_rational:
  assumes "expected_sanction > ontological_premium"
    and "inconsistent_register (register_firm_strategy \<sigma> t)"
  shows "\<not> register_firm_sequentially_rational \<sigma>"
proof -
  from assms(2) and assms(1) have "\<not> is_best_response_register (register_firm_strategy \<sigma> t)"
    using inconsistent_register_not_best_response by simp
  then have "\<not> register_is_best_response_firm t (register_firm_strategy \<sigma> t)"
    unfolding register_is_best_response_firm_def by simp
  then show ?thesis
    unfolding register_firm_sequentially_rational_def by metis
qed

text \<open>
  Bridge theorem: consistent-agentic claims on the equilibrium path are also
  pruned from any sequentially rational strategy profile.
\<close>
theorem consistent_agentic_on_path_not_sequentially_rational:
  assumes "catastrophic_liability > ontological_premium"
    and "consistent_agentic (register_firm_strategy \<sigma> t)"
  shows "\<not> register_firm_sequentially_rational \<sigma>"
proof -
  from assms(2) and assms(1) have "\<not> is_best_response_register (register_firm_strategy \<sigma> t)"
    using consistent_agentic_not_best_response by simp
  then have "\<not> register_is_best_response_firm t (register_firm_strategy \<sigma> t)"
    unfolding register_is_best_response_firm_def by simp
  then show ?thesis
    unfolding register_firm_sequentially_rational_def by metis
qed

end

end
