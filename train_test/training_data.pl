#!/usr/bin/perl

# preparing training data

$path1="/Volumes/Samsung_T5/Training/TF_exp/data/train_test/"; 
$path2="/Volumes/Samsung_T5/Training/TF_exp/data/sample/01/"; 

$tf_list="/Volumes/Samsung_T5/Training/TF_exp/data/index/tf_list.txt"; 

@tf_feature=glob ("/Volumes/Samsung_T5/Training/TF_exp/data/feature/tf_ru_max_top4_rank_largespace/"); 
$dnase_feature = "/Volumes/Samsung_T5/Training/TF_exp/data/feature/bigwig/";

$tf = "STAT3";

system "mkdir ${path1}";
system "mkdir ${path1}${tf}";

@list =("HeLa-S3","MCF-10A","MD","OCI");
foreach $cell (@list){
    open SAMPLE, "${path2}${tf}/${cell}" or die; 
    %target=();
    while($line=<SAMPLE>){
        chomp $line;
        @tmp=split "\t", $line;
        $chr=shift @tmp;
        $start=shift @tmp;
        shift @tmp;
        $y=shift @tmp;
        $target{$chr}{$start}=$y;
    }
    close SAMPLE;

    open INDEX, "$dnase_feature$cell" or die;
    $num=0; 
    foreach $file (@tf_feature){
        $name="INPUT".$num;
        open $name, "${file}${tf}" or die; 
        $num++;
    }
    open OUTPUT1, ">${path1}${tf}/${tf}.${cell}" or die;
    
    while($line=<INDEX>){
        chomp $line;
        @rna=split "\t", $line;
        $chr=shift @rna;
        $start=shift @rna;
        shift @rna;
        shift @rna;
        shift @rna;
        if(defined $target{$chr}{$start}){ 
            $file="OUTPUT1";
            print $file "$target{$chr}{$start}"; 
            $j=1;
            foreach $x (@rna){ 
                print $file " $j:$x";
                $j++;
            }
            $i=0;
            while($i<$num){ 
                $name="INPUT".$i;
                $line=<$name>;
                chomp $line;
                @tmp=split "\t",$line;
                foreach $x (@tmp){
                    print $file " $j:$x";
                    $j++;
                }
                $i++;
            }
            print $file "\n";
        }else{
            $i=0;
            while($i<$num){
                $name="INPUT".$i;
                <$name>;
                $i++;
            }
        }
    }
    close OUTPUT1;
    close OUTPUT2;
    close INDEX;
    $i=0;
    while($i<$num){
        $name="INPUT".$i;
        close $name;
        $i++;
    }
}



