#!/bin/bash

function checkcolumn {
    while true; do    
        echo -e "Enter column name from the following:\n"
        echo $(grep "$tableConnectedName" "description" | awk -F '│' '{print $1}' | cut -d' ' -f2)

        read colname
        if grep -q "$colname" "description"; then
            break
        else
            clear
            echo "The column name is not valid, try again."
        fi
    done
    colname="$colname"  # Store the column name as a local variable
    clear
}

function checkrow {

    while true; do
        pk=$(grep "$tableConnectedName" "description" | head -1 | awk -F '│' '{print $1}' | cut -d' ' -f2)
        read -p "Enter the primary key [ $pk ] value for the row you want to show: " value
        if grep -q "$value" "$table"; then
            break
        else
            echo "The value does not exist, try again."
        fi
    done
    value="$value"  # Store the value as a local variable
}

function selection {
    PS3="Select an option (enter the number): "

    clear
    listOfTB=$(ls ./tables)
    echo -e 'Available Tables: \n\n'
    getDB $listOfTB
    echo -e '\n'
    listOfTB=($listOfTB) 
    numOfTB=${#listOfTB[@]}
    if [ $numOfTB -gt 0 ]; then
        read -ep 'Enter The Number Of Table To select from: ' inp
        clear
        
        if [[ $inp =~ [1-9] ]] && [ $inp -le $numOfTB ] && [ $inp -gt 0 ]; then
            tableConnectedName=${listOfTB[(($inp-1))]}
            table='./tables/'$tableConnectedName
        else
            echo "Invalid Input"
        fi
    else
        echo "No Tables To Connect"
    fi  

    echo "Choose what you want to select from $tableConnectedName:"
    while true
    do
    select choice in "All data of table" "one column" "one row" "one value" "exit selection";
    do
        clear
        case $REPLY in
            1)  clear;
                cat "$table"
                break;;
            2)  clear;
                checkcolumn
                awk -F '│' -v colname="$colname" 'NR==1 { for(i=1; i<=NF; i++) if($i == colname) colidx=i } { print $colidx }' "$table"
                break;;
            3)  clear;
                checkrow
                echo "$(head -1 "$table")"
                echo "================================================"
                awk -v value="$value" -F'│' '$1 == value {print}' "$table"
                break;;
            4)  clear;
                checkcolumn
                checkrow
                echo "$(awk -F "│" 'NR==1 {print $1}' $table)│$colname"
                echo "================================================"
                awk -F '│' -v id="$value" -v colname="$colname" 'NR==1 { for(i=1; i<=NF; i++) if($i == colname) colidx=i } $1 == id { print $1 "|" $colidx }' "$table"
                break;;
            5)  clear;
                break 2
                tableActions
                ;;
            *)  echo "Wrong choice"
                break;;
            
        esac       
    done
    read -p "press enter to continue" _
    clear
    done
}
