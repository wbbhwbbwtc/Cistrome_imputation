#!/usr/bin/perl
#
#
@mat=glob "/Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4_rank/*";

system "mkdir /Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4_rank_largespace";

foreach $file (@mat){
    open OLD, "$file" or die;
    @all1=();
    @all2=();
    @all3=();
    @all4=();
    while ($line=<OLD>){
        chomp $line;
        @table=split "\t", $line;
        push @all1, $table[0];
        push @all2, $table[1];
        push @all3, $table[2];
        push @all4, $table[3];
    }
    close OLD;
    @t=split '/', $file;
    $name=pop @t;

    open NEW, ">/Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4_rank_largespace/$name" or die;

    $i=0;
    foreach $aaa (@all1){
        printf NEW "%.4f", $aaa;
        $j=3;
        while ($j<5){
            $max=$all1[$i-$j];
            $max2=$all1[$i+$j];
            printf NEW "\t%.4f", $max;
            printf NEW "\t%.4f", $max2;
            $j++;
            $j++;
        }


        printf NEW "\t%.4f", $all2[$i];
        $j=3;
        while ($j<5){
            $max=$all2[$i-$j];
            $max2=$all2[$i+$j];
            printf NEW "\t%.4f", $max;
            printf NEW "\t%.4f", $max2;
            $j++;
            $j++;
        }


        printf NEW "\t%.4f", $all3[$i];
        $j=3;
        while ($j<5){
            $max=$all3[$i-$j];
            $max2=$all3[$i+$j];
            printf NEW "\t%.4f", $max;
            printf NEW "\t%.4f", $max2;
            $j++;
            $j++;
        }


        printf NEW "\t%.4f", $all4[$i];
        $j=3;
        while ($j<5){
            $max=$all4[$i-$j];
            $max2=$all4[$i+$j];
            printf NEW "\t%.4f", $max;
            printf NEW "\t%.4f", $max2;
            $j++;
            $j++;
        }

        print NEW "\n";
        $i++;
    }
    close NEW;
        
}

        
