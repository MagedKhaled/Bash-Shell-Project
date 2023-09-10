#!/bin/bash

function createtable {
    description="./description"
    read -p "Please enter the table name to create: " table
    if [[ -f "./tables/$table" ]]; then
        echo "This table already exists. Please try again."
        read -p "press enter to continue: " _
        createtable
    else
        if ! [[ $table =~ ^[a-z|A-Z] ]]; then
            echo "invalid input. Please try again."
            read -p "press enter to continue" _
            createtable
        fi
        touch "./tables/$table" 
        echo "Table created successfully."

        num='^[0-9]+$'

        read -p "Enter the number of columns: " columns
        while true
        do
           if [[ -z $columns|| $columns == *" "* || ! $columns =~ $num ]];then
                echo "column number can not by empty or spaces and only numbers accepted, try again"
                read -p "Enter the number of columns: " columns
            else
                break
            fi
                done
            echo -e "You are going to create your table."
            echo -e "\t=======================CAUTION============================== \t"
            echo -e "\t TO AVOID ERRORS, YOUR FIRST COLUMN WILL BE PK FOR THIS TABLE\t"
            echo -e "\t=======================CAUTION============================== \t"

            for ((i = 1; i <= $columns; i++)); do

                read -p "Enter the name of column number $i: " colname
                while true
                do
                    if [[ -z $colname || $colname == *" "* || $colname =~ $num  ]] ;
                        then
                        echo "column name can not by empty or spaces or number, try again"
                        read -p "Enter the name of column number $i: " colname
                    else
                        break
                    fi
                done


                while grep -q "$table $colname" "$description";
                do
                    echo "This column already exists. Please try again."
                    read -p "Enter the name of column number $i: " colname
                done


                PS3="Select an option (enter the number): "

                
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
    
    fi
}


