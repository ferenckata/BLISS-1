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
    cat $out/filtered.r1.fa | cut -d':' -f-7 | tr '>' '@' | paste - -|awk '{print $1,$NF}'|
    LC_ALL=C sort --parallel=8 --temporary-directory=$HOME/tmp -k1,1 > $aux/ID_genomic
    LC_ALL=C join $aux/ID_genomic $in/r1oneline.fq | tr " " "\n" | grep -v "1:[YN]:0:" | paste - - - - -| 
    awk '{print $1,$2,$4,substr($5,length($5)-length($2)+1,length($5))}' | tr " " "\n" > $aux/r1.2b.aln.fq
fi
echo 'Done! Ready to be aligned to the reference genome!'

