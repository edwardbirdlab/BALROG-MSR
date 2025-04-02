/*
Subworkflow for assembly of short read bactarial genomes and classificaion of plasmids
Requries set params:

params.min_contig_size = '500'     ==  combined with coverage to filter out small lov cov contigs
params.min_contig_cov = '2'        ==  conbined with size to filter out small lov cov contigs

*/

include { SPADES_METAGENOME as SPADES_METAGENOME } from '../modules/SPADES_METAGENOME.nf'
include { QUAST as QUAST_GENOME } from '../modules/QUAST.nf'
include { KRAKEN2_DB_PLUSPF as KRAKEN2_DB_PLUSPF } from '../modules/KRAKEN2_DB_PLUSPF.nf'
include { KRAKEN2_PLUSPF_FA as KRAKEN2_PLUSPF_FA } from '../modules/KRAKEN2_PLUSPF_FA.nf'


workflow SHORT_READ_META_ASSEMBLY {
    take:
        fastqs_short      //    channel: [val(sample), path(fastq1), path(fastq2)]

    main:

        //Kraken2 Database

        if (params.db_kraken2_pluspf) {

            KRAKEN2_DB_PLUSPF()

            ch_kraken2_pluspf_db        =  KRAKEN2_DB_PLUSPF.out.kraken2_DB

            } else {

                ch_kraken2_pluspf_db    =  Channel.fromPath("${params.database_dir}/Kraken2_PlusPF_db/*.txt").combine(Channel.fromPath("${params.database_dir}/Kraken2_PlusPF_db/*.tar.gz"))

            }

        //Spades Isolate Assembly
        SPADES_METAGENOME(fastqs_short)

        //Quast report of genome
        QUAST_GENOME(SPADES_METAGENOME.out.metagenome)

        KRAKEN2_PLUSPF_PE(SPADES_METAGENOME.out.metagenome, ch_kraken2_pluspf_db)


    emit:
        unclassed_genome   = SPADES_METAGENOME.out.metagenome  //   channel: [ val(sample), path("${sample}_scaffolds.fasta")]

}