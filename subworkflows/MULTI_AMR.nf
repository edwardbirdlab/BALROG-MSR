/*
Subworkflow for doanloading of mutiple AMR databases


*/

include { RESFINDER_DB as RESFINDER_DB } from '../modules/RESFINDER_DB.nf'
include { AMRFINDER_DB as AMRFINDER_DB } from '../modules/AMRFINDER_DB.nf'
include { CARD_DB as CARD_DB } from '../modules/CARD_DB.nf'
include { AMRFINDER as AMRFINDER } from '../modules/AMRFINDER.nf'
include { CARD_CONTIG as CARD_CONTIG } from '../modules/CARD_CONTIG.nf'
include { RESFINDER as RESFINDER } from '../modules/RESFINDER.nf'
include { AMRFINDER_PARSE as AMRFINDER_PARSE } from '../modules/AMRFINDER_PARSE.nf'
include { CARD_PARSE as CARD_PARSE } from '../modules/CARD_PARSE.nf'
include { RESFINDER_PARSE as RESFINDER_PARSE } from '../modules/RESFINDER_PARSE.nf'
include { HAMRONIZE_AMRFINDER as HAMRONIZE_AMRFINDER } from '../modules/HAMRONIZE_AMRFINDER.nf'
include { HAMRONIZE_RGI as HAMRONIZE_RGI } from '../modules/HAMRONIZE_RGI.nf'
include { HAMRONIZE_RESFINDER as HAMRONIZE_RESFINDER } from '../modules/HAMRONIZE_RESFINDER.nf'
include { HAMRONIZE_SUMMARY as HAMRONIZE_SUMMARY } from '../modules/HAMRONIZE_SUMMARY.nf'


workflow MULTI_AMR {

    take:
        seqs            //    channel: [ val(sample), path("somthing.fasta")]

    main:

        // Resfinder Database

        if (params.db_resfinder) {

            RESFINDER_DB()

            ch_resfinder_db        =  RESFINDER_DB.out.resfinder_db

            } else {

                ch_resfinder_db    =  Channel.fromPath("${params.database_dir}/Resfinder/*.fasta")

            }

        RESFINDER(seqs, ch_resfinder_db)

        HAMRONIZE_RESFINDER(RESFINDER.out.for_hamr)


    //emit:

}