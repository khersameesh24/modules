process SEGGER_PREDICT {
    tag "$meta.id"
    label 'process_high'

    // TODO nf-core: See section in main README for further information regarding finding and adding container addresses to the section below.
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/TODO-segger':
        'biocontainers/TODO-segger' }"

    input:
    tuple val(meta), path(segger_data_dir)
    path(models_dir)
    path(transcripts_file)
    path(benchmarks_dir)

    output:
    tuple val(meta), path("*.csv"), emit: bam
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
        if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
            error "Segger does not support Conda. Please use Docker / Singularity / Podman instead."
        }

        def args = task.ext.args ?: ''
        def prefix = task.ext.prefix ?: "${meta.id}"

        // TODO nf-core: version number!!
        """
        python3 src/segger/cli/predict_fast.py \\
            --models_dir $models_dir \\
            --segger_data_dir $segger_data_dir \\
            --transcripts_file $transcripts_file \\
            --benchmarks_dir $benchmarks_dir \\
            --num_workers ${task.cpus} \\
            $args

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            segger: \$(echo NOT IMPLEMENTED)
        END_VERSIONS
        """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    // TODO nf-core: A stub section should mimic the execution of the original module as best as possible
    //               Have a look at the following examples:
    //               Simple example: https://github.com/nf-core/modules/blob/818474a292b4860ae8ff88e149fbcda68814114d/modules/nf-core/bcftools/annotate/main.nf#L47-L63
    //               Complex example: https://github.com/nf-core/modules/blob/818474a292b4860ae8ff88e149fbcda68814114d/modules/nf-core/bedtools/split/main.nf#L38-L54
    """
    touch ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        segger: \$(samtools --version |& sed '1!d ; s/samtools //')
    END_VERSIONS
    """
}
