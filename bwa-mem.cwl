class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
baseCommand:
  - bwa
  - mem

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: DockerRequirement
    dockerPull: cnag/bwa:0.7.17
  - class: ResourceRequirement
    outdirMin: 10500
    tmpdirMin: 10700
hints:
  - class: ResourceRequirement
    coresMin: 10
    ramMin: 40000
 
inputs:
#  - id: bwa_output_filename
#    type: string?
#    default: $(inputs.trimmed_fastq.nameroot).sam
  - id: trimmed_fastq
    type: File
    inputBinding:
      position: 4
  - id: reference_genome
    type: File
    inputBinding:
      position: 3
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
  - id: threads
    type: int?
    default: 2
    inputBinding:
      position: 1
      prefix: '-t'
    doc: '-t INT        number of threads [1]'
  - id: read_group
    type: string
    default: '@RG\\tID:H947YADXX\\tSM:NA12878\\tPL:ILLUMINA'
    inputBinding: 
      position: 2
      prefix: -R
      
stdout: $(inputs.trimmed_fastq.nameroot).sam
arguments:
  - position: 2
    prefix: -M
  
outputs:
  - id: aligned_sam
    type: File
    outputBinding:
      glob: "*.sam"
