process AMRFINDER {
   label 'lowmemnk'
    container 'ncbi/amr:latest'

    input:
        tuple val(sample), file(fasta)
        file(db)
    output:
        path("./${sample}_AMRFinder.tsv"), emit: amrfinder_results
        tuple val(sample), path("./${sample}_AMRFinder.tsv"), path("versions.yml"), emit: for_hamr
        path("versions.yml"), emit: versions

    script:

    """
    mkdir amrfinderdb
    tar -xvzf ${db} --strip-components=1 -C amrfinderdb
    mkdir tmpamr
    TMPDIR="./tmpamr"
    amrfinder -d amrfinderdb/latest -n ${fasta} --plus -o ${sample}_AMRFinder.tsv

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        amrfinder: \$(amrfinder -V 2>&1 | grep "Software version" | sed -e "s/Software version: //g")
        amrfinder_db: \$(amrfinder -V 2>&1 | grep "Database version" | sed -e "s/Database version: //g")
    END_VERSIONS  
    """
}