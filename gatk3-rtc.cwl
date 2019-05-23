class: CommandLineTool
cwlVersion: v1.0
id: rtc

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: cnag/gatk:3.6-0
  - class: ResourceRequirement
    outdirMin: 12500
    tmpdirMin: 12500
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.reference_genome)
      - entry: $(inputs.dict)
      - entry: $(inputs.known_indels)
hints:
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 8000

baseCommand:
  - gatk
  - '-T'
  - RealignerTargetCreator

inputs:
  - id: input
    type: File
    inputBinding:
      position: 2
      prefix: '-I'
    secondaryFiles:
      - ^.bai
  - id: rtc_intervals_name
    type: string? 
    default: 'rtc_intervals.list'
  - id: reference_genome
    type: File
    inputBinding:
      position: 1
      prefix: '-R'
    secondaryFiles:
      - .fai
     # - .dict
  - id: known_indels
    type: File
    inputBinding:
      position: 4
      prefix: '--known'
  - id: dict
    type: File
      
arguments:
  - position: 5
    prefix: '-dt'
    valueFrom: NONE
  - position: 3
    prefix: '-o'
    valueFrom: $(inputs.rtc_intervals_name)


outputs:
  - id: rtc_intervals_file
    type: File
    outputBinding:
      glob: "*.list" 
 #$(inputs.rtc_intervals_name)
label: rtc 
