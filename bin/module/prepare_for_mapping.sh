#!/usr/bin/env bash
numb_of_files=$1
out=$2
aux=$3
outcontrol=$4
auxcontrol=$5
in=$6
cutsite=$7

echo 'Parse the fastq files, filtering and trimming ...'
if [[ -z "$cutsite" && $numb_of_files == 1 ]]; then # IF THERE IS NO ENZYME && WITH SE READS
    cat $in/r1oneline.fq | tr " " "\n" | tr "\t" "\n" | grep -v "1:[YN]:0:" | paste - - - - | 
    awk '{print $1,substr($2,9,length($2)),$3,substr($4,9,length($4))}' | tr " " "\n" > $aux/r1.2b.aln.fq
fi
echo 'Done! Ready to be aligned to the reference genome!'

