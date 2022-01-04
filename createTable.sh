#!/bin/bash
clear
typeset columns=""
typeset dataTypes=""
echo "enter table name"
read tblName
if [[ $tblName != +([a-zA-Z]*[a-zA-Z0-9_]) ]]  
then
    echo "file name can not contain numbers nor special characters"
	sleep 2
	source ./createTable.sh
elif [[ $tblName == *" "* ]]
then
	echo "file name can not contain spaces"
	sleep 2
	source ./createTable.sh
else	
	if [ -f $tblPATH/$tblName ]
	then
		echo "table already  exists"
		sleep 2
		source ./createTable.sh
	else
		
		touch $tblPATH/$tblName
		echo "enter no of columns"
		read n
		typeset -i i=1
		echo "enter primary key"
			read PK
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
					esac
					
			done		 
			
		while [ $i -lt $n ]
		do
			#echo "enter columns in this format [column-name] [datatype]"
			echo "enter column name"
			read column
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
					esac		
			done		
			i=$i+1;
		done
	fi
fi	
echo $dataTypes >> $tblPATH/$tblName
echo $columns >> $tblPATH/$tblName
