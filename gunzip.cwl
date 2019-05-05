class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "gunzip" ]

arguments: [ "-c" ]

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
#    dockerPull: ubuntu:xenial
    dockerPull: jlaitinen/lftpalpine

inputs:
  - id: reference_file
    type: File[]
    inputBinding:
      position: 1

outputs:
  - id: unzipped_fasta
    type: stdout
    #outputBinding:
    #  glob: ".fa"
stdout: $(inputs.reference_file[0].nameroot)
