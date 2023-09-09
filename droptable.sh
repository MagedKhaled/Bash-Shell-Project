#!/bin/bash

function droptable {
    while true; do
        echo "Choose which table do you want to delete from the following or quit:"
        tables=$(ls | grep -v "description")
        select table in $tables "Quit"; do
            case $table in
                "Quit")
                    echo "Exiting..."
                    exit 0
                    ;;
                *)
                    if [[ -f $table ]]; then
                        if [[ -s $table ]]; then
                            while true; do
                                read -p "This table is not empty, are you sure to delete it [y/n]: " answer
                                if [[ $answer == "Y" || $answer == "y" ]]; then
                                    rm "$table"
                                    awk -v table="$table" '$1 != table' "description" > temp_file && mv temp_file "description"
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
                            rm "$table"
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

droptable

