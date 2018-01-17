#!/usr/bin/env bash

# THIS SCRIPT CAN BE CALLED AS
# ./bliss.sh rm35 hg19 patfile quality
################################################################################
# clear
# DEFINING VARIABLES
experiment=$1			# e.i. rm31,32,34,35,50,51,53 corresponding to *$experiment*R{1,2}.fastq.gz
genome=$2			# e.i. mm9 or hg19
patfile=$3			# is the pattern file
quality=$4			# mapping quality
fastqDir=$5			# full path to directory with fastq file
cutsite=$6			
numbproc=32
################################################################################
# PREPARE DIRECTORY STRUCTURE
datadir=$HOME/Work/dataset/bliss && mkdir -p $datadir/$experiment
bin=$HOME/Dropbox/pipelines/BLISS/bin
python=$HOME/Dropbox/pipelines/BLISS/python
in=$datadir/$experiment/indata && mkdir -p $in
out=$datadir/$experiment/outdata && mkdir -p $out
outcontrol=$datadir/$experiment/outdata.control && mkdir -p $outcontrol
aux=$datadir/$experiment/auxdata && mkdir -p $aux
auxcontrol=$datadir/$experiment/auxdata.control && mkdir -p $auxcontrol
refgen=$HOME/igv/genomes/$genome.fasta
################################################################################
# LOAD DATA FILES

# find $fastqDir -maxdepth 1 -type f -iname "*$experiment*.fastq.gz" | sort > filelist_"$experiment"

# numb_of_files=`cat filelist_"$experiment" | wc -l`
# r1=`cat filelist_"$experiment" | head -n1`
# echo "R1 is " $r1
# if [ $numb_of_files == 2 ]; then
#     r2=`cat filelist_"$experiment" | tail -n1`
#     echo "R2 is " $r2
# fi
# rm filelist_"$experiment"
################################################################################
# "$bin"/module/quality_control.sh $numb_of_files $numbproc $out $r1 $r2 
numb_of_files=1
# r1=/home/garner1/Work/dataset/bliss/test/test.fastq.gz
# umi_tools extract --stdin="$r1" --bc-pattern=NNNNNNNNXXXXXXXX --log=processed.log --stdout "$in"/processed.fastq.gz # Ns represent the random part of the barcode and Xs the fixed part
# r1="$in"/processed.fastq.gz
# "$bin"/module/prepare_files.sh  $r1 $in $numb_of_files $r2
################################################################################
# "$bin"/module/pattern_filtering.sh $in $outcontrol $out $patfile $cutsite
# "$bin"/module/prepare_for_mapping.sh $numb_of_files $out $aux $outcontrol $auxcontrol $in $cutsite
# "$bin"/module/mapping.sh $numb_of_files $numbproc $refgen $aux $out $experiment 
# "$bin"/module/mapping_quality.sh $numb_of_files $out $experiment $outcontrol $quality $cutsite
#####UMI filtering
# umi_tools dedup -I "$out"/*.q*.sorted.bam --output-stats="$out"/deduplicated -S "$out"/deduplicated.bam -L "$out"/group.log --edit-distance-threshold 2 --method "adjacency"
"$bin"/module/umi_joining.sh $numb_of_files $out $experiment $aux $outcontrol $auxcontrol $quality $cutsite
#!!!!YOU NEED TO CONVERT THE BAM FILE INTO A BED FILE, DO IT REMEMBERING THAT READS ON - STRANDS NEEDS TO BE PROPERLY TRANSLATED!!!!

# echo "Alignment statistics:" >> "$datadir"/"$experiment"/outdata/summary.txt
# samtools flagstat "$datadir"/"$experiment"/outdata/*.sam >> "$datadir"/"$experiment"/outdata/summary.txt
# echo "Number of left and right cuts:" >> "$datadir"/"$experiment"/outdata/summary.txt
# cat "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-strand-umi-pcr | grep -v "_" | cut -f4 | sort | uniq -c >> "$datadir"/"$experiment"/outdata/summary.txt
# echo "Number of DSB locations:" >> "$datadir"/"$experiment"/outdata/summary.txt
# cat "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-countDifferentUMI.bed | grep -v "_" | wc -l >> "$datadir"/"$experiment"/outdata/summary.txt
# echo "Number of UMIs:" >> "$datadir"/"$experiment"/outdata/summary.txt
# cat "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-strand-umi-pcr | grep -v "_" | wc -l >> "$datadir"/"$experiment"/outdata/summary.txt

# name=`echo $patfile|rev|cut -d'/' -f1|rev`
# mv "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-strand-umi-pcr "$datadir"/"$experiment"/outdata/"$name"__q"$quality"_chr-loc-strand-umi-pcr.tsv
# mv "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-countDifferentUMI.bed "$datadir"/"$experiment"/outdata/"$name"_chr-loc-countDifferentUMI.bed
# mv "$datadir"/"$experiment"/outdata/summary.txt "$datadir"/"$experiment"/outdata/"$name"__summary.txt

