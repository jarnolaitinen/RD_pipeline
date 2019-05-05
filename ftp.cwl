#!/usr/bin/env cwl-runner
class: Workflow
 
cwlVersion: v1.0

inputs: 
  input_file_url:
    type: string
  input_filename:
    type: string
  lftp_out_conf:
    type: File
steps:
  lftp_in:
    run: lftp_in.cwl
    in:
      url:
        source: input_file_url
      input_filename:
        source: input_filename
    out: [transfered_files]
  cutadapt2:
     run: cutadapt-v.1.18.cwl
     in: 
       raw_sequences: lftp_in/transfered_files
     out: [out_files]
  lftp_out:
    run: lftp.cwl
    in: 
      lftp_out_conf:
         source: lftp_out_conf
      file_to_send: cutadapt2/out_files
    out: []
         
