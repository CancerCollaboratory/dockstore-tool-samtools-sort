#!/usr/bin/env cwl-runner

# adapted from https://github.com/common-workflow-language/workflows/tree/master/tools

class: CommandLineTool

dct:contributor:
  foaf:name: Andy Yang
  foaf:mbox: mailto:ayang@oicr.on.ca
dct:creator:
  '@id': http://orcid.org/0000-0001-9102-5681
  foaf:name: Andrey Kartashov
  foaf:mbox: mailto:Andrey.Kartashov@cchmc.org
dct:description: 'Developed at Cincinnati Children’s Hospital Medical Center for the
  CWL consortium http://commonwl.org/ Original URL: https://github.com/common-workflow-language/workflows'
cwlVersion: v1.0


requirements:
- class: DockerRequirement
  dockerPull: quay.io/cancercollaboratory/dockstore-tool-samtools-sort
inputs:
  compression_level:
    type: int?
    inputBinding:
      prefix: -l
    doc: |
      Set compression level, from 0 (uncompressed) to 9 (best)
  threads:
    type: int?
    inputBinding:
      prefix: -@

    doc: Set number of sorting and compression threads [1]
  memory:
    type: string?
    inputBinding:
      prefix: -m
    doc: |
      Set maximum memory per thread; suffix K/M/G recognized [768M]
  input:
    type: File
    inputBinding:
      position: 1

    doc: Input bam file.
  output_name:
    type: string
    inputBinding:
      position: 2
      prefix: -o

    doc: Desired output filename.
  sort_by_name:
    type: boolean?
    inputBinding:
      prefix: -n

    doc: Sort by read names (i.e., the QNAME field) rather than by chromosomal coordinates.
outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output_name)

baseCommand: [samtools, sort]
doc: |
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

