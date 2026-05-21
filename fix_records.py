import re

with open("isabelleHOL/Ontological_Arbitrage.thy", "r") as f:
    content = f.read()

# Remove strategy_profile and belief_system from inside cheap_talk_game
record_regex1 = re.compile(r"record strategy_profile =.*?firm_type \\<Rightarrow> real\"\n", re.DOTALL)
m1 = record_regex1.search(content)
if m1:
    rec1 = m1.group(0)
    content = content.replace(rec1, "")
else:
    rec1 = ""

# Remove audit_strategy_profile and audit_belief_system from inside audit_trail_game
record_regex2 = re.compile(r"record audit_strategy_profile =.*?firm_type \\<Rightarrow> real\"\n", re.DOTALL)
m2 = record_regex2.search(content)
if m2:
    rec2 = m2.group(0)
    content = content.replace(rec2, "")
else:
    rec2 = ""

# Insert both before cheap_talk_game locale
insert_point = "subsection \\<open>Cheap-Talk Game: Pooling Equilibrium\\<close>"
if insert_point in content:
    new_text = "\n" + rec1 + "\n" + rec2 + "\n" + insert_point
    content = content.replace(insert_point, new_text)

with open("isabelleHOL/Ontological_Arbitrage.thy", "w") as f:
    f.write(content)
