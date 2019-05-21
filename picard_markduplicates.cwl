class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: picard_markduplicates
baseCommand:
  - picard
  - MarkDuplicates
  
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: cnag/picard:2.18.25
  - class: ResourceRequirement
    outdirMin: 7500
    tmpdirMin: 7700

hints:
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 4000

inputs:
  input:
    type: File
    inputBinding:
      position: 2
      prefix: INPUT=
      separate: false
#    secondaryFiles:
#      - ^.bai

arguments:
  - position: 0
    prefix: OPTICAL_DUPLICATE_PIXEL_DISTANCE=
    valueFrom: '100'
    separate: false
  - position: 0
    prefix: TAGGING_POLICY=
    valueFrom: 'All'
    separate: false
  - position: 0
    prefix: CREATE_INDEX=
    valueFrom: 'true'
    separate: false
  - position: 0
    prefix: REMOVE_DUPLICATES=
    valueFrom: 'true'
    separate: false
  - position: 0
    prefix: ASSUME_SORT_ORDER=
    valueFrom: 'coordinate'
    separate: false
  - position: 1
    prefix: METRICS_FILE=
    valueFrom: $(inputs.input.nameroot).dedup.metrics.txt
    separate: false
  - position: 3
    prefix: OUTPUT=
    valueFrom: $(inputs.input.nameroot).dedup.bam
    separate: false

outputs:
  - id: md_bam
    type: File
    outputBinding:
      glob: '*.dedup.bam'
    secondaryFiles:
     - ^.bai
  - id: output_metrics
    type: File
    outputBinding:
      glob: '*.metrics.txt'

label: picard-MD
