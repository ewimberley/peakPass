#!/bin/sh
samtools view -h -F 0x04 $1.sam > $1.aligned.sam
