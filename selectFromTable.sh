#!/bin/bash
clear
typeset -i firCol
typeset -i v
typeset -i validator
typeset -i ln
typeset -i lnA
typeset -i NF
typeset -i matches
typeset -i i=1
typeset -i y=3
typeset -i viw=0
declare -a arr
tblPATH=""
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
hdr=""
header=""

gate=`echo $f | awk -F- 'END {print NF}'`
if [[ $gate -gt $NF ]]
then
	echo "ERROR: invalid input [TOO MANY ARGUMENTS], try again"
	main
fi

while [[ $v -ge 1 && $v -le $gate ]]
do
	validator=`echo $f | cut -d- -f$v`
	if [[ $validator -ge 1 && $validator -le $NF ]]
	then
		buf=$validator
		if [[ $v -eq 1 ]]
		then
			rec=$buf

			header=`cat $tblPATH | head -2 | tail -1 | cut -d: -f$buf`
			hdr=$header
		else
			rec="$rec-$buf"

			header=`cat $tblPATH | head -2 | tail -1 | cut -d: -f$buf`
			hdr="$hdr:$header"
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


if [[ $c -le 0 && $c -gt $NF ]]
then
	echo "ERROR: invalid input [NO SUCH FIELD(S)], try again"
	main
fi



if [[ $c -ge 1 && $c -le $NF ]]
then
	col=`echo $cl | cut -d: -f$c`


	read -p "keyword: " w

	while [ $y -le $ln ]
	do
		match=`cat $tblPATH | head -$y | tail -1 | cut -d: -f$c`
		if [[ $match = $w ]]
		then
			viewer=`cat $tblPATH | head -$y | tail -1 | cut -d: -f$f`
			if [[ $firCol -eq 1 ]]
			then
				echo "`cat $tblPATH | head -2 | tail -1 | cut -d: -f$f`"
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
	cat $tblPATH | tail -$lnA
	lnA=$lnA-1
	echo $lnA "Record(s) retreived successfully"

}

#completed#
function viewCombination
{
	awk -F: 'BEGIN{i=1;str=""}{if (NR==2){while(i<=NF){str=i") "$i;print str;i++;}}}' $dbPATH/$tblName
	read -p "enter key to select with:  " key
	if [[ $key -ge 0 && $key -le $NF ]]
	then
		read -p "enter value: " keyVal
		matches=`cut -d: -f$key $tblPATH | grep -c $keyVal` 
		if [[ $matches -ne 0 ]]
		then
			echo $hdr
			while [[ $y -ge 1 && $y -le $ln ]]
			do
				match=`cat $tblPATH | head -$y | tail -1 | cut -d: -f$key`
				if [[ $match = $keyVal ]]
				then
						for o in "${arr[@]}"
						do
							buf=`cat $tblPATH | head -$y | tail -1 | cut -d: -f$o`
							if [[ $firCol -eq 1 ]]
							then
								viewer=$buf
								firCol=0
							else
								viewer="$viewer:$buf"
							fi
						done
						echo $viewer
						firCol=1
				fi
				y=$y+1
			done
			echo $matches "Record(s) matched"
		else
			echo "ERROR: No match found, try again"
			main
		fi
	else
		echo "ERROR: invalid input [NO SUCH FIELD(S)], try again"
		main
	fi
}
#completed#



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
		match=`cat $tblPATH | head -$y | tail -1 | cut -d: -f$c`
		if [[ $match = $w ]]
		then
			viewer=`cat $tblPATH | head -$y | tail -1`
			if [[ $firCol -eq 1 ]]
			then
				echo "`cat $tblPATH | head -2 | tail -1`"
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
	ln=`cat $tblPATH | wc -l`

	echo "which column(s) do you want to view ?"
	while [ $i -le $NF ]
	do
		echo "$i ) `echo $cl | cut -d: -f$i`"
		i=$i+1
	done
		echo "- ) combination of columns"
		echo "* ) all columns"
		echo "# ) all table"
		echo "x ) Back"
	i=1

	read -p "for combination of columns insert num of columns separated with - example(n-n / n-n-n): " f


	if [[ $f = [1-$NF] ]]
	then
		viewField
	elif [[ $f = "#" ]]
	then
		viewAll
	elif [[ $f = "*" ]]
	then
		viewRecord
	elif [[ $f = +([1-$NF]*"-"[1-$NF]) ]]	
	then
		viewSpecific
	elif [[ $f = "x" ]]
	then
		source ./connectToDB.sh 1
	else
		echo "ERROR: invalid input [NO SUCH FIELD(S)], try again"
		main
	fi

	read -p "Enter any key to select new data or x to Back: " reselect
	if [[ $reselect != x ]]
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
		source ./selectFromTable.sh
	else
		source ./connectToDB.sh 1
	fi
fi  	
