#!/bin/bash
clear
typeset -i dltd
typeset -i ln
typeset -i NF
typeset -i i
typeset -i y
typeset -i rmv
tablePATH=""
cl=""
col=""
match=""
deleter=""


function deleteAll
{
	sed -i '3,$ d' $tablePATH
}


function delete
{
	deleter=`cat $tablePATH | head -$y | tail -1`
	sed -i '/'"$deleter"'/d' $tablePATH
}




function search
{

read -p "insert the match value: " w

#######begin counter#######
while [ $y -le $ln ]
do
	match=`cat $tablePATH | head -$y | tail -1 | cut -d: -f$c`
	if [[ $match = $w ]]
	then
		rmv=$rmv+1
	fi
	y=$y+1
done
y=3
#######end counter#######

while [ $y -le $ln ]
do
	match=`cat $tablePATH | head -$y | tail -1 | cut -d: -f$c`
	if [[ $match = $w ]]
	then
		delete
		y=$y-1
	fi
	y=$y+1
done
}



function main

{
	y=3
	i=1
	rmv=0

	while [ $i -le $NF ]
	do
		echo "$i ) `echo $cl | cut -d: -f$i`"
		i=$i+1
	done

		echo "* ) delete all records"

	read -p "insert the match column: " c

	if [[ $c = "*" ]]
	then
		deleteAll
		dltd=$ln-2
		echo $dltd "Record(s) deleted successfully"

	elif [[ $c -le $NF && $c -gt 0 ]]
	then
		col=`echo $cl | cut -d: -f$c`

		search

		if [ $rmv -eq 0 ]
		then
			echo "ERROR: no match found"
		else
			echo $rmv "Record(s) deleted successfully"
		fi
	else
		echo "ERROR: invalid input, try again"
		main
	fi

	read -p "Enter any key to delete new record or x to exit: " redelete
	if [[ $redelete != x ]]
	then
		main
	else
		source ./menu
	fi

}




read -p "enter table name: " tblName
tablePATH="$tblPATH/$tblName"
if [ -f $tablePATH ]
then  
 
	cl=`cat $tablePATH | head -2 | tail -1`
	ln=`cat $tablePATH | wc -l`
	NF=`awk -F: 'END{print NF}' $tablePATH`
	
	main


else 
	read -p "ERROR: No such table, enter any key to try again or x to exit: " again
	if [[ $again != x ]]
	then
		source ./deleteFromTable.sh
	else
		source ./menu
	fi
fi 
