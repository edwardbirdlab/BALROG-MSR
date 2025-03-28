/*
Subworkflow for doanloading of mutiple AMR databases


*/

include { CARD_DB as CARD_DB } from '../modules/CARD_DB.nf'
include { CARD_READS as CARD_READS } from '../modules/CARD_READS.nf'
include { HAMRONIZE_RESFINDER_BWT as HAMRONIZE_RESFINDER_BWT } from '../modules/HAMRONIZE_RESFINDER_BWT.nf'
include { HAMRONIZE_SUMMARY as HAMRONIZE_SUMMARY } from '../modules/HAMRONIZE_SUMMARY.nf'


workflow CARD_READS_ONLY {

    take:
        reads            //    channel: [ val(sample), path("somthing_1.fq"), path("somthing_2.fq")]

    main:

        // CARD Database

        if (params.db_card) {

            CARD_DB()

            ch_card_db        =  CARD_DB.out.card_DB

            } else {

                ch_card_db    =  Channel.fromPath("${params.database_dir}/CARD/card.json")

            }



        CARD_READS(reads, ch_card_db)

        HAMRONIZE_RESFINDER_BWT(CARD_READS.out.for_hamr)

        HAMRONIZE_SUMMARY(HAMRONIZE_RESFINDER_BWT.out.tsv_only.collect())

    //emit:

}