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

def scan(TF,path,hg38,the_chr):
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
def create_top3_forward(bed,TF):
    file = bed

    old_tf = ""
    old_chr = ""
    NEW = "reverse_" + TF
    f = open(NEW,'w')
    fin = open(file,'r')
    lines = fin.readlines()
    for line in lines:
        line = line.strip('\n')
        table = line.split('\t')
        chr = table[0]
        start = table[1]
        end = table[2]
        if TF == old_tf and chr == old_chr:
            pass
        else:
            feature = ""
            print TF
            fileG = path + TF + '_' + chr
            G = open(fileG,'r')
            i = 0
            infos = G.readlines()
            for info in infos:
                info = info.strip('\n')
                feature[i] = info
                i = i + 1
            G.close()
            old_chr = chr
            old_tf = tf
        hat = [];
        i = int(start) - 5;
        while int(i)<int(end):
            hat.append(feature[i])
            i = i + 1
        hat.sort(reverse=True)
        f.close()
        fin.close()


def create_top3_reverse(bed,TF):

    file = bed

    old_tf = ""
    old_chr = ""
    NEW = "reverse_" + TF
    f = open(NEW,'w')
    fin = open(file,'r')
    lines = fin.readlines()
    for line in lines:
        line = line.strip('\n')
        table = line.split('\t')
        chr = table[0]
        start = table[1]
        end = table[2]
        if TF == old_tf and chr == old_chr:
            pass
        else:
            feature = ""
            print TF
            fileG = path + TF + '_' + chr
            G = open(fileG,'r')
            i = 0
            infos = G.readlines()
            for info in infos:
                info = info.strip('\n')
                feature[i] = info
                i = i + 1
            G.close()
            old_chr = chr
            old_tf = tf
        hat = [];
        i = int(start) - 5;
        while int(i)<int(end):
            hat.append(feature[i])
            i = i + 1
        hat.sort(reverse=True)
        f.close()
        fin.close()
        
        
def reverse_complement(seq):
    dna = seq
    revcomp = dna[::-1]
    fina = ""
    for j in revcomp:
        if j == 'A':
            fina = fina + 'T'
        elif j == 'C':
            fina = fina + 'G'
        elif j == 'G':
            fina = fina + 'C'
        elif j == 'T':
            fina = fina + 'A'
        elif j == 'c':
            fina = fina + 'g'
        elif j == 'a':
            fina = fina + 't'
        elif j == 'g':
            fina = fina + 'c'
        elif j == 't':
            fina = fina + 'a'
    return fina
            
            

def create_top4(TF):
    for root, dirs, files in os.walk("/Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4/"):
        for file in files:
            count_val={}
            total = 0
            OLDfile = root+'/'+file
            OLD = open(OLDfile,'r')
            lines = OLD.readlines()
            for line in lines:
                line= line.strip('\n')
                table = line.split('\t')
                for aaa in table:
                    if aaa in count_val:
                        count_val[aaa] = count_val[aaa] + 1
                        total = total + 1
                    else:
                        count_val[aaa] = 1
                        total = total + 1
            OLD.close()
            all_vals = count_val.keys()
            all_vals.sort()
            ref_num = 0
            map = {}
            old = 0
            for vvv in all_vals:
                ref_num = ref_num + old
                ref_num = ref_num + (count_val[vvv]/2)
                old = count_val[vvv]/2
                map[vvv] = ref_num/total
            OLD = open(OLDfile,'r')
            new = OLDfile
            name = file
            NEWfile = "/Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4_rank/" + name
            NEW = open(NEWfile,'w')
            lines = OLD.readlines()
            for line in lines:
                line = line.strip('\n')
                table = line.split('\t')
                aaa = table.pop([index=0])
                map[aaa] = '%.5f' % map[aaa]
                NEW.write('\t'+map[aaa])
                for aaa in table:
                    map[aaa] = '%.5f' % map[aaa]
                    NEW.write('\t'+map[aaa])
                NEW.write('\n')
            OLD.close()
            NEW.close()


if __name__ == "__main__":
    TF = sys.argv[1]
    path = sys.argv[2]
    hg38 = sys.argv[3]
    bed = sys.argv[4]
    reverse(TF)
    chromosome = ['chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10','chr11','chr12','chr13','chr14',
    'chr15','chr16','chr17','chr18','chr19','chr20','chr21','chr22','chrX']
    for i in chromosome:
        scan(TF,path,hg38,i)
    create_top3_forward(bed,TF)
    create_top3_forward(bed,TF)
    create_top4(TF)





