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
    ramMin: 5000
    outdirMin: 5000
    tmpdirMin: 5000

inputs:
  - id: known_sites_file
    type: File
    inputBinding:
      position: 1

outputs:
  - id: unzipped_known_sites_file
    type: stdout

stdout: $(inputs.known_sites_file.nameroot)
