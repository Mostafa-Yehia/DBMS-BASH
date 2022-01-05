#!/bin/bash
typeset -i authenticated=0
userPATH=~/bash-project-github/.DBpassword
read -p "User Name: " user
read -p "Password: " password
authenticated=$(awk -F: -v user=$user -v password=$password '{if($1==user && $2==password){print 1}}' $userPATH)
if [ $authenticated -eq 0 ]
then
	echo "Authentication Faliure"
	pkill "./menu"
else
	source ./menu
fi
