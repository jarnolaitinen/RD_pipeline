class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "gunzip" ]

arguments: [ "-c" ]

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: jlaitinen/lftpalpine
  - class: ResourceRequirement
    coresMin: 2
    ramMin: 2000
    outdirMin: 7500
    tmpdirMin: 7500

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
