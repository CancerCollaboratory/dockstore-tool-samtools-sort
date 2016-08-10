FROM ubuntu:16.10

RUN  apt-get update \
  && apt-get install -y samtools

