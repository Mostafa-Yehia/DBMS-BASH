#!/bin/bash
clear
typeset -i n=0
typeset -i j=1
typeset -i k=0
typeset -i matches=0
typeset -i cont=1
echo "enter table name"
read tblName
while [ $cont -eq 1 ]
do
if [ -f $tblPATH/$tblName ]
then
	echo "update $tblName using:"
    awk -F: 'BEGIN{i=1;str=""}{if (NR==2){while(i<=NF){str=i") "$i;print str;i++;}}}' $tblPATH/$tblName
	#awk -F: 'BEGIN{printf "enter key to search with: ";getline key<"-";printf "enter value: ";getline keyVal<"-";printf "enter key to update: ";getline updatedCol<"-";printf "enter new value to insert: ";getline newVal<"-";} (NR==1){updatedColDatatype=$updatedCol} gsub($updatedCol, newVal){if($key==keyVal) {str=$0}}(updatedColDatatype="text") {print str}' $tblPATH/$tblName 
	n=`awk -F: 'END{print NF}' $tblPATH/$tblName`
	typeset newRecord[$n]
    typeset oldRecord[$n]
	echo "enter key to search with: "
	read key
	if [ $key -le $n ]
	then
		echo "enter value: "
		read keyVal
		matches=`cut -d: -f$key $tblPATH/$tblName | grep -c $keyVal` 
		if [ $matches -ne 0 ]
		then  
			echo "enter key to update: "
			read updatedCol
			updatedColDatatype=`cut -d: -f$updatedCol $tblPATH/$tblName | head -1`
			if [[ $updatedColDatatype = serial ]]
			then
				echo "Can't Update serial key"
			else
				if [ $updatedCol -le $n  ]
				then
					echo "enter new value to insert: "
					read newVal
					PKmatch=`cut -d: -f1 $tblPATH/$tblName | grep "$newVal" | wc -l`
					if [ $updatedCol -eq 1 -a $PKmatch -ne 0 ] 
					then
						echo "Duplicate entry ($newVal) for key ($tblName.PRIMARY)"
					else	
					    #y=($(awk -F: -v key=$key -v keyVal=$keyVal '{if($key==keyVal) {print $0}}' $tblPATH/$tblName))
						#echo $y
						#input validation
						#oldRecord=($(awk -F: -v key=$key -v keyVal=$keyVal 'BEGIN{FS=":";RS="\n";OFS=":";}{if($key==keyVal) {print $0}}' $tblPATH/$tblName))
						#newRecord=($(awk -F: -v key=$key -v keyVal="$keyVal" -v updatedCol=$updatedCol -v newVal="$newVal" 'BEGIN{FS=":";RS="\n";OFS=":";}gsub($updatedCol, newVal){if($key==keyVal) {print $0}}' $tblPATH/$tblName))
						awk -F: -v key=$key -v keyVal=$keyVal -v updatedCol=$updatedCol -v newVal=$newVal -v path=$tblPATH/$tblName 'BEGIN{OFS=":"}gsub($updatedCol, newVal, $updatedCol){if($key==keyVal) { print $0 >> path }}' $tblPATH/$tblName
						#j=${#newRecord[@]}
						#echo $j
						#while [ $k -lt $j ]
						#do
						#	sed -i "s/${oldRecord[$k]}/${newRecord[$k]}/g" $tblPATH/$tblName 
						#	k=$k+1
						#done	
						#echo ${oldRecord[0]}
						#echo ${#newRecord[@]}
						#echo ${newRecord[0]}
						#echo "Rows matched: $matches  Changed: "
					fi	
				else
					echo "invalid Key"
				fi
			fi	
		else
			echo "No Matched records"
		fi	
	else
		echo "invalid Key"

	fi	
else 
	echo "No such Table"
fi
select x in "Update" "Back"  
do
	case $x in
		"Update") cont=1 break;;
		"Back") cont=0 break;;
        esac
done
done




