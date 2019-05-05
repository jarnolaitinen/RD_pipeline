cwlVersion: v1.0
class: CommandLineTool
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: gatk-base_recalibration

baseCommand:
  - gatk
  - '-T'
  - BaseRecalibrator

inputs:
  - id: reference_genome
 #   type: File[]
    type: File
    inputBinding:
      position: 1
      prefix: '-R'
    secondaryFiles:
      - .fai
  - id: dict
    type: File
  # from gatk ir
  - id: input
    type: File
    inputBinding:
      position: 2
      prefix: '-I'
    secondaryFiles:
      - ^.bai
  # downloaded indels vcf
  - id: known_sites
    type:
      - File[]
    inputBinding:
      position: 4
      prefix: '--knownSites'
arguments:
  - position: 0
    prefix: '-dt'
    valueFrom: NONE
  - position: 3
    prefix: '-o'
    valueFrom: $(inputs.input.nameroot).br_model

outputs:
  - id: br_model
    type: File
    outputBinding:
      glob: $(inputs.input.nameroot).br_model
label: gatk3-base_recalibration

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

