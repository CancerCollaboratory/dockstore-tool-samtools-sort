FROM ubuntu:16.10

MAINTAINER Collaboratory@OICR 

RUN  apt-get update \
  && apt-get install -y samtools

