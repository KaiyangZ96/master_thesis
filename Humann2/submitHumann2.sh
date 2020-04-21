#!/bin/bash -l
#SBATCH -A snic2019-3-599   
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 20:00:00
#SBATCH -J kaiyang_062
#SBATCH --mail-user zhangkaiyang96@outlook.com
#SBATCH --mail-type=ALL
FILEINDEX=MetaHIT-MH0100 #data file id
rm -r /proj/sllstore2017024/nobackup/kaiyang/PRJEB4336/humann2/result/${FILEINDEX} #"/proj/sllstore2017024/nobackup/kaiyang/PRJEB4336/humann2"is the path of my project on Uppmax
module load bioinfo-tools
module load bowtie2
module load BEDTools
module load samtools
module load trimmomatic
module load biopython
module load metaphlan2/2.0
module load humann2
bash download_data.sh ${FILEINDEX}
mkdir -p /proj/sllstore2017024/nobackup/kaiyang/PRJEB4336/humann2/result/${FILEINDEX}/abundance
mkdir -p /proj/sllstore2017024/nobackup/kaiyang/PRJEB4336/humann2/result/${FILEINDEX}/filteredPair
bash /proj/sllstore2017024/nobackup/kaiyang/PRJEB4336/humann2/humann2pipeline.sh ${FILEINDEX}_1.fastq.gz ${FILEINDEX}_2.fastq.gz /proj/sllstore2017024/nobackup/kaiyang/PRJEB4336/humann2/result/${FILEINDEX}/abundance 10 /proj/sllstore2017024/nobackup/kaiyang/PRJEB4336/humann2/result/${FILEINDEX}/filteredPair ${FILEINDEX} >/proj/sllstore2017024/nobackup/kaiyang/PRJEB4336/humann2/error/log_error${FILEINDEX}.txt 2>&1
