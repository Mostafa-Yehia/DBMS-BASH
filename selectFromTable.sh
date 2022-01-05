#!/bin/bash
clear
typeset -i firCol
typeset -i v
typeset -i n
typeset -i validator
typeset -i ln
typeset -i lnA
typeset -i NF
typeset -i i=1
typeset -i y=3
typeset -i viw=0
declare -a arr
tablePATH=""
cl=""
col=""
fields=""
field=""
match=""
viewer=""


function viewSpecific
{

v=1 #counter
rec=""
buf=""

gate=`echo $f | awk -F- 'END {print NF}'`
if [[ $gate -gt $NF ]]
then
	echo "ERROR: invalid input [TOO MANY ARGUMENTS], try again"
	main
fi

while [[ $v -ge 1 && $v -le $gate ]]
do
	validator=`echo $f | cut -d- -f$v`
	if [[ $validator -ge 1 && $validator -le $gate ]]
	then
		buf=$validator
		if [[ $v -eq 1 ]]
		then
			rec=$buf
		else
			rec="$rec-$buf"
		fi

		for o in "${arr[@]}"
		do
			if [[ $o -eq $buf ]]
			then
				echo "ERROR: invalid input [REPEATED FIELD(S)], try again"
				main
			fi
		done
		arr[$v]=$buf

	else
		echo "ERROR: invalid input [NO SUCH FIELD(S)], try again"
		main
	fi
	
	v=$v+1
done

fields=$rec
viewCombination

}



function viewField
{


echo "search with: "

while [[ $i -le $NF ]]
do
	echo "$i ) `echo $cl | cut -d: -f$i`"
	i=$i+1
done

read c


if [[ $c -ge 1 && $c -le $NF ]]
then
	col=`echo $cl | cut -d: -f$c`


	read -p "keyword: " w

	while [ $y -le $ln ]
	do
		match=`cat $tablePATH | head -$y | tail -1 | cut -d: -f$c`
		if [[ $match = $w ]]
		then
			viewer=`cat $tablePATH | head -$y | tail -1 | cut -d: -f$f`
			if [[ $firCol -eq 1 ]]
			then
				echo "`cat $tablePATH | head -2 | tail -1 | cut -d: -f$f`"
				firCol=0
			fi
			echo $viewer
			viw=$viw+1
		fi
		y=$y+1
	done

	if [ $viw -eq 0 ]
	then
		echo "ERROR: No match found, try again"
		main
	else
		echo $viw "Record(s) matched"
	fi
else
	echo "ERROR: invalid, try again"
	viewField
fi
}



function viewAll
{

	lnA=$ln-1
	cat $tablePATH | tail -$lnA
	lnA=$lnA-1
	echo $lnA "Record(s) retreived successfully"

}

#############incomplete##############
function viewCombination
{
	##A string variable called $fields holds user input after validation (example: 3-5-2-4)
	echo "working"
	##Viewer code goes here##
}
#############incomplete##############



function viewRecord
{
	

echo "search with: "

while [ $i -le $NF ]
do
	echo "$i ) `echo $cl | cut -d: -f$i`"
	i=$i+1
done

read c


if [[ $c -ge 1 && $c -le $NF ]]
then
	col=`echo $cl | cut -d: -f$c`

	read -p "keyword: " w

	while [ $y -le $ln ]
	do
		match=`cat $tablePATH | head -$y | tail -1 | cut -d: -f$c`
		if [[ $match = $w ]]
		then
			viewer=`cat $tablePATH | head -$y | tail -1`
			if [[ $firCol -eq 1 ]]
			then
				echo "`cat $tablePATH | head -2 | tail -1`"
				firCol=0
			fi
			echo $viewer
			viw=$viw+1
		fi
		y=$y+1
	done

	if [ $viw -eq 0 ]
	then
		echo "ERROR: No match found, try again"
		main
	else
		echo $viw "Record(s) matched"
	fi
else
	echo "ERROR: invalid, try again"
	viewRecord
fi
}



function main
{
	arr=()
	rec=""
	buf=""
	firCol=1
	i=1
	y=3
	viw=0
	ln=`cat $tablePATH | wc -l`

	echo "which column(s) do you want to view ?"
	while [ $i -le $NF ]
	do
		echo "$i ) `echo $cl | cut -d: -f$i`"
		i=$i+1
	done
		echo "- ) combination of columns"
		echo "* ) all columns"
		echo "# ) all table"
	i=1

	read -p "for spesific column(s) insert num of fields separated with - example(n-n / n-n-n): " f


	#if [[ $f = [1-$NF] ]]
	#then
	#	viewField
	#elif [[ $f = "#" ]]
	##then
	#	viewAll
	#elif [[ $f = "*" ]]
	#then
	#	viewRecord
	#elif [[ $f = +([1-$NF]*"-"[1-$NF]) ]]	
	#then
		viewSpecific
	#else
	#	echo "ERROR: invalid input [NO SUCH FIELD(S)], try again"
	#	main
	#fi

	read -p "Enter any key to select new data or x to exit: " reselect
	if [[ $reselect != x ]]
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
		source ./selectFromTable.sh
	else
		source ./menu
	fi
fi  
