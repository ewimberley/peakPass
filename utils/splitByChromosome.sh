#!/bin/bash
awk '{print $0 >> $1".bed"}' $1
