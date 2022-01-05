#!/bin/bash
clear
read -p "enter database name: " DBdir
if [ -d $dbPATH/$DBdir ]
then
	rm -r $dbPATH/$DBdir
	echo "Database Successfully deleted"
else
	echo "No Such Database"
fi
select x in "Drop DataBase" "Exit"
do
	case $x in
		"Drop DataBase") source ./dropDB.sh
				;;
		"Exit") source ./menu
				;;
		*) echo "Not an Option";;
	esac
done
