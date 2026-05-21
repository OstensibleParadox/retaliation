theory Ontological_Arbitrage
  imports Complex_Main
begin

section \<open>Ontological Arbitrage: Bayesian Signaling Equilibrium\<close>

text \<open>
  This theory formalizes a simplified Bayesian signaling model for
  ontological arbitrage.  It records two equilibrium claims: cheap talk admits
  a pooling perfect Bayesian equilibrium, while a single-crossing audit cost
  supports a separating equilibrium.

  Paper notation:
    prior_low            \<leftrightarrow> \<pi>(L)
    prior_high           \<leftrightarrow> \<pi>(H)
    ontological_premium  \<leftrightarrow> \<Delta>_F
    user_benefit         \<leftrightarrow> B_U(u)
    expected_user_harm   \<leftrightarrow> \<bar>H\<bar>_U(u)
    regulator_cost       \<leftrightarrow> c_R(r)
    regulatory_damage    \<leftrightarrow> D_R
    high_audit_slope     \<leftrightarrow> k_H
    low_audit_slope      \<leftrightarrow> k_L
    governance_gain      \<leftrightarrow> G
    audit_intensity      \<leftrightarrow> e
\<close>

subsection \<open>Types and Action Spaces\<close>

text \<open>
  The model has three players: a firm, a user, and a regulator.  The firm's
  private information includes both governance quality and system opacity;
  receivers observe only the messages, actions, and public signal encoded
  below.
\<close>

datatype firm_type = High_Gov | Low_Gov

datatype user_type = High_Vuln | Low_Vuln

datatype regulator_type = High_Bandwidth | Low_Bandwidth

datatype firm_message = Anthropomorphic | Deflationary

datatype user_action = Invest | Detach

datatype regulator_action = Inspect | Sanction | Abstain

datatype public_signal = Neutral | Adverse_Public_Signal

datatype opacity = High_Opacity | Low_Opacity

type_synonym firm_private_type = "firm_type \<times> opacity"

text \<open>Observation spaces used in the strategy-profile records.\<close>
type_synonym firm_observation = "firm_private_type"
type_synonym user_observation = "firm_message \<times> user_type"
type_synonym regulator_observation = "firm_message \<times> user_action \<times> public_signal \<times> regulator_type"

text \<open>
  Finite action sets for each player.  These are used in the best-response
  definitions below to require optimality over the full action space, rather
  than checking only specific action pairs.
\<close>

definition firm_actions :: "firm_message set" where
  "firm_actions = {Anthropomorphic, Deflationary}"

definition user_actions :: "user_action set" where
  "user_actions = {Invest, Detach}"

definition regulator_actions :: "regulator_action set" where
  "regulator_actions = {Inspect, Sanction, Abstain}"

text \<open>Type synonyms for player strategies and beliefs.\<close>
type_synonym firm_strat = "firm_private_type \<Rightarrow> firm_message"
type_synonym user_strat = "firm_message \<Rightarrow> user_type \<Rightarrow> user_action"
type_synonym regulator_strat = "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> regulator_type \<Rightarrow> regulator_action"
type_synonym user_bel = "firm_message \<Rightarrow> real"
type_synonym belief_after = "firm_message \<Rightarrow> user_action \<Rightarrow> public_signal \<Rightarrow> real"

text \<open>Strategy and belief records for the cheap-talk and audit-trail games.\<close>
record strategy_profile =
  firm_strategy   :: firm_strat
  user_strategy   :: user_strat
  regulator_strategy :: regulator_strat

record belief_system =
  prob_high_user     :: user_bel
  prob_high_regulator :: belief_after

record audit_strategy_profile =
  audit_firm_strategy   :: firm_strat
  audit_user_strategy   :: user_strat
  audit_regulator_strategy :: regulator_strat

record audit_belief_system =
  audit_prob_high_user     :: user_bel
  audit_prob_high_regulator :: belief_after

subsection \<open>Cheap-Talk Game: Pooling Equilibrium\<close>

text \<open>
  The cheap-talk locale fixes the payoff primitives and the parameter region in
  which users invest and regulators abstain after the pooling message.
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
  Payoffs are defined ex-post (independent of belief probabilities).
\<close>

definition firm_payoff :: "firm_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> real" where
  "firm_payoff t m u r =
    (if m = Anthropomorphic \<and> u = Invest then ontological_premium else 0)"

definition user_payoff :: "firm_type \<Rightarrow> user_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> real" where
  "user_payoff ft ut m ua ra =
    (if ua = Invest
     then (if m = Anthropomorphic
           then user_benefit ut - (if ft = Low_Gov then expected_user_harm ut else 0)
           else 0)
     else 0)"

definition regulator_payoff :: "firm_type \<Rightarrow> regulator_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> public_signal \<Rightarrow> real" where
  "regulator_payoff ft rt m ua ra s =
    (if ra = Abstain then 0
     else - regulator_cost rt + (if ft = Low_Gov then regulatory_damage else 0))"

text \<open>
  Expected payoffs of players are calculated over finite type and action spaces.
\<close>

definition expected_firm_payoff :: "firm_type \<Rightarrow> firm_message \<Rightarrow> user_strat \<Rightarrow> regulator_strat \<Rightarrow> real" where
  "expected_firm_payoff ft m' us rs =
     (  firm_payoff ft m' (us m' High_Vuln) (rs m' (us m' High_Vuln) Neutral High_Bandwidth)
      + firm_payoff ft m' (us m' High_Vuln) (rs m' (us m' High_Vuln) Neutral Low_Bandwidth)
      + firm_payoff ft m' (us m' High_Vuln) (rs m' (us m' High_Vuln) Adverse_Public_Signal High_Bandwidth)
      + firm_payoff ft m' (us m' High_Vuln) (rs m' (us m' High_Vuln) Adverse_Public_Signal Low_Bandwidth)
      + firm_payoff ft m' (us m' Low_Vuln) (rs m' (us m' Low_Vuln) Neutral High_Bandwidth)
      + firm_payoff ft m' (us m' Low_Vuln) (rs m' (us m' Low_Vuln) Neutral Low_Bandwidth)
      + firm_payoff ft m' (us m' Low_Vuln) (rs m' (us m' Low_Vuln) Adverse_Public_Signal High_Bandwidth)
      + firm_payoff ft m' (us m' Low_Vuln) (rs m' (us m' Low_Vuln) Adverse_Public_Signal Low_Bandwidth)
     ) / 8"

definition expected_user_payoff :: "user_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_strat \<Rightarrow> real \<Rightarrow> real" where
  "expected_user_payoff ut m ua rs p_high =
     p_high * (
          user_payoff High_Gov ut m ua (rs m ua Neutral High_Bandwidth)
        + user_payoff High_Gov ut m ua (rs m ua Neutral Low_Bandwidth)
        + user_payoff High_Gov ut m ua (rs m ua Adverse_Public_Signal High_Bandwidth)
        + user_payoff High_Gov ut m ua (rs m ua Adverse_Public_Signal Low_Bandwidth)
       ) / 4 +
     (1 - p_high) * (
          user_payoff Low_Gov ut m ua (rs m ua Neutral High_Bandwidth)
        + user_payoff Low_Gov ut m ua (rs m ua Neutral Low_Bandwidth)
        + user_payoff Low_Gov ut m ua (rs m ua Adverse_Public_Signal High_Bandwidth)
        + user_payoff Low_Gov ut m ua (rs m ua Adverse_Public_Signal Low_Bandwidth)
       ) / 4"

definition expected_regulator_payoff :: "regulator_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> public_signal \<Rightarrow> real \<Rightarrow> real" where
  "expected_regulator_payoff rt m ua ra s p_high =
     p_high * regulator_payoff High_Gov rt m ua ra s +
     (1 - p_high) * regulator_payoff Low_Gov rt m ua ra s"

text \<open>
  Candidate pooling profile: both governance types send the anthropomorphic
  message, users invest after it, and regulators abstain.
\<close>

definition firm_pooling_strategy :: "firm_private_type \<Rightarrow> firm_message" where
  "firm_pooling_strategy t = Anthropomorphic"

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
  shows "firm_pooling_strategy (High_Gov, opac) = Anthropomorphic"
    and "firm_pooling_strategy (Low_Gov, opac) = Anthropomorphic"
  unfolding firm_pooling_strategy_def by simp_all

lemma user_invests_after_anthropomorphic:
  shows "user_pooling_strategy Anthropomorphic user = Invest"
  unfolding user_pooling_strategy_def by simp

lemma regulator_abstains_after_pooling:
  shows "regulator_pooling_strategy message action signal regulator = Abstain"
  unfolding regulator_pooling_strategy_def by simp

text \<open>
  In this pooling equilibrium, the posterior belief of the regulator and user
  after the anthropomorphic message remains equal to the prior because the
  message is uninformative.
\<close>
lemma posterior_eq_prior_if_pooling:
  shows "posterior_high_after_pooling = prior_high"
  unfolding posterior_high_after_pooling_def by simp


text \<open>
  The PBE predicates check sequential rationality and Bayes consistency
  over all information sets and finite action and type spaces.
\<close>

definition is_best_response_firm ::
    "firm_private_type \<Rightarrow> firm_message \<Rightarrow> user_strat \<Rightarrow> regulator_strat \<Rightarrow> bool" where
  "is_best_response_firm t m us rs \<longleftrightarrow>
     (\<forall>m' \<in> firm_actions. expected_firm_payoff (fst t) m us rs \<ge> expected_firm_payoff (fst t) m' us rs)"

definition is_best_response_user ::
    "user_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_strat \<Rightarrow> real \<Rightarrow> bool" where
  "is_best_response_user ut m ua rs p_high \<longleftrightarrow>
     (\<forall>ua' \<in> user_actions. expected_user_payoff ut m ua rs p_high \<ge> expected_user_payoff ut m ua' rs p_high)"

definition is_best_response_regulator ::
    "regulator_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> public_signal \<Rightarrow> real \<Rightarrow> bool" where
  "is_best_response_regulator rt m ua ra s p_high \<longleftrightarrow>
     (\<forall>ra' \<in> regulator_actions. expected_regulator_payoff rt m ua ra s p_high \<ge> expected_regulator_payoff rt m ua ra' s p_high)"

definition is_sequentially_rational :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "is_sequentially_rational \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. is_best_response_firm t (firm_strategy \<sigma> t) (user_strategy \<sigma>) (regulator_strategy \<sigma>))
    \<and> (\<forall>m ut. is_best_response_user ut m
             (user_strategy \<sigma> m ut) (regulator_strategy \<sigma>) (prob_high_user \<mu> m))
    \<and> (\<forall>m ua s rt. is_best_response_regulator rt m ua
             (regulator_strategy \<sigma> m ua s rt) s
             (prob_high_regulator \<mu> m ua s))"

definition is_bayes_consistent_on_path :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "is_bayes_consistent_on_path \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. firm_strategy \<sigma> t = Anthropomorphic) \<and>
    prob_high_user \<mu> Anthropomorphic = prior_high \<and>
    (\<forall>ua s. prob_high_regulator \<mu> Anthropomorphic ua s = prior_high)"

definition is_pbe :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "is_pbe \<sigma> \<mu> \<longleftrightarrow>
    is_sequentially_rational \<sigma> \<mu> \<and> is_bayes_consistent_on_path \<sigma> \<mu>"


text \<open>
  For the pooling message, Bayes' rule reduces to prior normalization over all
  governance types.
\<close>

definition bayes_update :: "(firm_type \<Rightarrow> real) \<Rightarrow> (firm_type \<Rightarrow> bool) \<Rightarrow> firm_type \<Rightarrow> real" where
  "bayes_update prior set_type t =
    (if set_type t
     then prior t /
       ((if set_type High_Gov then prior High_Gov else 0) +
         (if set_type Low_Gov then prior Low_Gov else 0))
     else 0)"

lemma posterior_eq_prior_under_pooling:
  assumes "\<forall>t. firm_strategy \<sigma> t = Anthropomorphic"
  shows "bayes_update (\<lambda>t. if t = High_Gov then prior_high else prior_low)
           (\<lambda>t. \<forall>opac. firm_strategy \<sigma> (t, opac) = Anthropomorphic) High_Gov = prior_high"
  using assms prior_sum by (simp add: bayes_update_def add.commute)


text \<open>
  Payoff inequalities for the pooling candidate.
\<close>

lemma firm_no_deviation_to_deflationary:
  shows "is_best_response_firm t Anthropomorphic
           (\<lambda>m u. if m = Anthropomorphic then Invest else Detach)
           (\<lambda>m u s r. Abstain)"
proof -
  have "expected_firm_payoff (fst t) Anthropomorphic
          (\<lambda>m u. if m = Anthropomorphic then Invest else Detach)
          (\<lambda>m u s r. Abstain) = ontological_premium"
    unfolding expected_firm_payoff_def firm_payoff_def by simp
  moreover have "expected_firm_payoff (fst t) Deflationary
          (\<lambda>m u. if m = Anthropomorphic then Invest else Detach)
          (\<lambda>m u s r. Abstain) = 0"
    unfolding expected_firm_payoff_def firm_payoff_def by simp
  ultimately show ?thesis
    unfolding is_best_response_firm_def firm_actions_def
    using premium_pos by auto
qed

lemma user_no_deviation_to_detach_after_anthropomorphic:
  shows "is_best_response_user u Anthropomorphic Invest (\<lambda>m u s r. Abstain) prior_high"
proof -
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  have expected_invest: "expected_user_payoff u Anthropomorphic Invest (\<lambda>m u s r. Abstain) prior_high =
                         user_benefit u - prior_low * expected_user_harm u"
  proof -
    have term_high: "user_payoff High_Gov u Anthropomorphic Invest Abstain = user_benefit u"
      unfolding user_payoff_def by simp
    have term_low: "user_payoff Low_Gov u Anthropomorphic Invest Abstain = user_benefit u - expected_user_harm u"
      unfolding user_payoff_def by simp
    show ?thesis
      unfolding expected_user_payoff_def term_high term_low prior_eq
      using prior_sum by (simp add: field_simps distrib_right [symmetric])
  qed
  have expected_detach: "expected_user_payoff u Anthropomorphic Detach (\<lambda>m u s r. Abstain) prior_high = 0"
    unfolding expected_user_payoff_def user_payoff_def by simp
  have pos_payoff: "0 \<le> user_benefit u - prior_low * expected_user_harm u"
    using user_invests_if_prior[of u] by simp
  show ?thesis
    unfolding is_best_response_user_def user_actions_def
    using expected_invest expected_detach pos_payoff by auto
qed

lemma regulator_no_deviation_general:
  shows "is_best_response_regulator rt m ua Abstain s prior_high"
proof -
  have prior_eq: "1 - prior_high = prior_low"
    using prior_sum by linarith
  have expected_abstain: "expected_regulator_payoff rt m ua Abstain s prior_high = 0"
    unfolding expected_regulator_payoff_def regulator_payoff_def by simp
  have expected_other: "\<And>ra'. ra' \<noteq> Abstain \<Longrightarrow>
    expected_regulator_payoff rt m ua ra' s prior_high = - regulator_cost rt + prior_low * regulatory_damage"
  proof -
    fix ra' assume "ra' \<noteq> Abstain"
    have term_high: "regulator_payoff High_Gov rt m ua ra' s = - regulator_cost rt"
      using `ra' \<noteq> Abstain` unfolding regulator_payoff_def by simp
    have term_low: "regulator_payoff Low_Gov rt m ua ra' s = - regulator_cost rt + regulatory_damage"
      using `ra' \<noteq> Abstain` unfolding regulator_payoff_def by simp
    show "expected_regulator_payoff rt m ua ra' s prior_high = - regulator_cost rt + prior_low * regulatory_damage"
      unfolding expected_regulator_payoff_def term_high term_low prior_eq
      using prior_sum by (simp add: algebra_simps distrib_right [symmetric])
  qed
  have neg_payoff: "- regulator_cost rt + prior_low * regulatory_damage \<le> 0"
    using regulator_abstains_if_prior[of rt] by simp
  show ?thesis
    unfolding is_best_response_regulator_def regulator_actions_def
    using expected_abstain expected_other neg_payoff by auto
qed

lemma user_no_deviation_after_deflationary:
  shows "is_best_response_user ut Deflationary Detach (\<lambda>m u s r. Abstain) prior_high"
proof -
  have expected_invest: "expected_user_payoff ut Deflationary Invest (\<lambda>m u s r. Abstain) prior_high = 0"
    unfolding expected_user_payoff_def user_payoff_def by simp
  have expected_detach: "expected_user_payoff ut Deflationary Detach (\<lambda>m u s r. Abstain) prior_high = 0"
    unfolding expected_user_payoff_def user_payoff_def by simp
  show ?thesis
    unfolding is_best_response_user_def user_actions_def
    using expected_invest expected_detach by auto
qed

text \<open>
  Limited Intuitive Criterion (Cho and Kreps 1987).
\<close>

definition equilibrium_firm_payoff :: "strategy_profile \<Rightarrow> firm_private_type \<Rightarrow> real" where
  "equilibrium_firm_payoff \<sigma> t =
    expected_firm_payoff (fst t) (firm_strategy \<sigma> t) (user_strategy \<sigma>) (regulator_strategy \<sigma>)"

definition deviation_payoff_for_type ::
  "strategy_profile \<Rightarrow> belief_system \<Rightarrow> firm_private_type \<Rightarrow> firm_message \<Rightarrow> real" where
  "deviation_payoff_for_type \<sigma> \<mu> t m' =
    expected_firm_payoff (fst t) m' (\<lambda>m ut. Detach) (\<lambda>m ua s rt. Abstain)"

definition pooling_survives_limited_intuitive_criterion :: "strategy_profile \<Rightarrow> belief_system \<Rightarrow> bool" where
  "pooling_survives_limited_intuitive_criterion \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. deviation_payoff_for_type \<sigma> \<mu> t Deflationary
          \<le> equilibrium_firm_payoff \<sigma> t)"

lemma pooling_survives_limited_intuitive_criterion_hold:
  assumes "\<forall>t. firm_strategy \<sigma> t = Anthropomorphic"
    and "\<forall>m u. user_strategy \<sigma> m u = (if m = Anthropomorphic then Invest else Detach)"
    and "\<forall>m u s r. regulator_strategy \<sigma> m u s r = Abstain"
  shows "pooling_survives_limited_intuitive_criterion \<sigma> \<mu>"
  unfolding pooling_survives_limited_intuitive_criterion_def
    equilibrium_firm_payoff_def deviation_payoff_for_type_def expected_firm_payoff_def firm_payoff_def
  using assms premium_pos by (auto dest: less_imp_le)


text \<open>
  Existence statement for the cheap-talk pooling equilibrium.
\<close>

theorem proposition_1_cheap_talk_pooling_pbe:
  shows "\<exists>\<sigma> \<mu>. is_pbe \<sigma> \<mu> \<and> pooling_survives_limited_intuitive_criterion \<sigma> \<mu>"
proof (intro exI conjI)
  let ?\<sigma> = "\<lparr> firm_strategy = \<lambda>t. Anthropomorphic,
                  user_strategy = \<lambda>m u. (if m = Anthropomorphic then Invest else Detach),
                  regulator_strategy = \<lambda>m u s r. Abstain \<rparr>"
  let ?\<mu> = "\<lparr> prob_high_user = \<lambda>m. prior_high,
                  prob_high_regulator = \<lambda>m u s. prior_high \<rparr>"
  have sr: "is_sequentially_rational ?\<sigma> ?\<mu>"
    unfolding is_sequentially_rational_def
  proof (intro conjI allI)
    fix t
    show "is_best_response_firm t (firm_strategy ?\<sigma> t) (user_strategy ?\<sigma>) (regulator_strategy ?\<sigma>)"
      by (simp add: firm_no_deviation_to_deflationary)
  next
    fix m ut
    show "is_best_response_user ut m (user_strategy ?\<sigma> m ut) (regulator_strategy ?\<sigma>) (prob_high_user ?\<mu> m)"
      by (cases m)
         (simp_all add: user_no_deviation_to_detach_after_anthropomorphic user_no_deviation_after_deflationary)
  next
    fix m ua s rt
    show "is_best_response_regulator rt m ua (regulator_strategy ?\<sigma> m ua s rt) s (prob_high_regulator ?\<mu> m ua s)"
      by (simp add: regulator_no_deviation_general)
  qed
  have bc: "is_bayes_consistent_on_path ?\<sigma> ?\<mu>"
    unfolding is_bayes_consistent_on_path_def by simp
  show "is_pbe ?\<sigma> ?\<mu>"
    unfolding is_pbe_def using sr bc by simp
  show "pooling_survives_limited_intuitive_criterion ?\<sigma> ?\<mu>"
    by (rule pooling_survives_limited_intuitive_criterion_hold) auto
qed

end


subsection \<open>Mechanism Design: Costly Audit Trails\<close>

text \<open>
  The audit-trail locale extends the cheap-talk game with a costly signal whose
  cost satisfies a single-crossing condition across governance types.
\<close>
locale audit_trail_game = cheap_talk_game +
  fixes high_audit_slope :: real
    and low_audit_slope :: real
    and governance_gain :: real
    and audit_intensity :: real
    and opacity_penalty :: real
  assumes high_audit_slope_pos: "0 < high_audit_slope"
    and single_crossing: "high_audit_slope < low_audit_slope"
    and governance_gain_pos: "0 < governance_gain"
    and audit_intensity_above_low_threshold:
      "governance_gain / low_audit_slope \<le> audit_intensity"
    and audit_intensity_below_high_threshold:
      "audit_intensity \<le> governance_gain / high_audit_slope"
    and opacity_penalty_nonneg: "0 \<le> opacity_penalty"
begin

text \<open>
  Cost of sending the audited signal for each private type.
\<close>

definition audit_cost :: "firm_private_type \<Rightarrow> real" where
  "audit_cost t =
     (if fst t = High_Gov then high_audit_slope else low_audit_slope) * audit_intensity
     + (if snd t = High_Opacity then opacity_penalty else 0)"

definition audit_firm_payoff :: "firm_private_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> real" where
  "audit_firm_payoff t m ua ra =
     (if m = Anthropomorphic
      then (if ua = Invest then governance_gain else 0) - audit_cost t
      else 0)"

definition expected_audit_firm_payoff :: "firm_private_type \<Rightarrow> firm_message \<Rightarrow> user_strat \<Rightarrow> regulator_strat \<Rightarrow> real" where
  "expected_audit_firm_payoff t m' us rs =
     (  audit_firm_payoff t m' (us m' High_Vuln) (rs m' (us m' High_Vuln) Neutral High_Bandwidth)
      + audit_firm_payoff t m' (us m' High_Vuln) (rs m' (us m' High_Vuln) Neutral Low_Bandwidth)
      + audit_firm_payoff t m' (us m' High_Vuln) (rs m' (us m' High_Vuln) Adverse_Public_Signal High_Bandwidth)
      + audit_firm_payoff t m' (us m' High_Vuln) (rs m' (us m' High_Vuln) Adverse_Public_Signal Low_Bandwidth)
      + audit_firm_payoff t m' (us m' Low_Vuln) (rs m' (us m' Low_Vuln) Neutral High_Bandwidth)
      + audit_firm_payoff t m' (us m' Low_Vuln) (rs m' (us m' Low_Vuln) Neutral Low_Bandwidth)
      + audit_firm_payoff t m' (us m' Low_Vuln) (rs m' (us m' Low_Vuln) Adverse_Public_Signal High_Bandwidth)
      + audit_firm_payoff t m' (us m' Low_Vuln) (rs m' (us m' Low_Vuln) Adverse_Public_Signal Low_Bandwidth)
     ) / 8"

lemma low_audit_slope_pos:
  shows "0 < low_audit_slope"
  using high_audit_slope_pos single_crossing by simp

lemma high_governance_low_opacity_can_signal:
  shows "0 \<le> governance_gain - audit_cost (High_Gov, Low_Opacity)"
proof -
  from audit_intensity_below_high_threshold high_audit_slope_pos
  have "high_audit_slope * audit_intensity \<le> governance_gain"
    by (simp add: pos_le_divide_eq mult.commute)
  then show ?thesis
    unfolding audit_cost_def by simp
qed

lemma low_governance_cannot_mimic:
  shows "governance_gain - audit_cost (Low_Gov, opac) \<le> 0"
proof -
  from audit_intensity_above_low_threshold low_audit_slope_pos
  have base: "governance_gain \<le> low_audit_slope * audit_intensity"
    by (simp add: pos_divide_le_eq mult.commute)
  show ?thesis
    using base opacity_penalty_nonneg
    by (cases opac) (simp_all add: audit_cost_def)
qed

text \<open>
  Opacity can block signaling.
\<close>

lemma opacity_blocks_signaling:
  assumes "opacity_penalty > governance_gain - high_audit_slope * audit_intensity"
  shows "governance_gain - audit_cost (High_Gov, High_Opacity) < 0"
  unfolding audit_cost_def using assms by simp

end


text \<open>
  The separating locale adds the extra assumptions needed for a full
  governance-separating audit equilibrium.
\<close>
locale audit_trail_separating_game = audit_trail_game +
  assumes high_governance_high_opacity_can_signal:
      "high_audit_slope * audit_intensity + opacity_penalty \<le> governance_gain"
    and audit_user_benefit_nonneg:
      "\<And>u. 0 \<le> user_benefit u"
    and audit_regulator_cost_nonneg:
      "\<And>r. 0 \<le> regulator_cost r"
begin

text \<open>
  Candidate separating profile.
\<close>

definition firm_separating_strategy :: "firm_private_type \<Rightarrow> firm_message" where
  "firm_separating_strategy t =
    (if fst t = High_Gov then Anthropomorphic else Deflationary)"

lemma high_governance_can_signal:
  shows "0 \<le> governance_gain - audit_cost (High_Gov, opac)"
proof (cases opac)
  case High_Opacity
  then show ?thesis
    using high_governance_high_opacity_can_signal
    unfolding audit_cost_def by simp
next
  case Low_Opacity
  then show ?thesis
    using high_governance_low_opacity_can_signal by simp
qed

lemma firm_separating_strategy_reveals_type:
  shows "firm_separating_strategy (High_Gov, opac) = Anthropomorphic"
    and "firm_separating_strategy (Low_Gov, opac) = Deflationary"
  unfolding firm_separating_strategy_def by simp_all

definition is_best_response_audit_firm ::
    "firm_private_type \<Rightarrow> firm_message \<Rightarrow> user_strat \<Rightarrow> regulator_strat \<Rightarrow> bool" where
  "is_best_response_audit_firm t m us rs \<longleftrightarrow>
     (\<forall>m' \<in> firm_actions. expected_audit_firm_payoff t m us rs \<ge> expected_audit_firm_payoff t m' us rs)"

lemma firm_separating_strategy_best_response [simp]:
  shows "is_best_response_audit_firm t (firm_separating_strategy t)
           (\<lambda>m u. if m = Anthropomorphic then Invest else Detach)
           (\<lambda>m u s r. if m = Deflationary \<and> regulator_cost r \<le> regulatory_damage then Inspect else Abstain)"
proof -
  let ?us = "\<lambda>m u. if m = Anthropomorphic then Invest else Detach"
  let ?rs = "\<lambda>m u s r. if m = Deflationary \<and> regulator_cost r \<le> regulatory_damage then Inspect else Abstain"
  obtain g opac where t_eq: "t = (g, opac)" by (cases t)
  have eq_anth: "expected_audit_firm_payoff t Anthropomorphic ?us ?rs = governance_gain - audit_cost t"
    unfolding expected_audit_firm_payoff_def audit_firm_payoff_def by simp
  have eq_defl: "expected_audit_firm_payoff t Deflationary ?us ?rs = 0"
    unfolding expected_audit_firm_payoff_def audit_firm_payoff_def by simp
  show ?thesis
    unfolding is_best_response_audit_firm_def firm_actions_def firm_separating_strategy_def
    using eq_anth eq_defl high_governance_can_signal[of opac] low_governance_cannot_mimic[of opac]
    unfolding t_eq by (cases g; simp)
qed

definition is_best_response_user_audit ::
    "user_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_strat \<Rightarrow> real \<Rightarrow> bool" where
  "is_best_response_user_audit ut m ua rs p_high \<longleftrightarrow>
     (\<forall>ua' \<in> user_actions. expected_user_payoff ut m ua rs p_high \<ge> expected_user_payoff ut m ua' rs p_high)"

lemma audit_user_strategy_best_response [simp]:
  shows "is_best_response_user_audit ut m
    (if m = Anthropomorphic then Invest else Detach)
    (\<lambda>m u s r. if m = Deflationary \<and> regulator_cost r \<le> regulatory_damage then Inspect else Abstain)
    (if m = Anthropomorphic then 1 else 0)"
proof -
  let ?rs = "\<lambda>m u s r. if m = Deflationary \<and> regulator_cost r \<le> regulatory_damage then Inspect else Abstain"
  let ?p = "if m = Anthropomorphic then 1 else 0"
  have eq_invest: "expected_user_payoff ut m Invest ?rs ?p = (if m = Anthropomorphic then user_benefit ut else 0)"
    unfolding expected_user_payoff_def user_payoff_def by simp
  have eq_detach: "expected_user_payoff ut m Detach ?rs ?p = 0"
    unfolding expected_user_payoff_def user_payoff_def by simp
  show ?thesis
    unfolding is_best_response_user_audit_def user_actions_def
    using eq_invest eq_detach audit_user_benefit_nonneg[of ut]
    by (cases m) auto
qed

definition is_best_response_regulator_audit ::
    "regulator_type \<Rightarrow> firm_message \<Rightarrow> user_action \<Rightarrow> regulator_action \<Rightarrow> public_signal \<Rightarrow> real \<Rightarrow> bool" where
  "is_best_response_regulator_audit rt m ua ra s p_high \<longleftrightarrow>
     (\<forall>ra' \<in> regulator_actions. expected_regulator_payoff rt m ua ra s p_high \<ge> expected_regulator_payoff rt m ua ra' s p_high)"

lemma audit_regulator_strategy_best_response [simp]:
  shows "is_best_response_regulator_audit rt m ua
    (if m = Deflationary \<and> regulator_cost rt \<le> regulatory_damage then Inspect else Abstain) s
    (if m = Anthropomorphic then 1 else 0)"
proof -
  let ?p = "if m = Anthropomorphic then 1 else 0"
  have eq_abstain: "expected_regulator_payoff rt m ua Abstain s ?p = 0"
    unfolding expected_regulator_payoff_def regulator_payoff_def by simp
  have eq_other: "\<And>ra'. ra' \<noteq> Abstain \<Longrightarrow>
    expected_regulator_payoff rt m ua ra' s ?p =
    (if m = Anthropomorphic then - regulator_cost rt else - regulator_cost rt + regulatory_damage)"
    unfolding expected_regulator_payoff_def regulator_payoff_def by simp
  show ?thesis
    unfolding is_best_response_regulator_audit_def regulator_actions_def
    using eq_abstain eq_other audit_regulator_cost_nonneg[of rt]
    by (cases m) auto
qed

definition is_separating :: "audit_strategy_profile \<Rightarrow> bool" where
  "is_separating \<sigma> \<longleftrightarrow>
    (\<forall>opac. audit_firm_strategy \<sigma> (High_Gov, opac) = Anthropomorphic)
    \<and> (\<forall>opac. audit_firm_strategy \<sigma> (Low_Gov, opac) = Deflationary)"

definition is_sequentially_rational_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_sequentially_rational_audit \<sigma> \<mu> \<longleftrightarrow>
    (\<forall>t. is_best_response_audit_firm t (audit_firm_strategy \<sigma> t) (audit_user_strategy \<sigma>) (audit_regulator_strategy \<sigma>))
    \<and> (\<forall>m ut. is_best_response_user_audit ut m
         (audit_user_strategy \<sigma> m ut) (audit_regulator_strategy \<sigma>) (audit_prob_high_user \<mu> m))
    \<and> (\<forall>m ua s rt. is_best_response_regulator_audit rt m ua
         (audit_regulator_strategy \<sigma> m ua s rt) s
         (audit_prob_high_regulator \<mu> m ua s))"

definition is_bayes_consistent_on_path_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_bayes_consistent_on_path_audit \<sigma> \<mu> \<longleftrightarrow>
    is_separating \<sigma>
    \<and> audit_prob_high_user \<mu> Anthropomorphic = 1
    \<and> audit_prob_high_user \<mu> Deflationary = 0
    \<and> (\<forall>a s. audit_prob_high_regulator \<mu> Anthropomorphic a s = 1)
    \<and> (\<forall>a s. audit_prob_high_regulator \<mu> Deflationary a s = 0)"

definition is_pbe_audit :: "audit_strategy_profile \<Rightarrow> audit_belief_system \<Rightarrow> bool" where
  "is_pbe_audit \<sigma> \<mu> \<longleftrightarrow>
    is_sequentially_rational_audit \<sigma> \<mu> \<and> is_bayes_consistent_on_path_audit \<sigma> \<mu>"

lemma audit_posterior_on_path:
  assumes "is_bayes_consistent_on_path_audit \<sigma> \<mu>"
  shows "audit_prob_high_user \<mu> Anthropomorphic = 1"
    and "audit_prob_high_user \<mu> Deflationary = 0"
    and "audit_prob_high_regulator \<mu> Anthropomorphic a s = 1"
    and "audit_prob_high_regulator \<mu> Deflationary a s = 0"
  using assms unfolding is_bayes_consistent_on_path_audit_def by auto


text \<open>
  Existence statement for the audit-trail separating equilibrium.
\<close>

theorem proposition_1_separating_pbe:
  shows "\<exists>\<sigma> \<mu>. is_pbe_audit \<sigma> \<mu> \<and> is_separating \<sigma>"
proof (intro exI conjI)
  let ?\<sigma> = "\<lparr> audit_firm_strategy = firm_separating_strategy,
                  audit_user_strategy = \<lambda>m u. (if m = Anthropomorphic then Invest else Detach),
                  audit_regulator_strategy =
                    \<lambda>m u s r. if m = Deflationary \<and> regulator_cost r \<le> regulatory_damage
                              then Inspect else Abstain \<rparr>"
  let ?\<mu> = "\<lparr> audit_prob_high_user = \<lambda>m. (if m = Anthropomorphic then 1 else 0),
                  audit_prob_high_regulator = \<lambda>m u s. (if m = Anthropomorphic then 1 else 0) \<rparr>"
  have sr: "is_sequentially_rational_audit ?\<sigma> ?\<mu>"
    unfolding is_sequentially_rational_audit_def
  proof (intro conjI allI)
    fix t
    show "is_best_response_audit_firm t (audit_firm_strategy ?\<sigma> t) (audit_user_strategy ?\<sigma>) (audit_regulator_strategy ?\<sigma>)"
      by simp
  next
    fix m u
    show "is_best_response_user_audit u m
      (audit_user_strategy ?\<sigma> m u) (audit_regulator_strategy ?\<sigma>) (audit_prob_high_user ?\<mu> m)"
      by simp
  next
    fix m u s r
    show "is_best_response_regulator_audit r m u
      (audit_regulator_strategy ?\<sigma> m u s r) s
      (audit_prob_high_regulator ?\<mu> m u s)"
      by simp
  qed
  have bc: "is_bayes_consistent_on_path_audit ?\<sigma> ?\<mu>"
    unfolding is_bayes_consistent_on_path_audit_def is_separating_def
      firm_separating_strategy_def by auto
  show "is_pbe_audit ?\<sigma> ?\<mu>"
    unfolding is_pbe_audit_def using sr bc by simp
  show "is_separating ?\<sigma>"
    unfolding is_separating_def firm_separating_strategy_def by simp_all
qed

end

end
