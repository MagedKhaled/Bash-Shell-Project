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




