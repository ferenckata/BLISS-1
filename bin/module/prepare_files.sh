#!/usr/bin/env bash

r1=$1
in=$2
numb_of_files=$3
r2=$4

echo "Decompress fastq.gz ..."
gunzip -c $r1 > $in/r1-unzip
cat $in/r1-unzip | paste - - - - | cut -f 1,2 | sed 's/^@/>/' | tr "\t" "\n" > $in/r1.fa & pid1=$!
cat $in/r1-unzip | paste - - - - > $in/r1oneline.fq & pid2=$!
if [ $numb_of_files == 2 ]; then
    gunzip -c $r2 | paste - - - - > $in/r2oneline.fq & pid3=$!
fi
wait $pid1
if [ $numb_of_files == 2 ]; then
    wait $pid3
fi
echo 'Done'
