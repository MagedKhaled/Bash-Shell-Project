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
    echo -e 'Available Databases: \n\n'
    listOfDB=`ls ./databases`
    getDB $listOfDB
    echo -e '\n'

    
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



function listTB {
    listOfTB=`ls ./tables`
    echo -e 'Available Tables: \n\n'
    getDB $listOfTB
    echo -e '\n'
    
}


