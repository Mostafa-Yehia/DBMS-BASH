#!/bin/bash
typeset -i FLAG=$1
if [[ $FLAG -ne 1 ]]
then
	clear
	read -p "enter DB name: " DB
fi

if [ -d $dbsPATH/$DB ]
then
dbPATH=$dbsPATH/$DB
select x in "Create Table" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "List Tables" "Back"
do
	case $x in
        	"Create Table") source ./createTable.sh
            		;;
		"Drop Table") source ./dropTBL.sh
			;;
		"Insert into Table") source ./insertToTable.sh
			;;
		"Select From Table") source ./selectFromTable.sh
			;;
		"Delete From Table") source ./deleteFromTable.sh
			;;
		"Update Table") source ./updateTable.sh
			;;
        	"List Tables") source ./listTbl.sh
			;;
        	"Back") source ./menu
			;;
		*) echo "ERROR: invalid input, try again"
			;;
	esac
done
else
	echo "ERROR: No such database, enter any key to try again or x to Back"
	read reconnect
	if [[ $reconnect != x ]]
	then
		source ./connectToDB.sh
	else
		source ./menu
	fi
fi
