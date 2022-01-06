#!/bin/bash
clear
typeset -i errorType=0
errorType=0
function errorHandler
{
if [[ $errorType -eq 1 ]]
then
	read -p "ERROR: database name can NOT contain numbers nor special characters, enter any key to try again or x to Back" recreate
elif [[ $errorType -eq 2 ]]
then
	read -p "ERROR: database name can not contain spaces, enter any key to try again or x to Back" recreate
elif [[ $errorType -eq 3 ]]
then
	read -p "ERROR: database already exists, enter any key to try again or x to Back" recreate
fi
if [[ $recreate != x ]]
then
	source ./createDB.sh
else
	source ./menu
fi
}
read -p "enter database name: " DB
if [[ $DB != +([a-zA-Z]*[a-zA-Z0-9_]) ]]  
then
	errorType=1
	errorHandler
elif [[ $DB == *" "* ]]
then
	errorType=2
	errorHandler
else		
	if [ -d $dbsPATH/$DB ]
	then
		errorType=3
		errorHandler
	else
		mkdir $dbsPATH/$DB
		dbPATH=$dbsPATH/$DB
		echo "database $DB was created successfully"
		select x in "Create Table" "Back"
		do
			case $x in 
				"Create Table") source ./createTable.sh
					;;
				"Back") source ./menu
					;;
				*) echo "ERROR: invalid input, try again"
					;;
			esac
		done
	fi
fi
