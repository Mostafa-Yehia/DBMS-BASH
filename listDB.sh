#!/bin/bash
clear
typeset -i n
databaseList=`ls $dbPATH`
n=`ls $dbPATH |  wc -l`
IFS=$'\n'; dbList=($databaseList); unset IFS;
typeset -i i=1
echo "All DataBases In The System"
while [ $i -le $n ]
do
	echo $i')' ${dbList[$i-1]}
	i=$i+1
done
source ./menu
