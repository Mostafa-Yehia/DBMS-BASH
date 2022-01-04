#!/bin/bash
clear
echo "enter database name: " 
read DBdir
if [[ $DBdir != +([a-zA-Z]*[a-zA-Z0-9_]) ]]  
then
    echo "database name can not contain numbers nor special characters"
	sleep 2
	source ./createDB.sh
elif [[ $DBdir == *" "* ]]
then
	echo "database name can not contain spaces"
	sleep 2
	source ./createDB.sh
else		
	if [ -d $dbPATH/$DBdir ]
	then
		echo "Database already exists"
		echo "press any key to try again"
		read 
		source ./createDB.sh
	else
		mkdir $dbPATH/$DBdir
		tblPATH=$dbPATH/$DBdir
		select x in "Create Table" "Exit"
		do
			case $x in 
				"Create Table") source ./createTable.sh
				;;
				"Exit") source ./menu
				;;
				*) echo "Not an Option";;
			esac
		done
	fi
fi

