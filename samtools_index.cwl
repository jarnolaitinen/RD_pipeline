cwlVersion: v1.0
class: CommandLineTool
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: fastq_index
baseCommand:
  - samtools
  - faidx
  
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: biocontainers/samtools:1.3.1
  - class: InitialWorkDirRequirement
    listing: 
      - entry: $(inputs.input)
       
hints:
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 8000
    outdirMin: 7500
    tmpdirMin: 7700

inputs:
  - id: input
    type: File
    inputBinding:
      position: 1
outputs:
  - id: index_fai
    type: File
    outputBinding:
      glob: "*.fa"
    secondaryFiles:
      - .fai
label: samtools-faidx
