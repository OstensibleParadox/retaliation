import sys

with open("isabelleHOL/Ontological_Arbitrage.thy", "r") as f:
    lines = f.readlines()

# Extract lines 167-174 (indices 166-174)
rec1 = lines[166:174]
# Extract lines 399-406 (indices 398-406)
rec2 = lines[398:406]

# Remove them from the list, working backwards to keep indices valid
del lines[398:406]
del lines[166:174]

# Find the insertion point (before subsection \<open>Cheap-Talk Game: Pooling Equilibrium\<close>)
# It is around line 75 in the original file
insert_idx = 0
for i, line in enumerate(lines):
    if "subsection \<open>Cheap-Talk Game: Pooling Equilibrium\<close>" in line:
        insert_idx = i
        break

# Insert the records
lines = lines[:insert_idx] + rec1 + ["\n"] + rec2 + ["\n"] + lines[insert_idx:]

with open("isabelleHOL/Ontological_Arbitrage.thy", "w") as f:
    f.writelines(lines)
