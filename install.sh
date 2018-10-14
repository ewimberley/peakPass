#!/bin/sh
#prerequisites:
sudo apt-get -y install r-base bedtools python bowtie texlive texlive-full build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev python-pip samtools python-tk
sudo Rscript install.R
pip install matplotlib
