function start_with_string {

    if [[ $1 =~ ^[a-z|A-Z] ]]; then
        return 1
    else
        return 0
    fi
}   


function getDB {
    typeset -i increment=1
    for db in $*
    do
        echo "$increment ) $db"
        increment=$increment+1
    done
        
}


function isExist {
    echo $1 
    echo $2
    echo [[ $2 == *"$2"* ]]
}





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