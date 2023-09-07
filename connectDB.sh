#!/bin/bash

source ddl_functions.sh
source createtable.sh



function connecteDB(){
    listOfDB=$(ls ./databases)
    getDB $listOfDB
    listOfDB=($listOfDB) 
    numOfDB=${#listOfDB[@]}
    if [ $numOfDB -gt 0 ]; then
        read -p 'Enter The Number Of Database To Connect: ' inp
        
        if [[ $inp =~ [1-9] ]] && [ $inp -le $numOfDB ] && [ $inp -gt 0 ]; then
            databaseConnected=${listOfDB[(($inp-1))]}
            databaseConnected='./databases/'$databaseConnected
            echo $databaseConnected
        else
            echo "Invalide Input"
        fi
    else
        echo "No Database To Connect"
    fi    

    clear
    cd $databaseConnected

    while true 
    do
        echo '1)Create Table'
        echo '2)List Tables'
        echo '3)Drop Table'
        echo '4)Insert Inot Table'
        echo '5)Select From Table'
        echo '6)Delet From Table'
        echo '7)Update Table'
        echo '8)Exit'


        read -p "Make Your Choice: " inp
        case $inp in 
            1) createtable ;;
            2) echo List Tables ;;
            3) echo Drop Table ;;
            4) echo Insert Inot Table ;;
            5) echo Select From Table ;;
            6) echo Delet From Table ;;
            7) echo Update Table ;;
            8) break ;;
            *) echo Invalid Choice ;;

        esac

        read -p "Press Enter To Continue " inp
        clear
    done
}