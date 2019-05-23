cwlVersion: v1.0
class: CommandLineTool
id: gatk-base_recalibration

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: cnag/gatk:3.6-0
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.reference_genome)
      - entry: $(inputs.dict)
  - class: ResourceRequirement
    outdirMin: 7500
    tmpdirMin: 7700

hints:
  - class: ResourceRequirement
    coresMin: 4
    ramMin: 8000

baseCommand:
  - gatk
  - '-T'
  - BaseRecalibrator

inputs:
  - id: reference_genome
    type: File
    inputBinding:
      position: 1
      prefix: '-R'
    secondaryFiles:
      - .fai
  - id: dict
    type: File
  - id: unzipped_known_sites_file
    type: File
  # from gatk ir
  - id: input
    type: File
    inputBinding:
      position: 2
      prefix: '-I'
    secondaryFiles:
      - ^.bai
  - id: known_indels_file
    type: File

arguments:
  - position: 0
    prefix: '-dt'
    valueFrom: NONE

  - position: 0
    prefix: '--knownSites'
    valueFrom: $(inputs.known_indels_file)
#    valueFrom: |
#      ${
#        var r = [];
#        r.push(inputs.known_indels_file);
#        r.push(" --knownSites ");
#        r.push(inputs.unzipped_known_sites_file);
#        return r;
#      }
  - position: 0
    prefix: '--knownSites'
    valueFrom: $(inputs.unzipped_known_sites_file)
   
  - position: 3
    prefix: '-o'
    valueFrom: $(inputs.input.nameroot).br_model
outputs:
  - id: br_model
    type: File
    outputBinding:
      glob: "*.br_model"
    # $(inputs.input.nameroot).br_model
label: gatk3-base_recalibration

