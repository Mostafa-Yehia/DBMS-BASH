#!/bin/bash
clear
typeset -i n
tableList=`ls $dbPATH`
n=`ls $dbPATH |  wc -l`
IFS=$'\n'; tableList=($tableList); unset IFS;
typeset -i i=1
echo "All tables In The System"
while [ $i -le $n ]
do
	echo $i')' ${tableList[$i-1]}
	i=$i+1
done
echo "press any key to go back..."
