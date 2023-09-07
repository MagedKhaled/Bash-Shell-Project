source test_functions.sh






function createDB {
    read -p 'Enter The Name Of Your Database To Create: ' inp
    
    if $(start_with_string $inp) && $(isExist $inp $(ls ./databases)); 
    then
        echo "invalide input"
    else
        mkdir -p ./databases/$inp/tables/
        echo $inp Database is created successfully;
    fi
}

function listDB {
    listOfDB=`ls ./databases`
    getDB $listOfDB
    
}
function connecteDB {
    echo Connect To Database 
}
function dropDB {
    listOfDB=$(ls ./databases)
    getDB $listOfDB
    listOfDB=($listOfDB) 
    numOfDB=${#listOfDB[@]}
    if [ $numOfDB -gt 0 ]; then
        read -p 'Enter The Number Of Database To Delete: ' inp
        
        if [[ $inp =~ [1-9] ]] && [ $inp -le $numOfDB ] && [ $inp -gt 0 ]; then
            deleteDB=${listOfDB[(($inp-1))]}
            rm -r "./databases/$deleteDB"
            echo "Database $deleteDB is deleted successfully"
        else
            echo "Invalide Input"
        fi
    else
        echo "No Database To Delete"
    fi    
}


