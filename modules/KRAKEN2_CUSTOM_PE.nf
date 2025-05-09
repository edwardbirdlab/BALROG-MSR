process KRAKEN2_CUSTOM_PE {
    label 'k2_custom_search'
	container 'ebird013/kraken2:latest'

    input:
        tuple val(sample), file(R1), file(R2)
        path(db)
    output:
       tuple val(sample), path("${sample}_out.tsv"), emit: out
       tuple val(sample), path("${sample}_report.tsv"), emit: report
       path("versions.yml"), emit: versions

    script:

    """
    kraken2 --db ${db} --threads ${task.cpus} --output ${sample}_out.tsv --report ${sample}_report.tsv --report-minimizer-data --minimum-hit-groups {params.k2_min_hit_group} --confidence {params.k2_confidence} ${R1} ${R2}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        Kraken2: \$(kraken2 -v 2>&1 | grep "Kraken version" | sed -e "s/Kraken version //g")
    END_VERSIONS 
    """
}