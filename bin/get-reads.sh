#!/bin/bash
set -ex

IN=$1
OUT=$2
NCORE=`grep -c '^processor' /proc/cpuinfo`
BIN="`dirname \"$0\"`"

sambamba sort -p -n -m 60GB -t $NCORE -o ${OUT}.sorted.bam -F "unmapped or mate_is_unmapped or (ref_name == 'chr6' and (position > 29844528 and position < 33100696))" $IN
bamToFastq -i ${OUT}.sorted.bam -fq ${OUT}.1.fq -fq2 ${OUT}.2.fq
bwa mem -t $NCORE $BIN/../data/chr6/hg38.chr6.fna ${OUT}.1.fq ${OUT}.2.fq | samtools view -b - | sambamba sort -m 60GB -t $NCORE -o $OUT /dev/stdin
sambamba index $OUT
