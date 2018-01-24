#!/usr/bin/env bash

r1=$1
in=$2
numb_of_files=$3
r2=$4

echo "Decompress fastq.gz ..."
gunzip -c $r1 > $in/r1.fq & pid1=$!
if [ $numb_of_files == 2 ]; then
    gunzip -c $r2 > $in/r2.fq & pid2=$!
fi
wait $pid1
wait $pid2

cat $in/r1.fq | paste - - - - | cut -f 1,2 | sed 's/^@/>/' | tr "\t" "\n" > $in/r1.fa

echo 'Done'
