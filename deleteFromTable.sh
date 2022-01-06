#!/bin/bash
clear
typeset -i dltd
typeset -i ln
typeset -i NF
typeset -i i
typeset -i y
typeset -i rmv
tblPATH=""
cl=""
col=""
match=""
deleter=""


function deleteAll
{

	rmv=`cat $tblPATH | wc -l`
	sed -i '3,$ d' $tblPATH
}


function delete
{
	deleter=`cat $tblPATH | head -$y | tail -1`
	sed -i '/'"$deleter"'/d' $tblPATH
}




function search
{

read -p "insert the match value: " w

#######begin counter#######
while [ $y -le $ln ]
do
	match=`cat $tblPATH | head -$y | tail -1 | cut -d: -f$c`
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
	match=`cat $tblPATH | head -$y | tail -1 | cut -d: -f$c`
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
		dltd=$rmv-2
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

	read -p "Enter any key to delete new record or x to Back: " redelete
	if [[ $redelete != x ]]
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
 
	cl=`cat $tblPATH | head -2 | tail -1`
	ln=`cat $tblPATH | wc -l`
	NF=`awk -F: 'END{print NF}' $tblPATH`
	
	main


else 
	read -p "ERROR: No such table, enter any key to try again or x to Back: " again
	if [[ $again != x ]]
	then
		source ./deleteFromTable.sh
	else
		source ./connectToDB.sh 1
	fi
fi 
