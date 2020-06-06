cwlVersion: v1.0

class: CommandLineTool

doc: "Encrypt the input file and sftp it"
requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: DockerRequirement
    dockerPull: lvarin/crypt4gh-lftp:20200604
  - class: ResourceRequirement
    outdirMin: 15000
    tmpdirMin: 15000
hints:
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 2000

inputs:
  - id: file_to_encrypt
    type:
      type: array
      items: File
    inputBinding:
      position: 1

outputs:
  - id: output
    type: stdout

baseCommand: ["crypt4gh-and-lftp"]
