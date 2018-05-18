#!/bin/sh
awk '{print $0 >> $1".bedGraph"}' $0
