cwlVersion: v1.0
class: CommandLineTool

doc: "transfer file passed from the previous task to the remote ftp server"
requirements:
  - class: InlineJavascriptRequirement 
hints:
  - class: DockerRequirement
    dockerPull: jlaitinen/lftpalpine
  - class: MultipleInputFeatureRequirement
  - class: InitialWorkDirRequirement
    listing: $(inputs.files_to_send[0]+","+inputs.files_to_send[1])
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 8000
    outdirMin: 7200
    
inputs:
  - id: lftp_out_conf
    type: File
    doc: "The parameters file for lftp"
    inputBinding:
      position: 1
  - id: files_to_send
    type:
      type: array
      items: File
#      inputBinding:
#        valueFrom: $(self.basename)
outputs:
  - id: output
    type: stdout

baseCommand: ["lftp"]
arguments: ["-f"]
 
