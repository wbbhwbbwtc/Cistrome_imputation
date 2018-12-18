#!/usr/bin/perl

# sepreating each chr, and therefore, this script can be used to test on a single chr when training on other chrs

$path1="/Volumes/Samsung_T5/Training/TF_exp/data/train_test/";
$path2="/Volumes/Samsung_T5/Training/TF_exp/data/sample/01/"; 

$tf_list="/Volumes/Samsung_T5/Training/TF_exp/data/index/tf_list.txt"; 

@tf_feature=glob ("/Volumes/Samsung_T5/Training/TF_exp/data/feature/tf_ru_max_top4_rank_largespace/"); 
$rna_feature='/Volumes/Samsung_T5/Training/TF_exp/data/feature/top20'; 

%chr_set1=(); 
open INDEX_SET1, "/Volumes/Samsung_T5/Training/TF_exp/data/index/ind_chr_set1.txt" or die;
while($line=<INDEX_SET1>){
    chomp $line;
    $chr_set1{$line}=0;
}
close INDEX_SET1;

$tf = "STAT3";

system "mkdir ${path1}";
system "mkdir ${path1}${tf}";

@list =("HeLa-S3");
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

    open INDEX, "$rna_feature" or die;
    $num=0;
    foreach $file (@tf_feature){
        $name="INPUT".$num;
        open $name, "${file}${tf}" or die;
        $num++;
    }
    open OD, "$dnase_feature$cell" or die;
    open OUTPUT1, ">${path1}${tf}/${tf}.${cell}" or die;
    open OUTPUT2, ">${path1}${tf}/${tf}.${cell}.set2" or die;
    while($line=<INDEX>){
        chomp $line;
        @rna=split "\t", $line;
        $chr=shift @rna;
        $start=shift @rna;
        shift @rna;
        if(defined $target{$chr}{$start}){ 
            if(exists $chr_set1{$chr}){ 
                $file="OUTPUT1";
            }else{
                $file="OUTPUT2"
            }
            print $file "$target{$chr}{$start}"; 
            $j=1;
            foreach $x (@rna){ 
                print $file " $j:$x";
                $j++;
            }
            $line = <OD>;
            chomp $line;
            @ccc = split(/\s+/,$line);
            shift @ccc;
            shift @ccc;
            shift @ccc;
            shift @ccc;
            shift @ccc;
            foreach $x (@ccc){ 
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
            <OD>;
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
    close OD;
    $i=0;
    while($i<$num){
        $name="INPUT".$i;
        close $name;
        $i++;
    }
}



