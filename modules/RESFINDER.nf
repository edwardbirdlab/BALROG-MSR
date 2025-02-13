process RESFINDER {
   label 'medmem'
    container 'ebird013/resfinder:4.4.2'

    input:
        tuple val(sample), file(fasta)
        path(db)

    output:
        path("./${sample}"), emit: resfinder_results
        path("Resfinder_geneseqs_${sample}.fsa"), emit: db_hits
        tuple val(sample), path("${sample}_resfinder_tab.txt"), path("versions.yml"), emit: for_hamr
        path("versions.yml"), emit: versions

    script:

    """
    python3 -m resfinder -o ./${sample} -l 0.6 -t 0.8 -ifa ${fasta} -acq -db_res ./${db} -b /opt/ncbi-blast-2.15.0+/bin/blastn -k /opt/kma/kma
    cp ./${sample}/ResFinder_Resistance_gene_seq.fsa Resfinder_geneseqs_${sample}.fsa
    cp ./${sample}/ResFinder_results_tab.txt ${sample}_resfinder_tab.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        resfinder: \$(python3 -m resfinder -v 2>&1)
        resfinder_db: \$(cat ${db}/VERSION)
    END_VERSIONS
    """
}