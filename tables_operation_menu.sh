#!/bin/bash

source main_menu_functions.sh
source createtable.sh
source insert_into_DB.sh
source select.sh
source updateTable.sh
source droptable.sh
source deletefromtable.sh



function tableActions {
    while true 
    do
        echo '1)Create Table'
        echo '2)List Tables'
        echo '3)Drop Table'
        echo '4)Insert Into Table'
        echo '5)Select From Table'
        echo '6)Delet From Table'
        echo '7)Update Table'
        echo '8)Exit'


        read -p "Make Your Choice: " inp
        case $inp in 
            1) clear;createtable ;;
            2) clear;listTB ;;
            3) clear;droptable ;;
            4) clear;insertTB ;;
            5) clear;selection ;;
            6) clear;deletefromtable ;;
            7) clear;updateTB ;;
            8) cd ../../; break;;
            *) echo Invalid Choice ;;

        esac

        read -p "Press Enter To Continue " inp
        clear
    done

}



function connecteDB(){
    echo -e 'Available Databases: \n\n'
    listOfDB=$(ls ./databases)
    getDB $listOfDB
    echo -e '\n'

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

tableActions

}
