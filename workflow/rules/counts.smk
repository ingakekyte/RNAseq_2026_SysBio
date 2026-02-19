rule count:
    input:
        sorted_bam="results/hisat2/{sample}.sorted.bam",
        gtf=config["gtf"]
    output:
        counts="results/counts/{sample}.featureCounts.txt",
        summary="results/counts/{sample}.featureCounts.txt.summary"
    threads: 2
    conda:
        "../envs/rnaseq_preprocess.yaml"
    shell:
        """
        mkdir -p results/counts
        featureCounts \
          -t exon -g gene_id \
          -T {threads} \
          -a {input.gtf} \
          -o {output.counts} \
          {input.sorted_bam}
        """
