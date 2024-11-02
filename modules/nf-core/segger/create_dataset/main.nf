params.cli_dir = "/workspace/segger_dev/src/segger/cli"

process SEGGER_CREATE_DATASET {
    tag "$meta.id"
    label 'process_high'

    // TODO nf-core: See section in main README for further information regarding finding and adding container addresses to the section below.
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        '/data/sail/projects/tools/modules/segger_dev_cuda121.sif' :
        'danielunyi42/segger_dev:cuda121' }"
    //container danielunyi42/segger_dev:cuda121

    input:
    tuple val(meta), path(base_dir)
    val(sample_type)

    output:
    tuple val(meta), path("segger_dataset"), emit: dataset
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
        if (workflow.profile.tokenize(',').intersect(['conda', 'mamba']).size() >= 1) {
            error "Segger does not support Conda. Please use Docker / Singularity / Podman instead."
        }

        def args = task.ext.args ?: ''
        def prefix = task.ext.prefix ?: "${meta.id}"
        def cli_path = params.cli_dir + "/create_dataset_fast.py"
        // TODO nf-core: version number!!
        // TODO create 'tmp' only if execution is docker, singularity or podman
        """
        # set writable(!) tmp directory in bash
        TMP_DIR=\$(mktemp -d)
        export MPLCONFIGDIR=\$TMP_DIR
        export NUMBA_CACHE_DIR=\$TMP_DIR

        # run create_dataset
        python3 $cli_path \\
            --base_dir $base_dir \\
            --data_dir segger_dataset \\
            --sample_type $sample_type \\
            --n_workers ${task.cpus}
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
        segger: \$(echo NOT IMPLEMENTED)
    END_VERSIONS
    """
}
