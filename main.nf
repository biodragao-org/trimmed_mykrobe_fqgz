#!/usr/bin/env nextflow



/*
#==============================================
# read genomes
#==============================================
*/

Channel.fromFilePairs("./*_{R1,R2}.p.fastq.gz")
        .into { ch_in_mykrobe }



/*
#==============================================
# mykrobe
#==============================================
*/


process mykrobe {
   container 'quay.io/biocontainers/mykrobe:0.8.1--py37ha80c686_0'
   publishDir 'results/mykrobe'

   input:
   set genomeFileName, file(genomeReads) from ch_in_mykrobe

   output:
   path """${genomeName}_mykrobe.csv""" into ch_out_mykrobe

   script:
   genomeName = genomeFileName.split("\\_")[0]

   """
   mykrobe predict ${genomeName} tb --output ${genomeName}_mykrobe.csv --seq ${genomeReads[0]} ${genomeReads[1]}
   """

}
