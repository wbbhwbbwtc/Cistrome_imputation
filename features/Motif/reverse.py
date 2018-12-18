"""
get reversed PWMs
"""

with open('STAT3','r') as r:
    lines=r.readlines()
with open('STAT3r','w') as w:
    for l in reversed(lines):
        for i in reversed(l.split()):
            w.write(i+'\t')
        w.write('\n')