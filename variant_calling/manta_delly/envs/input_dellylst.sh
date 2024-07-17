#!/bin/bash

cp $1/input.txt .

awk '{print $1}' input.txt | awk '$1="\""$1"\"\,"' > tmp1.txt
tr '\n' ' ' < tmp1.txt >> tmp2.txt
sed 's/..$//' tmp2.txt > tmp3.txt
sed 's/$/]/' tmp3.txt | sed 's/^/[/' > $2

rm tmp*txt
