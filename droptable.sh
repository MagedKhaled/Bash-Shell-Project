#!/bin/bash

function droptable {
    while true; do
        echo -e "Choose which table do you want to delete from the following or quit: \n"
        tables=$(ls ./tables)
        PS3="Select a table to delete or quit: "
        select table in $tables "Quit"; do
        
            case $table in
                "Quit")
                    echo "Exiting..."
                    #########
                    break 2
                     tableActions
                    ;;
                *)
                    if [[ -f "./tables/$table" ]]; then
                        if [[ -s "./tables/$table"  ]]; then
                            while true; do
                                read -p "This table is not empty, are you sure to delete it [y/n]: " answer
                                if [[ $answer == "Y" || $answer == "y" ]]; then
                                    rm "./tables/$table" 
                                    awk -v table="$table"  '$1 != table' "description" > temp_file && mv temp_file "description"
                                    echo "Table '$table' has been deleted."
                                    break
                                elif [[ $answer == "n" || $answer == "N" ]]; then
                                    echo "Table deletion cancelled."
                                    break
                                else
                                    echo "Wrong answer, please try again."
                                fi
                            done
                        else
                            rm "./tables/$table" 
                            awk -v table="$table" '$1 != table' "description" > temp_file && mv temp_file "description"
                            echo "Table '$table' has been deleted."
                        fi
                    else
                        echo "This table does not exist, try again."
                    fi
                    break
                    ;;
            esac
        done
    done
}


