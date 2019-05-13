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
  - id: known_sites_file
    type: File
    inputBinding:
      position: 1

outputs:
  - id: unzipped_known_sites_file
    type: stdout
    #outputBinding:
    #  glob: "*.gvcf"
stdout: $(inputs.known_sites_file.nameroot)
