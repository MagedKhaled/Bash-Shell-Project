#!/bin/bash
source validation_functions.sh

function insertTB {
    clear
    listOfTB=$(ls ./tables)
    echo -e 'Available Tables: \n\n'
    getDB $listOfTB
    echo -e '\n'
    listOfTB=($listOfTB) 
    numOfTB=${#listOfTB[@]}
    if [ $numOfTB -gt 0 ]; then
        read -ep 'Enter The Number Of Table To Insert into: ' inp
        
        if [[ $inp =~ [1-9] ]] && [ $inp -le $numOfTB ] && [ $inp -gt 0 ]; then
            tableConnectedName=${listOfTB[(($inp-1))]}
            tableConnected='./tables/'$tableConnectedName
        else
            echo "Invalide Input"
        fi
    else
        echo "No Tables To Connect"
    fi  


    while true
    do
    clear
    cols=$(head -1 "$tableConnected")
    numberCol=$(echo "$cols" | grep -o '│' | wc -l)
    dataEnery=''
    for ((colNum = 1; colNum <= numberCol; colNum++)); do
        colName=$( awk -F'│' -v colNum="$colNum" '{print $colNum}' <<< "$cols" )
        read -p "Enter The Value Of $colName: " colValue
        checkValid "$tableConnectedName $colName" $colValue $tableConnected
        statu=$?
        if [ $statu -eq '1' ]; then
            dataEnery=$dataEnery$colValue'│'
            
        else 
            colNum=$colNum-1
            case "$statu" in 
                "11") echo Invalide data type;;
                "12") echo PK Can\'t be null;;
                "13") echo PK must be unique;;
            esac
        fi
    done
    echo $dataEnery >> $tableConnected;
    echo -e "\n\nThe record saved successfully.\n"
    read -p "Enter another value (y,n)? " inp
    if [ $inp = 'y' ] || [ $inp = 'Y' ]; then 
        continue;
    else  
        break;
    fi
    done
}

