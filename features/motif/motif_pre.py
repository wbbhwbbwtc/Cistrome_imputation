import numpy as np
import pandas as pd
import sys
import re
import subprocess



def reverse(TF):    
    with open(TF,'r') as r:
        lines=r.readlines()
    with open(TF + 'r','w') as w:
        for l in reversed(lines):
            for i in reversed(l.split()):
                w.write(i+'\t')
            w.write('\n')

def scan(TF,path,hg38，the_chr):
    tf_matrix = np.loadtxt(path + TF, delimiter = '\t',dtype = 'float32')
    tf_matrix_reverse = np.loadtxt(path + TF + 'r', delimiter = '\t',dtype = 'float32')

    tf_length = tf_matrix.shape[0]

    ## read in one chromosome and scan;
    FILE_name = hg38 + the_chr + '.fa'
    FILE = open(FILE_name,'r');
    a = ''
    lines = FILE.readlines()
    iterlines  =  iter(lines)
    next(iterlines)
    for line in iterlines:

        line = line.rstrip()
        line = line.replace("a", "A")
        line = line.replace("c", "C")
        line = line.replace("g", "G")
        line = line.replace("t", "T")
        line = line.replace("N", "A")
        line = line.replace("n", "A")
        a = a + line
    #print(line)

    aline = a
    aline = aline.replace("A", "1")
    aline = aline.replace("C", "0")
    aline = aline.replace("G", "0")
    aline = aline.replace("T", "0")
    aline = np.asarray(list(aline),dtype = 'float32')


    cline = a
    cline = cline.replace("A", "0")
    cline = cline.replace("C", "1")
    cline = cline.replace("G", "0")
    cline = cline.replace("T", "0")
    cline = np.asarray(list(cline),dtype = 'float32')

    gline = a
    gline = gline.replace("A", "0")
    gline = gline.replace("C", "0")
    gline = gline.replace("G", "1")
    gline = gline.replace("T", "0")
    gline = np.asarray(list(gline),dtype = 'float32')

    tline = a
    tline = tline.replace("A", "0")
    tline = tline.replace("C", "0")
    tline = tline.replace("G", "0")
    tline = tline.replace("T", "1")
    tline = np.asarray(list(tline),dtype = 'float32')

    chrom_matrix = np.vstack((aline, cline, gline, tline))
    length = chrom_matrix.shape[1]
    i = 0;
    max_length = length-20

    filename = TF + '_' + the_chr

    filename_reverse = TF + '_reverse' + the_chr
    with open(filename,'w') as w:
        while (i<max_length):
            sub = chrom_matrix[:,i:(i + tf_length)]
            val = np.trace(np.dot(tf_matrix,sub))
            w.write('%.5f\n' % val)
            i = i + 1
    
    with open(filename_reverse,'w') as w:
        while (i<max_length):
            sub = chrom_matrix[:,i:(i+tf_length)]
            val = np.trace(np.dot(tf_matrix_reverse,sub))
            w.write('%.5f\n' % val)
            i = i+1


subprocess.call(["perl", "/path/to/your-script.pl"])
if __name__ == "__main__":

    TF = sys.argv[1]
    path = sys.argv[2]
    hg38 = sys.argv[3]
    chromosome = ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10','chr11','chr12','chr13','chr14',
    'chr15','chr16','chr17','chr18','chr19','chr20','chr21','chr22','chrX']
    for i in chromosome:
        scan()

    subprocess.call(["perl", "/path/to/your-script.pl"])




