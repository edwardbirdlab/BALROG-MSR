process AMRFINDER_DB {
   label 'internet'
    container 'ncbi/amr:latest'

    input:

    output:
        path("amrfinder_db_down.tar.gz"), emit: amrfinder_db

    script:

    """
    mkdir tmp
    export TMPDIR=./tmp
    amrfinder_update -d amrfinder_db_down
    tar czf amrfinder_db_down.tar.gz amrfinder_db_down
    """
}