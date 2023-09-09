#!/bin/bash

function createtable {
    clear
    description="./description"
    read -p "Please enter the table name to create: " table
    if [[ -e "./tables/$table" ]]; then
        echo "This table already exists. Please try again."
        read "press enter to continue"
        createtable
    else
        if ! [[ $table =~ ^[a-z|A-Z] ]]; then
            echo "invalid input. Please try again."
            read "press enter to continue"
            createtable
        fi
        touch "./tables/$table"  ##====change it
        echo "Table created successfully."
        read -p "Enter the number of columns: " columns
        num='^[0-9]+$'
        if [[ $columns =~ $num ]]; then
            echo -e "You are going to create your table."
            echo -e "\t===================CAUTION================================= \t"
            echo -e "\t TO AVOID ERRORS, YOUR FIRST COLUMN WILL BE PK FOR THIS TABLE\t"
            echo -e "\t===================CAUTION================================= \t"

            for ((i = 1; i <= $columns; i++)); do
                read -p "Enter the name of column number $i: " colname

                while grep -q "$table $colname" "$description";
                	do
                    echo "This column already exists. Please try again."
                    read -p "Enter the name of column number $i: " colname
                done

                select choice in "integer" "text"; do
                    case $REPLY in
                    1) type="int"; break ;;
                    2) type="text"; break ;;
                    *) echo "Wrong choice. Try again." ;;
                    esac
                done

                if [ $i -eq 1 ]; then
                    echo "$table $colname│$type│1│PK" >> $description
                    echo -n "$colname│" >> "./tables/$table" #change

                    
                else
                    echo "$table $colname│$type│$i│" >> $description
                    echo -n "$colname│" >> "./tables/$table" #change
                fi
            done
            echo "" >> "./tables/$table" #change
            echo -e "\tTable '$table' created successfully."
        else
            echo "Invalid input. Please enter a valid number of columns."
        fi
    fi
}


