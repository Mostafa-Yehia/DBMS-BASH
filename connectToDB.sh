#!/bin/bash
clear
echo "enter DB name"
read DB
if [ -d $dbPATH/$DB ]
then
tblPATH=$dbPATH/$DB
select x in "Create Table" "Drop Table" "Insert into Table" "Select From Table" "Delete From Table" "Update Table" "List Tables" "Exit"
do
	case $x in
        "Create Table") 
		source ./createTable.sh
            ;;
		"Drop Table") source ./dropTable.sh
			;;
		"Insert into Table") source ./insertToTable.sh
			;;
		"Select From Table") source ./selectFromTable.sh
			;;
		"Delete From Table")
			;;
		"Update Table") source ./updateTable.sh
			;;
        "List Tables") ls $dbPATH/$DB
			;;
        "Exit") source ./menu
            ;;
        *) echo "Not an Option"
		    ;;
	esac
done
else
	echo "No such database"
	sleep 2
	source ./connectToDB.sh
fi


