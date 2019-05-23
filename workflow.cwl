class: Workflow
cwlVersion: v1.0
id: rd_connect
label: RD_Connect

inputs:
  - id: curl_reference_genome_url
    type: File
  - id: curl_fastq_urls
    type: File
  - id: curl_known_indels_url
    type: File
  - id: curl_known_sites_url
    type: File
  - id: readgroup_str
    type: string
  # optional:
  - id: chromosome
    type: string
  - id: sample_name
    type: string
  - id: lftp_out_conf
    type: File
# DEBUG
#  - id: trimmed_fastq
#    type: File
#  - id: reference_genome
#    type: File
    # these are produced by bwa index step
#    secondaryFiles:
#      - .amb
#      - .ann
#      - .bwt
#      - .pac
#      - .sa
#  - id: bwa_output_filename
#    type: string
#  - id: bwa_mem_file
#    type: File
#    'sbg:x': -57
#    'sbg:y': -641
#  - id: rtc_intervals_name
#    type: File
#  - id: known_sites
#    type:
#      - File
#      - type: array
#        items: File
outputs: []

steps:
  # if the file is publicly available, curl is the simplest
  - id: fastqs_in
    in:
      - id: curl_config_file
        source: curl_fastq_urls
    out: 
      - id: in_files
    run: curl.cwl

  - id: reference_in
    in:
      - id: curl_config_file
        source: curl_reference_genome_url
    out: 
      - id: in_files
        #type: array
        #items: File
    run: curl.cwl

  - id: known_indels_in
    in:
      - id: curl_config_file
        source: curl_known_indels_url
    out:
      - id: known_indels_file
        #type: array
        #items: File
    run: curl_indels.cwl

  - id: known_sites_in
    in:
      - id: curl_config_file
        source: curl_known_sites_url
    out:
      - id: known_sites_file
        #type: array
        #items: File
    run: curl_known_sites.cwl

  - id: unzipped_known_sites
    in:
      - id: known_sites_file
        source:
          - known_sites_in/known_sites_file
    out:
      - id: unzipped_known_sites_file
    run: gunzip_known_sites.cwl

  - id: gunzip
    in:
      - id: reference_file
        source:
          - reference_in/in_files
    out:
      - id: unzipped_fasta
    run: gunzip.cwl

  - id: picard_dictionary
    # from samtools reference genome
    in:
      - id: reference_genome
        source:
          - gunzip/unzipped_fasta
    # produced .dict file
    out:
      - id: dict
    run: picard_dictionary.cwl

  - id: cutadapt2
    in:
    # takes two FASTQ files (.gz)
      - id: raw_sequences
        source:
          - fastqs_in/in_files
    # trimmed sequence file fastq.gz
    out: 
      - id: trimmed_fastq
    run: cutadapt-v.1.18.cwl

  - id: bwa_index
    # the takes the fa.gz reference genome as input
    in:
      - id: reference_genome
        source:
          - gunzip/unzipped_fasta
      # algorith is by default  bwtsw
      # algorithm: index_algorithm
      # also blocksize could be tuned
      # produced .amb, .ann, .bwt, .pac, and .sa files
    out:
      - id: output
    run: bwa-index.cwl

  - id: samtools_index
    # reference genome .fa
    in:
      - id: input
        source:
          - gunzip/unzipped_fasta
    # produces .fai
    out:
      - id: index_fai
    run: samtools_index.cwl


  - id: bwa_mem
    # the the trimmed sequence fastq.gz, read group string 
    # and files from the bwa index
    in:
      - id: trimmed_fastq
        source:
         - cutadapt2/trimmed_fastq
      - id: read_group
        source:
          - readgroup_str
      - id: sample_name
        source:
          - sample_name
      # this includes also many secondaryFiles too
      - id: reference_genome
        source:
          - bwa_index/output
    # output is a SAM file
    out:
      - id: aligned_sam
    run: bwa-mem.cwl

  - id: samtools_sort
    # sam from bwa mem
    in:
      - id: input
        source:
          - bwa_mem/aligned_sam
    # produces sorted .bam
    out:
      - id: sorted_bam
    run: samtools_sort_bam.cwl
   

  - id: picard_markduplicates
    # takes sorted bam
    in:
      - id: input
        source: 
          - samtools_sort/sorted_bam
    # .dedup.bam and .bai and the metrics file
    out:
      - id: md_bam
      - id: output_metrics
    run: picard_markduplicates.cwl
    label: picard-MD


  - id: gatk3-rtc
    in:
      - id: input
        source: 
          - picard_markduplicates/md_bam
      - id: reference_genome
        source: 
          - samtools_index/index_fai
      - id: dict
        source:
          - picard_dictionary/dict
      - id: known_indels
        source:
          - known_indels_in/known_indels_file
    out:
      - id: rtc_intervals_file
    run: gatk3-rtc.cwl
    label: gatk3-rtc

  - id: gatk-ir
    in:
      - id: input
        source: 
          - picard_markduplicates/md_bam
      - id: rtc_intervals
        source: 
          - gatk3-rtc/rtc_intervals_file
      - id: reference_genome
        source: 
         # - reference_in/in_files
           - samtools_index/index_fai
      - id: dict
        source:
          - picard_dictionary/dict
    out:
      - id: realigned_bam
    run: gatk-ir.cwl
    label: gatk-ir

  - id: gatk-base_recalibration
    in:
      - id: reference_genome
        source: 
          - samtools_index/index_fai
      - id: dict
        source:
          - picard_dictionary/dict
      - id: input
        source:
          - gatk-ir/realigned_bam
      - id: unzipped_known_sites_file
        source:
          - unzipped_known_sites/unzipped_known_sites_file
      - id: known_indels_file
        source:
          - known_indels_in/known_indels_file
    out:
      - id: br_model
    run: gatk-base_recalibration.cwl
    label: gatk-base_recalibration

  - id: gatk-base_recalibration_print_reads
    in:
      - id: reference_genome
        source: 
          - samtools_index/index_fai
      - id: dict
        source:
          - picard_dictionary/dict
      - id: input
        source:
          - gatk-ir/realigned_bam
      - id: br_model
        source:
          - gatk-base_recalibration/br_model
    out:
      - id: bqsr_bam
    run: gatk-base_recalibration_print_reads.cwl
    label: gatk-base_recalibration_print_reads


  - id: gatk_haplotype_caller
    in:
      - id: reference_genome
        source: 
          - samtools_index/index_fai
      - id: dict
        source:
          - picard_dictionary/dict
      - id: input
        source:
          - gatk-base_recalibration_print_reads/bqsr_bam
      - id: chromosome
        source: 
          - chromosome
    out:
      - id: gvcf
    run: gatk-haplotype_caller.cwl
    label: gatk-haplotype_caller

  # indexes and alignment too
  - id: lftp_out
    in: 
      - id: lftp_out_conf
        source: lftp_out_conf
      - id: files_to_send
        source:
          - picard_markduplicates/output_metrics
      - id: bam
        # BAM and bai
        source:
          - gatk-base_recalibration_print_reads/bqsr_bam
      # with .tbi 
      - id: gvcf
        source:      
          - gatk_haplotype_caller/gvcf
    out: []
    run: lftp.cwl
requirements:
  - class: MultipleInputFeatureRequirement
