#!/bin/bash
function deletefromtable {
    while true; do
        PS3="Select a table to delete from or quit: "
        select table in $(ls "./tables") "Quit"; do
            case $table in
                "Quit")
                    clear ;
                    echo "Going back"
                    tableActions
                    return
                    ;;
                *)
                    if [[ -f "./tables/$table" ]]; then
                        if [[ -s "./tables/$table" ]]; then
                            clear
                            PS3="Select an action: "
                            select action in "Delete all from table" "Delete row" "Back"; do
                                case $action in
                                    "Delete all from table")
                                        while true; do
                                            read -p "Are you sure [y/n]: " userAnswer
                                            if [[ $userAnswer == "y" || $userAnswer == "Y" ]]; then
                                                awk 'NR==1 {print; next} {next} 1' "./tables/$table" > temp_file && mv temp_file "./tables/$table"
                                                echo "All rows from the table '$table' have been deleted."
                                                break
                                            elif [[ $userAnswer == "n" || $userAnswer == "N" ]]; then
                                                break
                                            else
                                                echo "Invalid option, try again"
                                            fi
                                        done
                                        ;;
                                    "Delete row")
                                        while true; do
                                            read -p "Please enter the primary key for the row or [Q] to quit: " pk
                                            
                                            if [[ $pk == "Q" || $pk == "q" ]]; then
                                                break
                                            else
                                                found=false
                                                awk -F '│' -v pk="$pk" '$1 == pk' "./tables/$table" > temp_file

                                                if [[ -s temp_file ]]; then
                                                    echo "Found the following row:"
                                                    cat temp_file
                                                    read -p "Do you want to delete this row [y/n]? " confirm

                                                    if [[ $confirm == "y" || $confirm == "Y" ]]; then
                                                        awk -F '│' -v pk="$pk" '$1 != pk' "./tables/$table" > temp_file2 && mv temp_file2 "./tables/$table"
                                                        echo "Row with primary key '$pk' has been deleted."
                                                        found=true
                                                        read -p "Press Enter to continue" _
                                                        clear
                                                    else
                                                        echo "Row with primary key '$pk' was not deleted."
                                                    fi
                                                fi

                                                if [[ $found == false ]]; then
                                                    clear
                                                    echo "Primary key '$pk' does not exist in the table."
                                                    echo "Try again."
                                                fi

                                                rm temp_file
                                            fi
                                        done
                                        ;;
                                    "Back")
                                        return
                                        ;;
                                    *)
                                        echo "Invalid Option, please try again"
                                        ;;
                                esac
                            done
                        else
                            echo "The table is empty"
                        fi
                    else
                        echo "Table does not exist, please try again"
                    fi
                    ;;
            esac
            clear
        done
    done
}

# deletefromtable
