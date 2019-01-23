import os
configfile: "config.json"



rule all:
    input:
        'res_TFBS'

# Features preparation 

rule dnase:
    input:        
        os.path.join(config['DNaseDIR'],'{dnase}.bw')
    output:
        os.path.join(config['OutDIR'],'{dnase}')
    params:
        bwtool = config["tools"]["bwtool"]
        test_regions = config['test_regions']
    shell:
        '{params.bwtool} summary {params.test_regions} {input} {output} -with-sum'

rule dnase_pre:
    input:        
        os.path.join(config['DNaseDIR'],'{dnase_pre}.bw') # dnase_pre is the cell type or cell line under prediction
    output:
        os.path.join(config['OutDIR'],'{dnase_pre}')
    params:
        bwtool = config["tools"]["bwtool"]
        test_regions = config['test_regions']
    shell:
        '{params.bwtool} summary {params.test_regions} {input} {output} -with-sum'

rule motif:
    input:
        os.path.join(config['motifDIR'],'{TF}')
    output:
        os.path.join(config['OutDIR'],'{TF}')
    params:
        test_regions = config['test_regions']
        hg38 = config['hg38']
    shell:
        'python3 motif_pre.py {TF} {input} {params.hg38} {params.test_regions} -n {output}'

rule orange:
    pass

# Train & Test

rule Chip:  # subsampling the negative regions 
    input:
        os.path.join(config['ChipDIR'],'{TF}_peaksamples')
    output:
        os.path.join(config['OutDIR'],'{TF}_raw_samples')
    shell:
        'python3 get_labels.py {TF} -n {output}'


rule train_data: # If there are more than one samples(DNase), the sample from different cell lines/cell types are merged together to avoid overfitting
    input:
        os.path.join(config['OutDIR'],'{TF}_raw_samples')
        os.path.join(config['motifDIR'],'{TF}')
        os.path.join(config['DNaseDIR'],'{dnase}.bw')
    output:
        os.path.join(config['OutDIR'],'{TF}_samples')   
    shell:
        'perl training_data.pl {TF} {dnase}'

rule oversample: # over-sample nagetive regions with large DNase-seq median value
    input:
        os.path.join(config['OutDIR'],'{TF}_samples')
    output:
        os.path.join(config['OutDIR'],'samples')
    shell:
        'python3 oversampling.py {TF}_samples -n {output}'

rule train_test: #divided randomly in case of overfitting
    input:
        os.path.join(config['OutDIR'],'samples')
    output:
        os.path.join(config['OutDIR'],'test_data')
        os.path.join(config['OutDIR'],'train_data')
    shell:
        'python3 divide.py'
# Prediction  

rule preparation:
    input:
        os.path.join(config['OutDIR'],'{TF}')
        os.path.join(config['DNaseDIR'],'{dnase_pre}') 
    output:    
        os.path.join(config['OutDIR'],'pre_data')
    shell:
        'python3 preparation.py {TF} {dnase_pre} -n {output}'

rule pridcition:
    input:
        os.path.join(config['OutDIR'],'train_data')
        os.path.join(config['OutDIR'],'test_data')
        os.path.join(config['OutDIR'],'pre_data')
    output:
        os.path.join(config['OutDIR'],'res_TFBS')
    params:
        peaks_number = config['peaks_number']
    shell:
        'python3 predict.py {params.peaks_number}'

