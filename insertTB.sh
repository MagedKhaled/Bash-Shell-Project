source test_functions.sh

function checkValid {

    description=$(grep "$1" description)
    colType=$( cut -f2 -d'│' <<< "$description" )
    typeIsValid=false
    if [ $colType = 'int' ]; then 
        if [[ $2 =~ ^[0-9]+$ ]] || [ "$2" = "" ]; then
            typeIsValid=true
        else
            return 11;
        fi
    else 
        if [[ "$2" =~ ^[A-Za-z]+$ ]] || [ "$2" = "" ]; then
            typeIsValid=true
        else 
            return 11;
        fi
    fi

    
    PK=$( cut -f4 -d'│' <<< "$description" )
    isPK=false
    if [ "$PK" = 'PK' ]; then
        isPK=true
        isnotnull=false
        isunique=false

        if [ "$2" ]; then
            isnotnull=true
        else 
            return 12
        fi
        isExist=$(cat "$3" | cut -f1 -d│ | grep -w $2)
        if ! [ "$isExist" ]; then 
            isunique=true
        else 
            return 13
        fi
    else
        return 1
    fi
    return 1
}
function insertTB {
    clear
    listOfTB=$(ls ./tables)
    echo -e 'Available Tables: \n\n'
    getDB $listOfTB
    echo -e '\n'
    listOfTB=($listOfTB) 
    numOfTB=${#listOfTB[@]}
    if [ $numOfTB -gt 0 ]; then
        read -ep 'Enter The Number Of Table To Insert into: ' inp
        
        if [[ $inp =~ [1-9] ]] && [ $inp -le $numOfTB ] && [ $inp -gt 0 ]; then
            tableConnectedName=${listOfTB[(($inp-1))]}
            tableConnected='./tables/'$tableConnectedName
        else
            echo "Invalide Input"
        fi
    else
        echo "No Database To Connect"
    fi  


    while true
    do
    clear
    cols=$(head -1 "$tableConnected")
    numberCol=$(echo "$cols" | grep -o '│' | wc -l)
    dataEnery=''
    for ((colNum = 1; colNum <= numberCol; colNum++)); do
        colName=$( cut -f"$colNum" -d'│' <<< "$cols" )
        read -p "Enter The Value Of $colName: " colValue
        checkValid "$tableConnectedName $colName" $colValue $tableConnected
        statu=$?
        if [ $statu -eq '1' ]; then
            dataEnery=$dataEnery$colValue'│'
            
        else 
            colNum=$colNum-1
            case "$statu" in 
                "11") echo Invalide data type;;
                "12") echo PK Can\'t be null;;
                "13") echo PK must be unique;;
            esac
        fi
    done
    echo $dataEnery >> $tableConnected;
    echo -e "\n\nThe record saved successfully.\n"
    read -p "Enter another value (y,n)?" inp
    if [ $inp = 'y' ] || [ $inp = 'Y' ]; then 
        continue;
    else  
        break;
    fi
    done
    


}

