class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: picard_validate_bam
baseCommand:
  - picard
  - ValidateSamFile
  
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: cnag/picard:2.18.25
hints:
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
