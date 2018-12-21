import json
from os.path import join, basename, dirname
# globals ----------------------------

configfile: 'config.yml'

# Full path
DNAse = config['DNAse']
GENCODE = config['GENCODE']
MOTIF1 = config['MOTIF1']
MOTIF2 = config['MOTIF2']
HG19 = config['HG19']
TEST = config['TEST']
GENV19 = config['GENV19']
Labels = config['Labels']
# Full path to a folder where intermediate output features files will be created.
OUT_DIR = config['OUT_DIR']
# Samples
FILEDNAse = json.load(open(config['FILEDNAse']))
FILEMOTIF = json.load(open(config['FILEMOTIF']))
CELLS = FILEDNAse.keys()
TFS = FILEMOTIF.keys()
# Rules ------------------------------

rule data_DNAse:
    input:
        dnase = DNAse
    output:
        [OUT_DIR + "/" + x for x in expand('anchor_bam_DNAse_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + "/" + x for x in expand('anchor_bam_DNAse_max_min_diff_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + "/" + x for x in expand('anchor_bam_DNAse_max_min_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + "/" + x for x in expand('orange_rank_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + "/" + x for x in expand('orange_rank_diff_largespace/{sample}', sample = CELLS)]
    params:
        path = dirname(DNAse)
    shell:
        """    
        cd {params.path}
        # Make bam to txt file
        perl transform_bam_to_track.pl {params.path}
        # sum raw reads from all tech/bio replicates and separate them into 23 chromsomes 
        perl create_DNAse_avg_track_by_chr.pl {params.path}
        # subsample 1/1000 and rank reads of all chrs for the multi-cell mapping/anchoring 
        perl approximate_max_min_median.pl {params.path}
        # map signals to the reference cell line (liver by default)
        perl normalize_by_anchor.pl {params.path}
        ## 2. Feature extraction ####### 
        # 3M - mean, max, min 
        perl create_DNAse.pl {params.path}
        perl create_DNAse_max_min.pl {params.path}
        # delta-3M - mean, max, min 
        perl create_DNAse_diff.pl {params.path}
        perl create_DNAse_max_min_diff.pl {params.path}
        # 3M-neighbors - mean, max, min 
        perl create_DNAse_largespace.pl {params.path}
        perl create_DNAse_max_min_largespace.pl    {params.path}
        # delta-3M-neighbor - mean, max, min 
        perl create_DNAse_diff_largespace.pl {params.path}
        perl create_DNAse_max_min_diff_largespace.pl {params.path}
        ## 3. Frequency feature ######## 
        # count the number of signal occurance; ignore values 
        perl produce_orange.pl {params.path}
        perl produce_orange_rank.pl {params.path}
        # neighbors 
        perl create_orange_largespace.pl {params.path}
        # delta-neighbors 
        perl create_orange_diff.pl {params.path}
        perl create_orange_rank_largespace.pl {params.path})
        """
rule data_motif_forward:
    input:
        ru_model = MOTIF1,
        sequences = HG19,
        test_region = TEST
    params:
        path = dirname(dirname(MOTIF1))
    output:
        [dirname(dirname(MOTIF1)) + x for x in expand('ru_code_python/tf_forward_ru_top3/{sample}', sample = TFS)],
    shell:
        """
        cd {params.path}/ru_code_python
        python scan_motif_by_chr.py chr1 {params.path}
        python scan_motif_by_chr.py chr2 {params.path}
        python scan_motif_by_chr.py chr3 {params.path}
        python scan_motif_by_chr.py chr4 {params.path}
        python scan_motif_by_chr.py chr5 {params.path}
        python scan_motif_by_chr.py chr6 {params.path}
        python scan_motif_by_chr.py chr7 {params.path}
        python scan_motif_by_chr.py chr8 {params.path}
        python scan_motif_by_chr.py chr9 {params.path}
        python scan_motif_by_chr.py chr10 {params.path}
        python scan_motif_by_chr.py chr11 {params.path}
        python scan_motif_by_chr.py chr12 {params.path}
        python scan_motif_by_chr.py chr13 {params.path}
        python scan_motif_by_chr.py chr14 {params.path}
        python scan_motif_by_chr.py chr15 {params.path}
        python scan_motif_by_chr.py chr16 {params.path}
        python scan_motif_by_chr.py chr17 {params.path}
        python scan_motif_by_chr.py chr18 {params.path}
        python scan_motif_by_chr.py chr19 {params.path}
        python scan_motif_by_chr.py chr20 {params.path}
        python scan_motif_by_chr.py chr21 {params.path}
        python scan_motif_by_chr.py chr22 {params.path}
        python scan_motif_by_chr.py chrX {params.path}
        # select top 3 scores over forward/reverse 200bp sequences; a total of 6=3x2
        perl create_motif_top3_ru_forward.pl {params.path}
        """
rule data_motif_reverse:
    input:
        ru_model_reverse = MOTIF2,
        sequences = HG19,
        test_region = TEST
    params:
        path = dirname(dirname(MOTIF2))
    output:
        [dirname(dirname(MOTIF2)) + x for x in expand('ru_code_python_reverse/tf_reverse_ru_top3/{sample}', sample = TFS)]
    shell:
        """
        cd {params.path}/ru_code_python_reverse
        # scan TF-motif PWMs against DNA sequences to obtain  score for each position
        python scan_motif_by_chr.py chr1 {params.path}
        python scan_motif_by_chr.py chr2 {params.path}
        python scan_motif_by_chr.py chr3 {params.path}
        python scan_motif_by_chr.py chr4 {params.path}
        python scan_motif_by_chr.py chr5 {params.path}
        python scan_motif_by_chr.py chr6 {params.path}
        python scan_motif_by_chr.py chr7 {params.path}
        python scan_motif_by_chr.py chr8 {params.path}
        python scan_motif_by_chr.py chr9 {params.path}
        python scan_motif_by_chr.py chr10 {params.path}
        python scan_motif_by_chr.py chr11 {params.path}
        python scan_motif_by_chr.py chr12 {params.path}
        python scan_motif_by_chr.py chr13 {params.path}
        python scan_motif_by_chr.py chr14 {params.path}
        python scan_motif_by_chr.py chr15 {params.path}
        python scan_motif_by_chr.py chr16 {params.path}
        python scan_motif_by_chr.py chr17 {params.path}
        python scan_motif_by_chr.py chr18 {params.path}
        python scan_motif_by_chr.py chr19 {params.path}
        python scan_motif_by_chr.py chr20 {params.path}
        python scan_motif_by_chr.py chr21 {params.path}
        python scan_motif_by_chr.py chr22 {params.path}
        python scan_motif_by_chr.py chrX {params.path}
        # select top 3 scores over forward/reverse 200bp sequences; a total of 6=3x2 dirname
        perl create_motif_top3_ru_reverse.pl {params.path}
        """
rule top4_scores:        
    input:
        [dirname(dirname(MOTIF2)) + x for x in expand('ru_code_python_reverse/tf_reverse_ru_top3/{sample}', sample = TFS)],
        [dirname(dirname(MOTIF1)) + x for x in expand('ru_code_python/tf_forward_ru_top3/{sample}', sample = TFS)]
    params:
        path = dirname(dirname(MOTIF1))
    output:
        [OUT_DIR + x for x in expand('tf_ru_max_top4_rank_largespace/{sample}', sample = TFS)]
    shell:
        """
        # select the top 4 out of the 6 scores 
        cd {params.path}
        perl find_max_forward_reverse_top_4.pl {params.path}
        # neighbors 
        perl create_top4_rank_ru.pl {params.path}
        perl create_largespace_tomax_top4_rank.pl {params.path}
        """

rule data_gencode:
    input:
        genev19 = GENV19,
        test_region = TEST
    params:
        path = dirname(GENV19)
    output:
        join(OUT_DIR, 'TOP20', '/top20')
    shell:
        """
        cd {params.path}
        perl create_gene_distance_top20_uniq.pl {input.genev19} {input.test_region})
        """
# Eliminate Aubiguous
rule creat_sample:
    input:
        labels = Labels
    params:
        path = OUT_DIR
    output:
        [OUT_DIR + x for x in expand('sample/{tf}.{cell}.tab',tf = TFS, cell = CELLS)]
    shell:
        """
        cd {params.path}
        perl create_sample.pl {sample}
        """
rule prepare_data:
    input:
        [OUT_DIR + "/" + x for x in expand('anchor_bam_DNAse_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + "/" + x for x in expand('anchor_bam_DNAse_max_min_diff_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + "/" + x for x in expand('anchor_bam_DNAse_max_min_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + "/" + x for x in expand('orange_rank_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + "/" + x for x in expand('orange_rank_diff_largespace/{sample}', sample = CELLS)],
        [OUT_DIR + x for x in expand('tf_ru_max_top4_rank_largespace/{sample}', sample = TFS)],
        join(OUT_DIR, 'TOP20', '/top20'),
        [OUT_DIR + x for x in expand('sample/{tf}.{cell}.tab',tf = TFS, cell = CELLS)],
        labels = Labels
    params:
        path = OUT_DIR
    output:
        [OUT_DIR + "/train/" + x for x in expand('{tf}.{cell}.set1',tf = TFS, cell = CELLS)],
        [OUT_DIR + "/train/" + x for x in expand('{tf}.{cell}.set2',tf = TFS, cell = CELLS)]
    shell:
        """
        perl prepare_data.pl {params.path}
        """
rule training_evaluation:
    input:
        [OUT_DIR + "/train/" + x for x in expand('{tf}.{cell}.set1',tf = TFS, cell = CELLS)],
        [OUT_DIR + "/train/" + x for x in expand('{tf}.{cell}.set2',tf = TFS, cell = CELLS)],
        cells = CELLS,
        tfs = TFS,
    output:
        [OUT_DIR + x for x in expand('{cell1}.{cell2}.txt',cell1 = CELLS, cell2 = CELLS)],
        [OUT_DIR + x for x in expand('{cell1}.{cell2}.featmap.txt',cell1 = CELLS, cell2 = CELLS)]
    shell:
        """
        ls
        """


