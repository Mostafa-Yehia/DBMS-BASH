#!/bin/bash
clear
typeset -i backFlag=1
read -p "enter table name: " tblName
if [ -f $tblPATH/$tblName ]
then
	read -p "Are you sure you want to delete $tblName table (y/n): " x
    if [[ $x == 'y' || $x == 'Y' ]]
    then	       
		rm $tblPATH/$tblName
		echo "Table Successfully deleted"
	else 
		source ./dropTBL.sh
	fi	
else
	echo "No Such File"
fi
source ./connectToDB.sh $backFlag
