#!/usr/bin/perl
#

system "rm -rf /Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4_rank";
system "mkdir /Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4_rank";

@mat=glob "/Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4/*";


foreach $file (@mat){
	%count_val=0;
	$total=0;
	open OLD, "$file" or die;
	while ($line=<OLD>){
		chomp $line;
		@table=split "\t", $line;
		foreach $aaa (@table){
			$count_val{$aaa}++;
			$total++;
		}
	}
	close OLD;
	
	@all_vals=keys %count_val;
	@all_vals=sort{$a<=>$b}@all_vals;
	$ref_num=0;

	%map=();
	$old=0;
	foreach $vvv (@all_vals){
		$ref_num+=$old;
		$ref_num+=($count_val{$vvv}/2);
		$old=($count_val{$vvv}/2);
		$map{$vvv}=$ref_num/$total;
	}
	open OLD, "$file" or die;
	$new=$file;
	@t=split '/', $file;
	$name=pop @t;
	open NEW, ">/Volumes/Samsung_T5/prepareMotif/tf_ru_max_top4_rank/$name";
	while ($line=<OLD>){
		chomp $line;
		@table=split "\t", $line;
		$aaa=shift @table;
		printf NEW "%.5f", $map{$aaa};
		foreach $aaa (@table){
			printf NEW "\t%.5f", $map{$aaa};
		}
		print NEW "\n";
	}
	close OLD;
	close NEW;
}

	
	
		
	

