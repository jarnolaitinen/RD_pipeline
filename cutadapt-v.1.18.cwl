#!/usr/bin/env cwl-runner
class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: cutadapt2
baseCommand: [cutadapt, --interleaved]
arguments: 
  - position: 4
    prefix: '-o'
    # nameroot instead of basename
    valueFrom: '$(inputs.raw_sequences[0].basename + ".trimmed.fastq.gz")' 
  - position: 3
    prefix: '--overlap'
    valueFrom: '6'
  - position: 1
    prefix: '-j'
    valueFrom: '0'
 # - position: 4
 #   prefix: -p
 #   valueFrom: '$(inputs.raw_sequences[1].basename + ".trimmed.fastq.gz")'
  - position: 2
    prefix: '--error-rate'
    valueFrom: '0.2'
inputs:
  - id: raw_sequences
    type: File[]
 #     - type: array
 #       items: File 
    inputBinding:
      position: 20
      prefix: ''
      separate: false
  - id: adaptors_file
    type: File?
    inputBinding:
      position: 10
      prefix: '-a'
outputs:  
  - id: trimmed_fastq
    type: File
#      - type: array
#        items: File 
    outputBinding:
      glob: '*.trimmed.fastq.gz'
label: cutadapt
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: 'cnag/cutadapt:1.18'   
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 14000
    outdirMin: 2500
