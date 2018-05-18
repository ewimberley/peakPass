#!/bin/sh
cat $1 | sed "s/\W\W/\t/g" > clean_$1
