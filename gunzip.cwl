class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "gunzip" ]

arguments: [ "-c" ]

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: jlaitinen/lftpalpine
  - class: ResourceRequirement
    outdirMin: 7500
    tmpdirMin: 7500
    coresMin: 2
    ramMin: 5000

inputs:
  - id: reference_file
    type: File[]
    inputBinding:
      position: 1
outputs:
  - id: unzipped_fasta
    type: stdout
    # streamable: true
    #outputBinding:
    #  glob: ".fa"
stdout: $(inputs.reference_file[0].nameroot)
