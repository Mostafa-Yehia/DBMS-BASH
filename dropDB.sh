#!/bin/bash
clear
read -p "enter database name: " DB
if [ -d $dbsPATH/$DB ]
then
	rm -r $dbsPATH/$DB
	echo "Database Successfully deleted"
else
	echo "ERROR: No Such Database"
fi
select x in "Drop DataBase" "Back"
do
	case $x in
		"Drop DataBase") source ./dropDB.sh
				;;
		"Back") source ./menu
				;;
		*) echo "Not an Option";;
	esac
done
