#!/bin/bash
clear
typeset -i v
typeset -i ln
typeset -i NF
typeset -i i=1
typeset -i y=3
typeset -i viw=0
tablePATH=""
cl=""
col=""
fields=""
field=""
match=""
viewer=""


function viewSpecific
{

v=1
rec=""
buf=""
while [[ $v -eq 1 && $v -le $NF ]]
do
	validator=`echo $f | cut -d- f$v`
	if [[ $validator -ge 1 && $validator -le $NF ]]
	then
		if [[ $v -eq 1 ]]
		then
			rec=$buf
		else
			rec="$rec-$buf"
		fi
	else
		echo "invalid input, try again"
		validator
	fi

	v=$v+1
	
	if [[ $v -gt $NF ]]
	then
		viewSpecific
	fi

done

}


function validator
{




}


function viewAll
{

	ln=`cat $tablePATH | wc -l`
	ln=$ln-1
	cat $tablePATH | tail -$ln
	ln=$ln-1
	echo $ln "Record(s) retreived successfully"

}


#function viewSpesific
#{

##}




function viewRecord
{


echo "search with: "

while [ $i -le $NF ]
do
	echo "$i ) `echo $cl | cut -d: -f$i`"
	i=$i+1
done

read c

if [[ $c -le 0 ]]
then
	echo "invalid, try again"
	viewRecord
fi

if [[ $c -le $NF ]]
then
	col=`echo $cl | cut -d: -f$c`

	echo "keyword: "

	read w

	while [ $y -le $ln ]
	do
		match=`cat $tablePATH | head -$y | tail -1 | cut -d: -f$c`
		if [[ $match = $w ]]
		then
			viewer=`cat $tablePATH | head -$y | tail -1`
			echo $viewer
			viw=$viw+1
		fi
		y=$y+1
	done

	if [ $viw -eq 0 ]
	then
		echo "no match found"
	else
		echo $viw "Record(s) matched"
	fi
fi
}



function main
{

	i=1
	y=3
	viw=0

	echo "which column(s) do you want to view ?"
	while [ $i -le $NF ]
	do
		echo "$i ) `echo $cl | cut -d: -f$i`"
		i=$i+1
	done
		echo "- ) combination of columns"
		echo "* ) all record"
		echo "# ) all table"

	echo "for spesific column(s) insert num of fields separated with - example(n or n-n-n..)"

	read f
	fields=$f

	if [[ $f = "#" ]]
	then
		viewAll
	elif [[ $f = "*" ]]
	then
		viewRecord
	elif [[ $f = "-" ]]
	then
		viewSpesific
	elif [[ $f = [1-$NF] ]]
	then
		validator
	else
		echo "invalid input, try agian"
		main
	fi

}




echo "enter table name"
read tblName
tablePATH="$tblPATH/$tblName"
if [ -f $tablePATH ]
then   

	cl=`cat $tablePATH | head -2 | tail -1`
	ln=`cat $tablePATH | wc -l`
	NF=`awk -F: 'END{print NF}' $tablePATH`

	main


else
	echo "No such table, enter any key to try again or x to exit"
	read again
	if [[ $again != x ]]
	then
		source ./selectFromTable.sh
	else
		source ./menu
	fi
fi  
