cwlVersion: v1.0
class: CommandLineTool
baseCommand: ["curl"]

doc: "transfer file from a remote FTP/HTTP server to the TES"
requirements:
#  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: jlaitinen/lftpalpine
  - class: ResourceRequirement
    coresMin: 2
    ramMin: 2000
    tmpdirMin: 2500
    outdirMin: 2500  
      
inputs:
  curl_config_file:
    type: File
    inputBinding:
      prefix: -K 
      separate: true
      position: 1

outputs:
  in_files:
    type: File[]
    outputBinding:
      glob: "*.gz"
 
