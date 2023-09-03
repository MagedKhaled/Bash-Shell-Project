function getDB {
    
    dbs=`ls ./databases`
    # echo ${dbs[0]} ${dbs[1]}
    if [ $1 = '-p' ] 
    then
        typeset -i increment=1
        # typeset dataToReturn[]
        for db in $dbs 
        do
            echo "$increment ) $db"
            # dataToReturn[$increment]=$db
            increment=$increment+1
        done
        
    # else 
        # return $x
    fi
    # return $dbs
}
    




function createDB {
    read -p 'Enter The Name Of Your Database To Create: ' inp
    mkdir ./databases/$inp
    echo Create Database
}
function listDB {
    getDB -p
    
}
function connecteDB {
    echo Connect To Database 
}
function dropDB {
    getDB -p
    # echo $?
    read -p 'Enter The Name Of Database To Delete: ' inp
    rm -r ./databases/$inp
    # echo ${alldb[*]}
}
