rule multiqc:
    input:
        fastqc = expand("results/fastqc/{sample}_{stage}_fastqc.zip",
                        sample=samples, stage=["raw","filtered"]),
        fastp = expand("results/fastp/{sample}_fastp.json",
                       sample=samples),
        hisat = expand("results/hisat2/{sample}_summary.txt",
                       sample=samples),
        featureCounts = expand("results/counts/{sample}.featureCounts.txt.summary",
                               sample=samples),
    output:
        report = "results/multiqc/multiqc_report.html",
        outdir = directory("results/multiqc/")
    conda:
        "../envs/multiqc.yaml"
    params:
        extra="--verbose"
    shell:
        """
        multiqc \
          {params.extra} \
          --outdir {output.outdir} \
          --filename $(basename {output.report} .html) \
          {input.fastqc} {input.fastp} {input.hisat} {input.featureCounts}
        """
