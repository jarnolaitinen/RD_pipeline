cwlVersion: v1.0
class: CommandLineTool
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: gatk_haplotypecaller

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
    coresMin: 8
    ramMin: 8000

baseCommand:
  - gatk
  - '-T'
  - HaplotypeCaller

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
# from gatk-base_recalibration_print_reads.cwl
  - id: input
    type: File
    inputBinding:
      position: 2
      prefix: '-I'
    secondaryFiles:
      - ^.bai
  - id: chromosome
    type: string
    inputBinding:
      position: 3
      prefix: '-L'
#  - id: output_filename
#    type: string
#    inputBinding:
#      position: 4
#      prefix: '-o'
#  - 'sbg:toolDefaultValue': '2'
  - id: ploidy
    type: int?
    inputBinding:
      position: 5
      prefix: '-ploidy'

arguments:
  - position: 0
    prefix: '-dt'
    valueFrom: 'NONE'
  - position: 0
    prefix: '-rf'
    valueFrom: 'BadCigar'
  - position: 0
    prefix: '-ERC'
    valueFrom: 'GVCF'
  - position: 0
    prefix: '--never_trim_vcf_format_field'
    valueFrom: ''
  - position: 0
    prefix: '-variant_index_type'
    valueFrom: 'LINEAR'
  - position: 0
    prefix: '-variant_index_parameter'
    valueFrom: '128000'
  - position: 0
    prefix: '-o'
    valueFrom: $(inputs.input.nameroot).gvcf

outputs:
  - id: gvcf
    type: File
    outputBinding:
      glob: "*.gvcf"
      # $(inputs.input.nameroot).gvcf
    secondaryFiles:
      - .idx
      # - .tbi
label: gatk3-haplotypecaller


