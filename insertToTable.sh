#!/bin/bash
clear
typeset -i serial
typeset -i st
typeset -i NF
typeset -i lnt
typeset -i lni
typeset -i i=1
tblPATH=""
dt=""
cl=""
dty=""
col=""
buffer=""
record=""

function constraints

{

lni=3
lnt=`cat $tblPATH | wc -l`

while [[ $lni -le $lnt ]]
do

	matcher=`cat $tblPATH | head -$lni | tail -1 | cut -d: -f$i`

	if [[ $x = "" ]]
	then
		echo "ERROR: PK can NOT be NULL, try again"
		break
	elif [[ $x = $matcher ]]
	then
		echo "ERROR: PK can NOT be repeated, try again"
		break
	fi
	lni=$lni+1
done

if [[ $lni -gt $lnt ]]
then
	st=-1
fi

}


function insert
{

if [[ $dty == serial ]]
then

	serial=`cat $tblPATH | tail -1 | cut -d: -f$i`
	if [[ $serial = +([0-9]) ]]
	then
		serial=$serial+1
		buffer=$serial
	else
		serial=1
		buffer=$serial
	fi
	st=-1
else
	
if [[ $st -eq 1 ]]
then
	read -p "$col[$dty][PK]: " x
else
	read -p "$col[$dty]: " x
fi






	if [[ $dty == int ]]
	then
		if [[ $x = +([0-9]) || $x = "" ]]
		then
			while [[ $st -eq 1 ]]
			do
				constraints
				if [[ $st -eq -1 ]]
				then
					break
				else
					insert
				fi
			done
			buffer=$x
		else
			if [[ $x = "" ]]
				then buffer=""
			else
				echo "ERROR: must be int, try again"
				insert
			fi
		fi





	elif [[ $dty == text ]]
	then
		if [[ $x = +([a-zA-Z" "]) || $x = "" ]]
		then
			while [[ $st -eq 1 ]]
			do
				constraints
				if [[ $st -eq -1 ]]
				then
					break
				else
					insert
				fi
			done
			buffer=$x
		else
			if [[ $x = "" ]]
				then buffer=""
			else
				echo "ERROR: must be text, try again"
				insert
			fi
		fi
	fi
fi

}


function main
{

	st=1
	i=1
	while [ $i -le $NF ]
	do
	dty=`echo $dt | cut -d: -f$i`
	col=`echo $cl | cut -d: -f$i`
	insert
	if [ $i -eq 1 ]
	then
	record=$buffer	
	else
	record="$record:$buffer"
	fi
	i=$i+1
	done
	echo $record >> $tblPATH
	echo "Record inserted successfully"
	read -p "Enter any key to insert new record or x to Back: " reinsert
	if [[ $reinsert != x ]]
	then
		main
	else
		source ./connectToDB.sh 1
	fi


}



read -p "enter table name: " tblName
tblPATH="$dbPATH/$tblName"
if [ -f $tblPATH ]
then


	dt=`cat $tblPATH | head -1`
	cl=`cat $tblPATH | head -2 | tail -1`
	NF=`awk -F: 'END{print NF}' $tblPATH`

	main

else
	read -p "ERROR: No such table, enter any key to try again or x to Back: " again
	if [[ $again != x ]]
	then
		source ./insertToTable.sh
	else
		source ./connectToDB.sh 1
	fi
fi 
