cwlVersion: v1.0
class: CommandLineTool
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
    coresMin: 4
    ramMin: 4000

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
  # default is to analyse the complete genome
  - id: chromosome
    type: string?
    inputBinding:
      position: 3
      prefix: '-L'
  - id: ploidy
    type: int?
    inputBinding:
      position: 5
      prefix: '-ploidy'
  - id: gqb
    type: string?
    default: "20, 25, 30, 35, 40, 45, 50, 70, 90, 99"
arguments:
  - position: 0
    prefix: '--num_cpu_threads_per_data_thread'
    valueFrom: '6' 
  - position: 0
    prefix: '-dt'
    valueFrom: 'NONE'
  - position: 0
    prefix: '-rf'
    valueFrom: 'BadCigar'
  - position: 0
#    prefix: '-GQB'
    valueFrom: |
      ${
        var r = [];
        var stuff = inputs.gqb.split(','); 
        for (var i=0; i<stuff.length ; i++ ) {
          r.push("-GQB "+stuff[i]);
        } 
        return r;
      }
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
    valueFrom: $(inputs.input.nameroot).vcf.gz

outputs:
  - id: gvcf
    type: File
    outputBinding:
      glob: "*.gz"
    secondaryFiles:
      #- .idx
      - .tbi
label: gatk3-haplotypecaller


