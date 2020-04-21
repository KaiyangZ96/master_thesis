#!/bin/bash
#sh Step1_new.sh pair1A pair2A output cores outDirForFiltered sample_id

indFile='/proj/sllstore2017024/nobackup/kaiyang/Bowtie2index/hg19'
cd $SNIC_TMP
pair1File="$(basename $1)"
pair2File="$(basename $2)"
gunzip $pair1File
gunzip $pair2File
pair1File=${pair1File%.gz*}
pair2File=${pair2File%.gz*}

filteredPair1="filtered_$pair1File"
filteredPair2="filtered_$pair2File"
res=$3
numThread=$4
tmp=$SNIC_TMP

samFile="$tmp/$(basename $pair1File .fastq).sam"
bamFile="$tmp/$(basename $pair1File .fastq).bam"
bowtie2  -x $indFile -1 $pair1File -2 $pair2File -p $numThread -S $samFile
samtools view -bS $samFile | samtools view -b -f 12 -F 256 -@ $numThread - > $bamFile
samtools sort -n $bamFile -@ $numThread | bedtools bamtofastq -i - -fq $filteredPair1 -fq2 $filteredPair2
trimmomatic PE -threads $numThread -trimlog log.log -validatePairs $filteredPair1 $filteredPair2 -baseout $(basename $pair1File) MINLEN:35
file1="$tmp/$(basename $pair1File .fastq)_1P.fastq"
file2="$tmp/$(basename $pair1File .fastq)_2P.fastq"
bt="$res/$(basename $pair1File .fastq).bowtie2.gz"
finres="$res/$(basename $pair1File .fastq)_abundance.txt"
metaphlan2.py --mpa_pkl /proj/sllstore2017024/nobackup/kaiyang/Bowtie2index/mpa_v20_m200/mpa_v20_m200.pkl --bowtie2db /proj/sllstore2017024/nobackup/kaiyang/Bowtie2index/mpa_v20_m200  $file1,$file2 --bowtie2out $bt --nproc $numThread --input_type fastq --read_min_len 35 --sample_id $6  > $finres
mv $filteredPair1 $5
mv $filteredPair2 $5
