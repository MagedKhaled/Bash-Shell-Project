#!/bin/bash
source validation_functions.sh

function editTB { #tableName tableConnectedName colName seperator colValue colToChange newValue
    tableName=$1
    tableConnectedName=$2
    colName=$3
    seperator=$4
    colValue=$5
    colToChange=$6
    newValue=$7

    colNum=$(awk -F'│' '$1 == "'$tableConnectedName' '$colName'" {print $3}' ./description)
    colToChangeNum=$(awk -F'│' '$1 == "'$tableConnectedName' '$colToChange'" {print $3}' ./description)



    awk -F'│' -v OFS='│' -v colNum="$colNum" -v seperator="$seperator" -v colValue="$colValue" -v colToChangeNum="$colToChangeNum" -v newValue="$newValue" '
    {
        if (seperator == "=="){
            if ($colNum == colValue && NR != 1) {
            $colToChangeNum = newValue
        }
        print
        }
        else if (seperator == ">"){
            if ($colNum > colValue && NR != 1) {
            $colToChangeNum = newValue
        }
        print
        }
        else if (seperator == "<"){
            if ($colNum < colValue && NR != 1) {
            $colToChangeNum = newValue
        }
        print
        }
        
    }' "$tableName" > tmpfile
    mv tmpfile "$tableName"
}

function updateTB {
    listOfTB=$(ls ./tables)
    if [ $(wc -l <<< $listOfTB) -gt 1 ]; then 
        listOfTB=$(echo "$originalString" | tr -d '\n')
        echo asdk$listOfTB
    else 
        echo equal

    fi
    echo -e 'Available Tables: \n\n'
    getDB $listOfTB
    echo -e '\n'
    listOfTB=($listOfTB) 
    numOfTB=${#listOfTB[@]}
    while true
    do
        if [ $numOfTB -gt 0 ]; then
            read -ep 'Enter The Number Of Table To Insert into: ' inp
            
            if [[ $inp =~ [1-9] ]] && [ $inp -le $numOfTB ] && [ $inp -gt 0 ]; then
                tableConnectedName=${listOfTB[(($inp-1))]}
                tableConnected='./tables/'$tableConnectedName
            else
                echo "Invalide Input"
                continue
            fi
        else
            echo "No Tables To Connect"
            break
        fi  
    break;
    done
    
    colList=$(head -1 "$tableConnected")
    IFS='│'
    read -ra list <<< "$colList"
    clear
    echo -e 'Available columns: \n\n'
    getDB $colList
    echo -e '\n'

    listOfCol=($colList) 
    numOfCol=${#listOfCol[@]}
    while true 
    do
        if [ $numOfCol -gt 0 ]; then
            read -ep 'Enter The Number Of Column To check: ' inp
            
            if [[ $inp =~ [1-9] ]] && [ $inp -le $numOfCol ] && [ $inp -gt 0 ]; then
                colName=${listOfCol[(($inp-1))]}
            else

                echo "Invalide Input"
                continue
            fi
        else
            echo "No Columns To Check"
            continue
        fi
        break
    done


    while true 
    do
        echo $colName
        read -p "Write your condition it is like (=5) you can use (=,!,>,<): " condition

        if grep '>' <<< "$condition"; then
            seperator='>'
            sep='>'
        elif grep '<' <<< "$condition"; then
            seperator='<'
            sep='<'
        elif grep '!' <<< "$condition"; then
            seperator='!='
            sep='!'
        elif grep '=' <<< "$condition"; then
            seperator='=='
            sep='='
        else 
            echo Invalide condition
            continue
        fi
        colValue=$(cut -f2 -d"$sep" <<< "$condition")

        break   
    done

    # read -p "Which column you want to change: " colToChange
    echo -e 'Available columns: \n\n'
    getDB $colList
    echo -e '\n'

    while true 
    do
        if [ $numOfCol -gt 0 ]; then
            read -ep 'Enter The Number Of Table To change value: ' inp
            
            if [[ $inp =~ [1-9] ]] && [ $inp -le $numOfCol ] && [ $inp -gt 0 ]; then
                echo 
                colToChange=${listOfCol[(($inp-1))]}
            else

                echo "Invalide Input"
                continue
            fi
        else
            echo "No Columns To Check"
            continue
        fi
        break
    done

    while true
    do
        read -p "Write the new value: " newValue
        checkValid "$tableConnectedName $colToChange" $newValue $tableConnected
        statu=$?
        if [ $statu -eq '1' ]; then
            break
            
        else 
            case "$statu" in 
                "11") echo Invalide data type;;
                "12") echo PK Can\'t be null;;
                "13") echo PK must be unique;;
            esac
        fi
    done

    editTB $tableConnected $tableConnectedName $colName $seperator $colValue $colToChange $newValue

}

