# Rare Disease workflow
There is also 2019 version, where the documentation is copied:

 https://github.com/Vicfero/Wetlab2Variations
 
Note: The .yml files allow to run each cwl files separately with cwltool. 
There you need to have in the input files in defined in path.
You can see the used containers and their version tags from the CWL files. There might be changes in the repositories.
 
## Wetlab2Variations Workflow Demonstrator

Rare disease researchers’ workflow is that they submit their raw data (fastq), run the mapping and variant calling RD-Connect pipeline and obtain unannotated gvcf files to further submit to the RD-Connect GPAP or analyse on their own.

This demonstrator focuses on the variant calling pipeline. The raw genomic data is processed using the RD-Connect pipeline ([Laurie et al., 2016](https://www.ncbi.nlm.nih.gov/pubmed/27604516)) running on the standards (GA4GH) compliant, interoperable container orchestration platform.

For this implementation, different steps are required:

1. Adapt the pipeline to CWL and dockerise elements 
2. Align with IS efforts on software containers to package the different components (Nextflow) 
3. Submit trio of Illumina NA12878 Platinum Genome or Exome to the GA4GH platform cloud  
4. Run the RD-Connect pipeline on the container platform
5. Return corresponding gvcf files to FEGA


N.B: This demonstrator might have some manual steps, which will not be in production. 

## RD-Connect pipeline

Detailed information about the RD-Connect pipeline can be found in [Laurie et al., 2016](https://www.ncbi.nlm.nih.gov/pubmed/?term=27604516)
![image](https://drive.google.com/uc?export=view&id=1XMTo6eRg0xtHliLTZgkyoR_yjS81bXOE)

## The applications

1. **Name of the application: Adaptor removal**  
Function: remove sequencing adaptors   
Input data (amount, format, directory..): raw fastq  
Output data: paired fastq without adaptors  

2. **Name of the application: Mapping and bam sorting**  
Function: align data to reference genome  
Input data: paired fastq without adaptors  
Output data: sorted bam  

3. **Name of the application: MarkDuplicates**  
Function: Mark (and remove) duplicates  
Input data:sorted bam  
Output data: Sorted bam with marked (or removed) duplicates  

4. **Name of the application: Base quality recalibration (BQSR)**  
Function: Base quality recalibration  
Input data: Sorted bam with marked (or removed) duplicates  
Output data: Sorted bam with marked duplicates & base quality recalculated  

5. **Name of the application: Variant calling**  
Function: variant calling  
Input data:Sorted bam with marked duplicates & base quality recalculated  
Output data: unannotated gvcf per sample  
 
![image](https://drive.google.com/uc?export=view&id=1lrcy-TIwf5emBEQqa4TdWiO0fjJszPHR)

## Licensing

GATK declares that archived packages are made available for free to academic researchers under a limited license for non-commercial use. If you need to use one of these packages for commercial use. https://software.broadinstitute.org/gatk/download/archive 
