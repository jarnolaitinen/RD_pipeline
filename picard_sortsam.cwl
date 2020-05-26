class: CommandLineTool
cwlVersion: v1.0

id: picard_sortsam

baseCommand: [ java, -jar, /usr/picard/picard.jar, SortSam ]

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: broadinstitute/picard
  - class: ResourceRequirement
    outdirMin: 7500
    tmpdirMin: 7700
hints:
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 13000


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
 
