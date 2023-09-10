#!/bin/bash


function deletefromtable {
    while true; do

        PS3="Select a table to delete from or quit: "
        select table in $(ls "./tables") "Quit"; do
            case $table in
                "Quit")
                clear ;
                tableActions
                    ;;
                *)
                    if [[ -f "./tables/$table" ]]; then
                        if [[ -s "./tables/$table" ]]; then
                            clear
                            PS3="Select an action: "
                            select action in "Delete all from table" "Delete row" "Back"; do
                                case $action in
                                    "Delete all from table")
                                        PS3="Are you sure [y/n]: "
                                        while true; do
                                            read -p "$PS3" answer
                                            case $answer in
                                                "y" | "Y")
                                                    awk 'NR==1 {print; next} {next} 1' "./tables/$table" > temp_file && mv temp_file "./tables/$table"
                                                    break
                                                    deletefromtable
                                                    ;;
                                                "n" | "N")
                                                    break
                                                    deletefromtable
                                                    ;;
                                                *)
                                                    echo "Invalid option, try again"
                                                    ;;
                                            esac
                                        done
                                        
                                        ;;
                                    "Delete row")
                                        while true; do
                                            PS3="Please enter the primary key for the row or [Q] to quit: "
                                            read -p "$PS3" pk
                                            if [[ $pk == "Q" || $pk == "q" ]]; then
                                                clear
                                                deletefromtable
                                                break 

                                            else
                                                if awk -F '│' -v pk="$pk" '$1 == pk' "./tables/$table" >/dev/null; then
                                                    awk -F '│' -v pk="$pk" '$1 != pk' "./tables/$table" > temp_file2 && mv temp_file2 "./tables/$table"
                                                    echo -e "Row with primary key '$pk' has been deleted \n"
                                                    read -p "Press Enter to continue" _
                                                    clear
                                                    break 

                                                else
                                                    echo "Primary key '$pk' does not exist in the table."
                                                fi
                                            fi
                                        done
                                        ;;
                                    "Back")
                                        return
                                        ;;
                                    *)
                                        echo "Invalid option, please try again"
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
        done
    done
}

# deletefromtable
