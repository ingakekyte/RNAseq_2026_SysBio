
rule fastqc_raw:
    input:
        lambda wc: f"{input_path}/{wc.sample}_{wc.mate}.fastq"
    output:
        html="results/fastqc/raw/{sample}_{mate}_fastqc.html",
        zip="results/fastqc/raw/{sample}_{mate}_fastqc.zip"
    conda:
        "../envs/rnaseq_preprocess.yaml"
    shell:
        """
        mkdir -p results/fastqc/raw
        fastqc {input} --outdir results/fastqc/raw
        """       

rule fastqc_filtered:
    input:
        lambda wc: f"{input_path}/{wc.sample}_{wc.mate}_filtered.fastq"
    output:
        html="results/fastqc/filtered/{sample}_{mate}_filtered_fastqc.html",
        zip="results/fastqc/filtered/{sample}_{mate}_filtered_fastqc.zip"
    conda:
        "../envs/rnaseq_preprocess.yaml"
    shell:
        """
        mkdir -p results/fastqc/filtered
        fastqc {input} --outdir results/fastqc/filtered
        """


rule fastp:
    input:
        r1=lambda wc: f"{input_path}/{wc.sample}_1.fastq",
        r2=lambda wc: f"{input_path}/{wc.sample}_2.fastq"
    output:
        r1=input_path + "/{sample}_1_filtered.fastq",
        r2=input_path + "/{sample}_2_filtered.fastq",
        html="results/fastp/{sample}_fastp.html",
        json="results/fastp/{sample}_fastp.json"
    conda:
        "../envs/rnaseq_preprocess.yaml"
    threads: 6
    shell:
        """
        fastp \
          -i {input.r1} -I {input.r2} \
          -o {output.r1} -O {output.r2} \
          -h {output.html} -j {output.json} \
          -w {threads}
        """
        
