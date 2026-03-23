# alignment.smk (HISAT2 + samtools)

rule hisat2:
    input:
        r1=lambda wc: f"{input_path}/{wc.sample}_1_filtered.fastq",
        r2=lambda wc: f"{input_path}/{wc.sample}_2_filtered.fastq"
    output:
        sam="results/hisat2/{sample}.sam",
        bam="results/hisat2/{sample}.bam",
        summary="results/hisat2/{sample}_summary.txt"
    params:
        index=lambda wc: config["genome_index"]
    conda:
        "../envs/rnaseq_preprocess.yaml"
    threads: 6
    shell:
        """
        mkdir -p results/hisat2
        hisat2 -p {threads} -x {params.index} \
          -1 {input.r1} -2 {input.r2} --new-summary \
          --summary-file {output.summary} -S {output.sam}
        samtools view -bS {output.sam} > {output.bam}
        """

rule sort_bam:
    input:
        unsorted_bam="results/hisat2/{sample}.bam"
    output:
        sorted_bam="results/hisat2/{sample}.sorted.bam"
    threads: 4
    conda:
        "../envs/rnaseq_preprocess.yaml"
    shell:
        """
        samtools sort -@ {threads} -o {output.sorted_bam} {input.unsorted_bam}
        """

rule index_bam:
    input:
        sorted_bam="results/hisat2/{sample}.sorted.bam"
    output:
        bam_index="results/hisat2/{sample}.sorted.bam.bai"
    conda:
        "../envs/rnaseq_preprocess.yaml"
    shell:
        """
        samtools index {input.sorted_bam}
        """
