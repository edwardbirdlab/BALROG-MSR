process CARD_READS {
   label 'lowmem'
    container 'ebird013/rgi:6.0.3'

    input:
        tuple val(sample), file(R1), file(R2)
        path(db)
    output:
        path("./${sample}"), emit: results
        tuple val(sample), path("./${sample}/${sample}_out.gene_mapping_data.txt"), path("versions.yml"), emit: for_hamr
        path("versions.yml"), emit: versions

    script:

    """
    mkdir ${sample}
    rgi clean --local
    rgi load --card_json ${db} --local

    rgi card_annotation -i ${db} > card_annotation.log 2>&1
    rgi load -i ${db} --card_annotation card_database_v4.0.0.fasta --local

    rgi bwt --read_one ${R1} --read_two ${R2} --output_file ./${sample}/${sample}_out --local --clean -a bowtie2 -n ${task.cpus}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        rgi_main: \$(rgi main -v 2>&1)
        card: \$(rgi database -v 2>&1)
    END_VERSIONS
    """
}