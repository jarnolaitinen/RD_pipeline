cwlVersion: v1.0
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: cnag/bwa:0.7.17
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.reference_genome) 
  - class: ResourceRequirement
    ramMin: 20000   
    coresMin: 10
    outdirMin: 7500
    tmpdirMin: 7500

baseCommand:
- bwa
- index


inputs:
  algorithm:
    type: string?
    inputBinding:
      prefix: -a
    doc: |
       BWT construction algorithm: bwtsw or is (Default: auto)
  reference_genome:
    type: File
    inputBinding:
      # valueFrom: $(self.basename)
      position: 4
  block_size:
    type: int?
    inputBinding:
      position: 2
      prefix: -b

outputs:
  output:
    type: File
    outputBinding:
      glob: "*.fa"
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
# $(inputs.reference_genome)



