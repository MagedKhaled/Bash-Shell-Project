#!/bin/bash

function checkcolumn {
    while true; do
        echo "Enter column name from the following:"
        echo $(grep "$table" "description" | awk -F '│' '{print $1}' | cut -d' ' -f2)

        read colname
        if grep -q "$colname" "description"; then
            break
        else
            echo "The column name is not valid, try again."
        fi
    done
    export "$table"="$colname"
}

function checkrow {
    while true; do
        pk=$(grep "$table" "description" | head -1 | awk -F '│' '{print $1}' | cut -d' ' -f2)
        read -p "Enter the primary key [ $pk ] value for the row you want to show: " value
        if grep -q "$value" "$table"; then
            break
        else
            echo "The value does not exist, try again."
        fi
    done
    export "$table"="$value"
}



function selection {
    echo "Choose the table you want to select from:"
    echo $(ls | grep -v "description")
    read table
    while [[ ! -f $table ]]; do
        echo "This table does not exist, try again."
        read table
    done

    echo "Choose what you want to select from $table:"
    select choice in "All data of table" "one column" "one row" "one value" "exit selection";
     do
        case $REPLY in
            1)
                cat "$table"
                ;;
            2)
                checkcolumn
                awk -F '│' -v colname="$colname" 'NR==1 { for(i=1; i<=NF; i++) if($i == colname) 	colidx=i } { print $colidx }' "$table"
                ;;
            3)
                checkrow
                echo "$(head -1 "$table")"
                echo"================================================="
                awk -v value="$value" -F'│' '$1 == value {print}' "$table"

                ;;
            4)
          	checkcolumn
                checkrow	
                echo "$(awk -F "│" 'NR==1 {print $1}' $table)│$colname"
                echo "================================================"
		awk -F '│' -v id="$value" -v colname="$colname" 'NR==1 { for(i=1; i<=NF; i++) if($i == colname) colidx=i } $1 == id { print $1 "|" $colidx }' "$table"
                ;;
            5)
                exit
                ;;
                
            *) echo "wronge choice"
                ;;
        esac
    done
}

selection

