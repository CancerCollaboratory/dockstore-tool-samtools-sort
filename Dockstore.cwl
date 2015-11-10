#!/usr/bin/env cwl-runner

# adapted from https://github.com/common-workflow-language/workflows/tree/master/tools

class: CommandLineTool

description: |
  Sort alignments by leftmost coordinates, or by read name when -n is used. An appropriate @HD-SO sort order header tag will be added or an existing one updated if necessary.

  Usage: samtools sort [-l level] [-m maxMem] [-o out.bam] [-O format] [-n] -T out.prefix [-@ threads] [in.bam]

  Options:
  -l INT
  Set the desired compression level for the final output file, ranging from 0 (uncompressed) or 1 (fastest but minimal compression) to 9 (best compression but slowest to write), similarly to gzip(1)'s compression level setting.

  If -l is not used, the default compression level will apply.

  -m INT
  Approximately the maximum required memory per thread, specified either in bytes or with a K, M, or G suffix. [768 MiB]

  -n
  Sort by read names (i.e., the QNAME field) rather than by chromosomal coordinates.

  -o FILE
  Write the final sorted output to FILE, rather than to standard output.

  -O FORMAT
  Write the final output as sam, bam, or cram.

  By default, samtools tries to select a format based on the -o filename extension; if output is to standard output or no format can be deduced, -O must be used.

  -T PREFIX
  Write temporary files to PREFIX.nnnn.bam. This option is required.

  -@ INT
  Set number of sorting and compression threads. By default, operation is single-threaded

dct:creator:
  foaf:name: Andy Yang
  foaf:mbox: "mailto:ayang@oicr.on.ca"

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/cancercollaboratory/dockstore-tool-samtools-sort"
  - { import: node-engine.cwl }

inputs:
  - id: "#compression_level"
    type: ["null", int]
    description: |
      Set compression level, from 0 (uncompressed) to 9 (best)
    inputBinding:
      prefix: "-l"

  - id: "#memory"
    type: ["null", string]
    description: |
      Set maximum memory per thread; suffix K/M/G recognized [768M]
    inputBinding:
      prefix: "-m"

  - id: "#sort_by_name"
    type: ["null", boolean]
    description: "Sort by read names (i.e., the QNAME field) rather than by chromosomal coordinates."
    inputBinding:
      prefix: -n

  - id: "#threads"
    type: ["null", int]
    description: "Set number of sorting and compression threads [1]"
    inputBinding:
      prefix: -@

  - id: "#output_name"
    type: string
    description: "Desired output filename."
    inputBinding:
      position: 2

  - id: "#input"
    type: File
    description:
      Input bam file.
    inputBinding:
      position: 1

outputs:
  - id: "#output_file"
    type: File
    outputBinding:
      glob:
        engine: "cwl:JsonPointer"
        script: "job/output_name"

baseCommand: ["samtools", "sort"]

arguments:
  - "-f"

