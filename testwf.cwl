class: Workflow
cwlVersion: v1.0
id: rd_connect_test
label: RD_Connect_test

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
  - id: chromosome
    type: string?
  # bwa mem, samtools sort, gatk haplotype caller 
  - id: threads
    type: string?
  - id: sample_name
    type: string
  - id: lftp_out_conf
    type: File

outputs: []

steps:
  - id: fastqs_in
    in:
      - id: curl_config_file
        source: curl_fastq_urls
    out: 
      - id: in_files
    run: curl.cwl

  - id: lftp_out
    in: 
      - id: fastqs_in
        source: in_files
    out: []
    run: lftp.cwl

requirements:
  - class: MultipleInputFeatureRequirement
