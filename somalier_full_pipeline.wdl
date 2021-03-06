
#Cromwell version 52


import "https://raw.githubusercontent.com/htan-pipelines/bulk-rna-seq-pipeline/master/somalier.wdl" as somalier_extract_wdl
import "https://raw.githubusercontent.com/htan-pipelines/bulk-rna-seq-pipeline/master/somalier_relate.wdl" as somalier_relate_wdl
import "https://raw.githubusercontent.com/htan-pipelines/bulk-rna-seq-pipeline/master/combineVCF.wdl" as combineVCF_wdl
import "https://raw.githubusercontent.com/htan-pipelines/bulk-rna-seq-pipeline/master/VCFtools.wdl" as VCFtools_wdl

workflow full_somalier_workflow {

    
    Array[File] bam_files
    String prefix
    
    File refFasta
    Array[File] knownVcfs
    Array[File] knownVcfsIndices

    String somalier_docker
    
    Int preemptible_count
    scatter (bam in bam_files) {
      call somalier_extract_wdl.extract {
        input: input_known_indel_sites_VCF=knownVcfs, ref_fasta=refFasta, input_bam=bam, prefix=prefix
      }
     }
    call somalier_relate_wdl.relate{
        input: somalier_counts=extract.somalier_output, ped_input=VCFtools.ped_file
    }


}
