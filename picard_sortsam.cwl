class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: picard_sortsam
baseCommand:
  - picard
  - SortSam
  
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: cnag/picard:2.18.25
  - class: ResourceRequirement
    outdirMin: 7500
    tmpdirMin: 7700
hints:
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 3000


inputs:
  - id: sam
    type: File
    inputBinding:
      position: 1
      prefix: 'INPUT='
      separate: false

arguments:
  - position: 2
    prefix: OUTPUT=
    valueFrom: $(inputs.sam.nameroot).sorted.bam
    separate: false
  - position: 3
    prefix: SORT_ORDER=
    valueFrom: 'coordinate'
    separate: false

outputs:
  - id: sorted_bam
    type: File
    outputBinding:
      glob: "*.bam"
    secondaryFiles: 
      - .bai
 
