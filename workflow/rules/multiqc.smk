rule multiqc:
    input:
        expand("results/fastqc/{sample}_{stage}_fastqc.zip",
               sample=samples, stage=["raw", "filtered"]),
        expand("results/hisat2/{sample}_summary.txt", sample=samples),
        expand("results/counts/{sample}.featureCounts.txt.summary", sample=samples)
    output:
        report="results/multiqc/multiqc_report.html"
    conda:
        "../envs/multiqc.yaml"
    shell:
        """
        mkdir -p results/multiqc
        multiqc . -o results/multiqc -n multiqc_report.html --force
        """
