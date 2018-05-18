#!/bin/sh
rm grc.bed
rm grc.dat
rm grc_tmp.dat
rm grc_sorted.bed
awk '{ gsub(":&nbsp;</B>", "\t", $5) ; gsub("<BR><B>", "\t", $5) ; gsub("</B><BR>", "", $5) ; gsub("&nbsp;", "_", $5) ; print }' $1 > grc_tmp.dat
awk '{ print $1"\t"$2"\t"$3"\t"$6"\t"$8}' grc_tmp.dat > grc.dat
tail -n +2 "grc.dat" > grc.bed
sortBed -i grc.bed > grc_sorted.bed
