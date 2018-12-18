#!/usr/bin/python

"""
preparing the data of the whole genome for prediction
"""

def Generate(Cell_type, TF):
    with open(Cell_type + '.data2','w') as w:
        with open(Cell_type + '_dnase') as dnase, open(TF) as motif:
            while True:
                l2 = dnase.readline()
                l3 = motif.readline()
                chr = l2.split()[0]
                if chr != 'chr1':
                    break
                if not l2 and l3:
                    break               
                i = 1
                if 'NA' in l2:
                    values = [0,0,0,0,0]
                    print('here')
                else:
                    values = l2.split()
                    values = values[5:]
                for value in values:
                    w.write(str(i) + ':' + str(value) + ' ')
                    i = i + 1
                values = l3.split()
                val = values[:11]
                for value in val:
                    w.write(str(i) + ':' + str(value) + ' ')
                    i = i + 1
                w.write(str(i) + ':' + str(values[11]) + '\n')
CELL = 'OCI'
TF = 'STAT3' 
Generate(CELL,TF)


