process AMRFINDER_DB {
   label 'internet'
    container 'ncbi/amr:latest'

    input:

    output:
        path("amrfinder_db_down/"), emit: amrfinder_db

    script:

    """
    mkdir tmp
    export TMPDIR=./tmp
    amrfinder_update -d amrfinder_db_down
    """
}