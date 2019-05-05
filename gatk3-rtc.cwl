class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: rtc
baseCommand:
  - gatk
  - '-T'
  - RealignerTargetCreator
inputs:
  - id: input
    # type: File[]
    type: File
    inputBinding:
      position: 2
      prefix: '-I'
    secondaryFiles:
      - ^.bai
  - id: rtc_intervals_name
    type: string? 
    default: 'rtc_intervals.txt'
  - id: reference_genome
   # type: File[]
    type: File
    inputBinding:
      position: 1
      prefix: '-R'
    secondaryFiles:
      - .fai
  - id: dict
    type: File
  - id: known_indels
    type: File[]
    inputBinding:
      position: 4
      prefix: '--known'
outputs:
  - id: rtc_intervals_file
    type: File
    outputBinding:
      glob: $(inputs.rtc_intervals_name)
label: rtc 
arguments:
  - position: 5
    prefix: '-dt'
    valueFrom: NONE
  - position: 3
    prefix: '-o'
    valueFrom: $(inputs.rtc_intervals_name)  
requirements:
  - class: InlineJavascriptRequirement
 
  - class: DockerRequirement
    dockerPull: cnag/gatk:3.6-0
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 8000
    outdirMin: 7500
    tmpdirMin: 7700
