#!/usr/bin/python

"""
getting the training data from chip-seq data 
min overlapping ratio = 50%
"""
import sys
import argparse
import os
import random
def get_labels(filename):
    startlist = []

    endlist = []
    endlist.append(600)
    with open(filename, 'r') as r:
        lines=r.readlines()
    name = filename.rstrip('.bed')
    f = open(name + 'samples', 'w')
    a = 0
    for l in lines:
        peaks = l.split()
        chr = peaks[0]
        # add positive samples
        if (int(peaks[1]) % 100 // 10) < 5:
            start = (int(peaks[1]) // 100) * 100 - 50
            startlist.append(start)
            endlist.append(int(peaks[2]))
            for i in range(start, int(peaks[2]) - 100, 50):
                end = i + 200
                f.write(chr + '\t' + str(i) + '\t' + str(end) + '\t1\n')
        else:
            start = (int(peaks[1]) // 100) * 100
            startlist.append(start)
            endlist.append(int(peaks[2]))
            for i in range(start, int(peaks[2]) - 100, 50):
                end = i + 200
                f.write(chr + '\t' + str(i) + '\t' + str(end) + '\t1\n')
        negativelist = []
        # add negative samples
        if endlist[a] < startlist[a]:
            rounds = (startlist[a] - endlist[a]) // 50 - 5
            if rounds > 30:
                for n in range(12):
                    n_start = random.randrange((endlist[a] // 100) *100 + 300, startlist[a] - 250 ,50)
                    if n_start in startlist or n_start in negativelist:
                        pass
                    else:
                        n_end = n_start + 200
                        negativelist.append(n_start)
                        f.write(chr + '\t' + str(n_start) + '\t' + str(n_end) + '\t0\n')
            else:
                pass
        else:
            pass

        a = a + 1
    f.close()

 
def file_name(file_dir): 
    L=[] 
    for root, dirs, files in os.walk(file_dir):
        for file in files:
            if os.path.splitext(file)[1] == '.bed':
                L.append(os.path.join(root, file))
    return L

if __name__ == "__main__":
    filename = sys.argv[1]
    get_labels(filename)
