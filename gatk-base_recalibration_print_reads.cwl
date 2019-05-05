cwlVersion: v1.0
class: CommandLineTool
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: gatk_base_recalibration_print_reads

baseCommand:
  - gatk
  - '-T'
  - PrintReads
inputs:
  - id: reference_genome
    type: File
    inputBinding:
      position: 1
      prefix: '-R'
    secondaryFiles:
      - .fai
  - id: dict
    type: File
  # from gatk-ir.cwl
  - id: input
    type:
      - File
    inputBinding:
      position: 2
      prefix: '-I'
    secondaryFiles:
      - ^.bai
  # from gatk-base_recalibration.cwl
  - id: br_model
    type:
      - File
    inputBinding:
      position: 4
      prefix: '-BQSR'

arguments:
  - position: 0
    prefix: '-dt'
    valueFrom: NONE
  - position: 3
    prefix: '-o'
    valueFrom: $(inputs.input.nameroot).recalibrated.bam

outputs:
  - id: recalibrated_bam
    type: File
    outputBinding:
      glob: $(inputs.input.nameroot).recalibrated.bam
    secondaryFiles:
      - ^.bai
label: gatk-base_recalibration_print_reads

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: cnag/gatk:3.6-0
hints:
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 8000
    outdirMin: 7500
    tmpdirMin: 7700
