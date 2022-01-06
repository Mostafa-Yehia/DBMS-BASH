#!/bin/bash
clear
typeset columns=""
typeset dataTypes=""
typeset -i s
typeset -i errorType=0

errorType=0

function errorHandler
{

if [[ $errorType -eq 1 ]]
then
	read -p "ERROR: table name can NOT contain numbers nor special characters, enter any key to try again or x to Back: " recreate
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
	if [ -f $dbPATH/$tblName ]
	then
		errorType=3
		errorHandler
	else	
		touch $dbPATH/$tblName
		read -p "enter number of columns: " n
		typeset -i i=1
		read -p "enter primary key name: " PK
		columns="$PK"
		echo "select column datatype"
		select datatype in "int" "serial" "text" 
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
					*) echo "ERROR: invalid input, try again";;
				esac
				
		done		 
			
		while [[ $i -lt $n ]]
		do
			s=$i+1
			read -p "enter column #"$s" name: " column
			columns="$columns:$column"	
			select datatype in "int" "serial" "text" 
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
						*) echo "ERROR: invalid input, try again";;
					esac		
			done		
			i=$i+1;
		done
	fi
fi	
echo $dataTypes >> $dbPATH/$tblName
echo $columns >> $dbPATH/$tblName

echo "table $tblName was created successfully"
		select x in "Create New Table" "Back"
		do
			case $x in 
				"Create New Table") source ./createTable.sh
					;;
				"Back") source ./connectToDB.sh 1
					;;
				*) echo "ERROR: invalid input, try again"
					;;
			esac
		done
