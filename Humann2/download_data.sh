#!/bin/bash
#This script is for downloading the data file from EBI database
cp get_runid.py $SNIC_TMP
cp ERS328716-ERS329007.xml $SNIC_TMP
cd $SNIC_TMP
RUNID=$(python2 get_runid.py $1)
run_count=1
for i in $RUNID
do
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR321/ERR${i}/ERR${i}_1.fastq.gz &
  wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR321/ERR${i}/ERR${i}_2.fastq.gz &
  eval file${run_count}_1=ERR${i}_1.fastq.gz
  eval file${run_count}_2=ERR${i}_2.fastq.gz
  eval run_count=$[$run_count+1]
done

i=1
all_files_1="${file1_1} "
all_files_2="${file1_2} "
#when RUN more than 1
while [ $i -lt $run_count ]
do
  eval i=$[$i + 1]
#use variable inside variable:echo \$$
  file1=file${i}_1
  file2=file${i}_2
  eval all_files_1+="$(echo \$$file1)"
  all_files_1+=" "
  eval all_files_2+="$(echo \$$file2)"
  all_files_2+=" "
done
wait
cat $all_files_1 > ${1}_1.fastq.gz
cat $all_files_2 > ${1}_2.fastq.gz
