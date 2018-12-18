#!/bin/bash
cd ru_code_python

# scan TF-motif PWMs against DNA sequences to obtain score for each position
python scan_motif_by_chr.py chr1
python scan_motif_by_chr.py chr2
python scan_motif_by_chr.py chr3
python scan_motif_by_chr.py chr4
python scan_motif_by_chr.py chr5
python scan_motif_by_chr.py chr6
python scan_motif_by_chr.py chr7
python scan_motif_by_chr.py chr8
python scan_motif_by_chr.py chr9
python scan_motif_by_chr.py chr10
python scan_motif_by_chr.py chr11
python scan_motif_by_chr.py chr12
python scan_motif_by_chr.py chr13
python scan_motif_by_chr.py chr14
python scan_motif_by_chr.py chr15
python scan_motif_by_chr.py chr16
python scan_motif_by_chr.py chr17
python scan_motif_by_chr.py chr18
python scan_motif_by_chr.py chr19
python scan_motif_by_chr.py chr20
python scan_motif_by_chr.py chr21
python scan_motif_by_chr.py chr22
python scan_motif_by_chr.py chrX

# select top 3 scores over forward/reverse 200bp sequences; a total of 6=3x2
perl create_motif_top3_ru_forward.pl
mv tf_forward_ru_top3 /Volumes/Samsung_T5/prepareMotif/tf_forward_ru_top3
cd ..
cd ru_code_python_reverse
python scan_motif_by_chr.py chr1
python scan_motif_by_chr.py chr2
python scan_motif_by_chr.py chr3
python scan_motif_by_chr.py chr4
python scan_motif_by_chr.py chr5
python scan_motif_by_chr.py chr6
python scan_motif_by_chr.py chr7
python scan_motif_by_chr.py chr8
python scan_motif_by_chr.py chr9
python scan_motif_by_chr.py chr10
python scan_motif_by_chr.py chr11
python scan_motif_by_chr.py chr12
python scan_motif_by_chr.py chr13
python scan_motif_by_chr.py chr14
python scan_motif_by_chr.py chr15
python scan_motif_by_chr.py chr16
python scan_motif_by_chr.py chr17
python scan_motif_by_chr.py chr18
python scan_motif_by_chr.py chr19
python scan_motif_by_chr.py chr20
python scan_motif_by_chr.py chr21
python scan_motif_by_chr.py chr22
python scan_motif_by_chr.py chrX
perl create_motif_top3_ru_reverse.pl
mv tf_reverse_ru_top3 /Volumes/Samsung_T5/prepareMotif/tf_reverse_ru_top3
cd ..

# select the top 4 out of the 6 scores
perl find_max_forward_reverse_top_4.pl

# neighbors
perl create_top4_rank_ru.pl
perl create_largespace_tomax_top4_rank.pl



