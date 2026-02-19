rule fastqc:
    input:
        lambda wc: f"{input_path}/{wc.sample}_{wc.stage}.fastq"
    output:
        html="results/fastqc/{sample}_{stage}_fastqc.html",
        zip="results/fastqc/{sample}_{stage}_fastqc.zip"
    conda:
        "../envs/rnaseq_preprocess.yaml"
    shell:
        """
        fastqc {input} --outdir results/fastqc
        """

rule fastp:
    input:
        expand("{path}/{{sample}}_raw.fastq", path=input_path)
    output:
        filtered = expand("{path}/{{sample}}_filtered.fastq", path=input_path),
        html = "results/fastp/{sample}_fastp.html",
        json = "results/fastp/{sample}_fastp.json"
    conda:
        "../envs/rnaseq_preprocess.yaml"
    shell:
        """
        fastp -i {input} \
        -o {output.filtered} \
        -h {output.html} \
        -j {output.json}
        """
