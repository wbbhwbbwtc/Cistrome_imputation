import numpy as np
import sys
import re

the_chr=sys.argv[1]

def scan(TF):
    tf_matrix=np.loadtxt("/Volumes/Samsung_T5/prepareMotif/ru_model_reverse/" + TF,delimiter='\t',dtype='float32')
    tf_length=tf_matrix.shape[0]

    ## read in one chromosome and scan;
    FILE_name='/Volumes/Samsung_T5/hg38/'+ the_chr + '.fa'
    FILE=open(FILE_name,'r');
    a = ''
    lines = FILE.readlines()
    iterlines = iter(lines)
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

    aline=a
    aline=aline.replace("A", "1")
    aline=aline.replace("C", "0")
    aline=aline.replace("G", "0")
    aline=aline.replace("T", "0")
    aline=np.asarray(list(aline),dtype='float32')


    cline=a
    cline=cline.replace("A", "0")
    cline=cline.replace("C", "1")
    cline=cline.replace("G", "0")
    cline=cline.replace("T", "0")
    cline=np.asarray(list(cline),dtype='float32')

    gline=a
    gline=gline.replace("A", "0")
    gline=gline.replace("C", "0")
    gline=gline.replace("G", "1")
    gline=gline.replace("T", "0")
    gline=np.asarray(list(gline),dtype='float32')

    tline=a
    tline=tline.replace("A", "0")
    tline=tline.replace("C", "0")
    tline=tline.replace("G", "0")
    tline=tline.replace("T", "1")
    tline=np.asarray(list(tline),dtype='float32')

    chrom_matrix=np.vstack((aline, cline, gline, tline))
    print(chrom_matrix.shape)

    length=chrom_matrix.shape[1]
    i=0;
    max_length=length-20


    #ATF2  CTCF  E2F1  EGR1  FOXA1  FOXA2  GABPA  HNF4A  JUND  MAX  NANOG  REST  TAF1
    filename=TF + '_'+ the_chr
    with open(filename,'w') as w:


        while (i<max_length):
            sub=chrom_matrix[:,i:(i+tf_length)]
            val=np.trace(np.dot(tf_matrix,sub))
            w.write('%.5f\n' % val)
            i=i+1

TF = 'STAT3'
scan(TF)


