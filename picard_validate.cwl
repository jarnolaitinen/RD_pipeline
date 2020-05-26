class: CommandLineTool
cwlVersion: v1.0

id: picard_validate_sam

baseCommand: [ java, -jar, /usr/picard/picard.jar, ValidateSamFile ]  
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: broadinstitute/picard
 - class: ResourceRequirement
    coresMin: 8
    ramMin: 4000
    outdirMin: 7500
    tmpdirMin: 7700

inputs:
  # BAM
  - id: input
    type: File
    inputBinding:
      position: 2
      prefix: I=
      separate: false
    secondaryFiles:
      - ^.bai

arguments:
  - position: 0
    prefix: MODE=
    # VERBOSE, SUMMARY
    valueFrom: 'VERBOSE'
    separate: false
 
outputs:
  output:
    type: stdout

label: picard-validatebam
