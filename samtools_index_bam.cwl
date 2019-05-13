class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: BAM_index
baseCommand:
  - samtools
  - index
  
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: biocontainers/samtools:1.3.1
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 8000
    outdirMin: 7500
    tmpdirMin: 7700

inputs:
# sorted bam
  - id: input
    type: File
    inputBinding:
      position: 1
  
arguments:
  - position: 2
    valueFrom: '$(inputs.input.nameroot + ".bai")' 
outputs:
  - id: index_of_bam
    type: File
    outputBinding:
      glob: "*.bai"

label: samtools-bam_index
