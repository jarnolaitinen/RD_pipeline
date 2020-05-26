class: CommandLineTool
cwlVersion: v1.0
id: picard_addorreplacereadgroups

baseCommand: [ java, -jar, /usr/picard/picard.jar, AddOrReplaceReadGroups ]   
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: broadinstitute/picard
  - class: ResourceRequirement
    coresMin: 8
    ramMin: 4000
    outdirMin: 7500
    tmpdirMin: 7700

inputs:
  # BAM
  - id: input
    type: File
    inputBinding:
      position: 2
      prefix: I=
      separate: false
    secondaryFiles:
      - ^.bai

arguments:
  # 	Read Group ID Default value: 1. This option can be set to 'null' to clear the default value. 
  # In Illumina data, read group IDs are composed using the flowcell + lane name and number
  - position: 0
    prefix: RGID=
    valueFrom: 'Seq01p'
    separate: false
# Read Group library Required
  - position: 0
    prefix: RGLB=
    valueFrom: 'lib1'
    separate: false
# Read Group platform (e.g. illumina, solid) Required. 
# Valid values: ILLUMINA, SOLID, LS454, HELICOS and PACBIO. 
  - position: 0
    prefix: RGPL=
    valueFrom: 'ILLUMINA'
    separate: false
# Read Group platform unit (eg. run barcode) Required
# The PU holds three types of information, the {FLOWCELL_BARCODE}.{LANE}.{SAMPLE_BARCODE}. 
# {FLOWCELL_BARCODE} refers to the unique identifier for a particular flow cell. 
# The {LANE} indicates the lane of the flow cell and the {SAMPLE_BARCODE} is a sample/library-specific identifier. 

  - position: 0
    prefix: RGPU=
    valueFrom: 'Seq01.1.1'
    separate: false
# Read Group sample name Required. 
# Sample The name of the sample sequenced in this read group.
# GATK tools treat all read groups with the same SM value as containing sequencing data 
# for the same sample, and this is also the name that will be used for the sample column in the VCF file.
  - position: 0
    prefix: RGSM=
    valueFrom: 'Seq01'
    separate: false
# output (required)
  - position: 3
    prefix: 'O='
    separate: false
    valueFrom: '$(inputs.input.nameroot + ".RG.bam")'
 
outputs:
  - id: md_bam
    type: File
    outputBinding:
      glob: "*.RG.bam"

label: picard-rg
