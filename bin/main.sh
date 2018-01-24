#!/usr/bin/env bash

# THIS SCRIPT CAN BE CALLED AS
# ./bliss.sh rm35 hg19 patfile quality
################################################################################
# clear
# DEFINING VARIABLES
experiment=$1			# e.i. rm31,32,34,35,50,51,53 corresponding to *$experiment*R{1,2}.fastq.gz
patfile=$2			# is the pattern file
fastqDir=$3			# full path to directory with fastq file
numbproc=32
################################################################################
# PREPARE DIRECTORY STRUCTURE
datadir=$HOME/Work/dataset/bliss && mkdir -p $datadir/$experiment
bin=$HOME/Dropbox/pipelines/BLISS/bin
python=$HOME/Dropbox/pipelines/BLISS/python
in=$datadir/$experiment/indata && mkdir -p $in
out=$datadir/$experiment/outdata && mkdir -p $out
aux=$datadir/$experiment/auxdata && mkdir -p $aux
################################################################################
# LOAD DATA FILES

find $fastqDir -maxdepth 1 -type f -iname "*$experiment*.fastq.gz" | sort > filelist_"$experiment"

numb_of_files=`cat filelist_"$experiment" | wc -l`
r1=`cat filelist_"$experiment" | head -n1`
echo "R1 is " $r1
if [ $numb_of_files == 2 ]; then
    r2=`cat filelist_"$experiment" | tail -n1`
    echo "R2 is " $r2
fi
rm filelist_"$experiment"
################################################################################
"$bin"/module/prepare_files.sh  $r1 $in $numb_of_files $r2
"$bin"/module/pattern_filtering.sh $in $out $patfile

# "$bin"/module/prepare_for_mapping.sh $numb_of_files $out $aux $outcontrol $auxcontrol $in $cutsite
# "$bin"/module/mapping.sh $numb_of_files $numbproc $refgen $aux $out $experiment 
# "$bin"/module/mapping_quality.sh $numb_of_files $out $experiment $outcontrol $quality $cutsite
# "$bin"/module/umi_joining.sh $numb_of_files $out $experiment $aux $outcontrol $auxcontrol $quality $cutsite
# cat "$datadir"/"$experiment"/outdata/_q"$quality".bed | cut -f-5 |LC_ALL=C uniq -c | awk '{print $2,$3,$4,$5,$6,$1}' | tr " " "," > "$datadir"/"$experiment"/auxdata/aux
# #####UMI filtering
# cp "$datadir"/"$experiment"/auxdata/aux "$datadir"/"$experiment"/outdata/pre_umi_filtering.csv

# "$bin"/module/umi_filter_1.sh "$datadir"/"$experiment"/outdata/pre_umi_filtering.csv "$datadir"/"$experiment"/outdata/q"$quality"_aux

# "$bin"/module/umi_filter_2.sh "$datadir"/"$experiment"/outdata/q"$quality"_aux "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-strand-umi-pcr

# if [ $genome == "hg19" ]; then
#     sed -i.bak 's/chr23/chrX/' "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-strand-umi-pcr
#     sed -i.bak 's/chr24/chrY/' "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-strand-umi-pcr
# fi

# "$bin"/module/umi_filter_3.sh "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-strand-umi-pcr  "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-countDifferentUMI.bed
# sed -i.bak 's/chr23/chrX/' "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-countDifferentUMI.bed
# sed -i.bak 's/chr24/chrY/' "$datadir"/"$experiment"/outdata/q"$quality"_chr-loc-countDifferentUMI.bed

