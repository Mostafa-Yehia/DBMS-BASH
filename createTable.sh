#!/bin/bash
clear
typeset columns=""
typeset dataTypes=""
typeset -i errorType=0
typeset -i goodA
typeset -i goodB
typeset -i goodC
typeset -i i=1
typeset -i s=2
typeset -i duplicated
declare -a arr=()

function cleaner
{


if [[ -f $dbPATH/$tblName ]]
then
	tblchkr=`cat $dbPATH/$tblName | wc -l`

	if [[ $tblchkr -eq 2 ]]
	then
		echo "table $tblName was created successfully"
	else
		echo "table $tblName could NOT be created, contact admin/developer for support"
		`rm $dbPATH/$tblName`
	fi
fi

}


errorType=0

function errorHandler
{

if [[ $errorType -eq 1 ]]
then
	read -p "ERROR: table name can NOT start with numbers nor contain special characters, enter any key to try again or x to Back: " recreate
elif [[ $errorType -eq 2 ]]
then
	read -p "ERROR: table name can not contain spaces, enter any key to try again or x to Back: " recreate
elif [[ $errorType -eq 3 ]]
then
	read -p "ERROR: table already exists, enter any key to try again or x to Back: " recreate
fi


if [[ $recreate != x ]]
then
	source ./createTable.sh
else
	cleaner
	source ./connectToDB.sh 1
fi

}

read -p "enter table name: " tblName
if [[ $tblName != +([a-zA-Z]*[a-zA-Z0-9_]) ]]  
then
	errorType=1
	errorHandler
elif [[ $tblName == *" "* ]]
then
	errorType=2
	errorHandler
else		
	if [[ -f $dbPATH/$tblName ]]
	then
		errorType=3
		errorHandler
	fi
fi

touch $dbPATH/$tblName


goodA=1
while [[ -f $dbPATH/$tblName && $goodA -eq 1 ]]
do
	read -p "enter number of columns: " n
	if [[ $n != +([2-9]) ]]
	then
		read -p "ERROR: must be number [2-9], enter any key to try again or x to Back: " recreate
		if [[ $recreate != x ]]
		then
			continue
		else
			cleaner
			source ./connectToDB.sh 1
		fi
	else
		goodA=0
	fi
done



goodB=1
while [[ $goodB -eq 1 ]]
do
	read -p "enter primary key name: " PK
	if [[ $PK != +([a-zA-Z]*[a-zA-Z0-9_]) || $PK = *" "* ]]
	then
		read -p "ERROR: can NOT start with numbers nor contain special characters/spaces, enter any key to try again or x to Back: " recreate
		if [[ $recreate != x ]]
		then
			continue
		else
			cleaner
			source ./connectToDB.sh 1
		fi
	else
		goodB=0
		arr[1]=$PK
		columns="$PK"	
	fi
done


		
echo "select column datatype"
select datatype in "int" "serial" "text" "ignore & exit"
do
		case $datatype in
			"int") 
			dataTypes="int"
			break
				;;
			"serial") 
			dataTypes="serial"
			break
				;;			
			"text") 
			dataTypes="text"
			break
				;;
			"ignore & exit")
			cleaner
			source ./connectToDB.sh 1;;
			*) echo "invalid input, try again"
		esac
		
done

 

goodC=1	
while [[ $i -lt $n ]]
do
duplicated=0
	read -p "enter column #"$s" name: " column

	if [[ $column != +([a-zA-Z]*[a-zA-Z0-9_]) || $column = *" "* ]]
	then		
		read -p "ERROR: can NOT start with numbers nor contain special characters/spaces, enter any key to try again or x to Back: " recreate
		if [[ $recreate != x ]]
		then
			continue
		else
			cleaner
			source ./connectToDB.sh 1
		fi
	else
		for j in "${arr[@]}"
		do
			if [[ $j = $column ]]
			then
				echo "ERROR: column name can NOT be duplicated, try again"
				duplicated=1
				break
			fi
		done
		if [[ $duplicated -eq 0 ]]
		then
			arr[$s]=$column
			goodC=0
			columns="$columns:$column"
		else
			continue
		fi
	fi
	
	echo "select column #"$s" datatype"
	select datatype in "int" "serial" "text" "ignore & exit"
	do
			case $datatype in
				"int") 
				dataTypes="$dataTypes:int"
				break
					;;
				"serial") 
				dataTypes="$dataTypes:serial"
				break
					;;			
				"text") 
				dataTypes="$dataTypes:text"
				break
					;;
				"ignore & exit")
				cleaner
				source ./connectToDB.sh 1;;
				*) echo "invalid input, try again"
			esac
			
	done	
	i=$i+1;
	s=$i+1
done


echo $dataTypes >> $dbPATH/$tblName
echo $columns >> $dbPATH/$tblName


select x in "Create New Table" "Back"
do
	case $x in 
		"Create New Table") source ./createTable.sh
			;;
		"Back")
		cleaner
		source ./connectToDB.sh 1
			;;
		*) echo "ERROR: invalid input, try again"
			;;
	esac
done
