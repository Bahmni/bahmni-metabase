#!/bin/bash

echo "Adding OPENMRS Database to Metabase"

# echo ${CONNECT_TO_DB}
# echo "********1"
# echo "${CONNECT_TO_DB}"
# echo "********2"
# echo $CONNECT_TO_DB
# echo "********3"
# echo "$CONNECT_TO_DB"
# echo "********4"

CONNECT_TO_DB=${CONNECT_TO_DB}

echo "connect to DB : ${CONNECT_TO_DB}"

add_DB_to_metabase(){
    database_response=$(curl -s -w "%{http_code}" -X POST \
    -H "Content-type: application/json" \
    -H "X-Metabase-Session: ${MB_TOKEN}" \
    http://${MB_HOST}:${MB_PORT}/api/database \
    -d '{
        "engine": "'$5}'",
        "name": "'$1'",
        "details": {
            "host": "'$1'",
            "db": "'$2'",
            "user": "'$3'",
            "password": "'$4'"
        }
    }')
    STATUS=${database_response: -3}
    echo $STATUS

    if [ $STATUS == 200 ]
    then
        echo "$2 Database added to Metabase" 
    else
        echo "ERROR OCCOURED WHILE CONNECT DB : $2" 
    fi
}

length=$(jq '. | length' <<< "${value}" )

for ((i=0; i < $length; i++))
do
    DB_DATA=$(jq ".[$i]" <<< "${value}")
    DB_HOST_NAME=$(echo "${DB_DATA}" | jq '.DB_HOST' | tr -d '"') 
    DB_NAME=$(echo "${DB_DATA}" | jq '.DB_NAME' | tr -d '"') 
    DB_USERNAME=$(echo "${DB_DATA}" | jq '.DB_USERNAME' | tr -d '"') 
    DB_PASSWORD=$(echo "${DB_DATA}" | jq '.DB_PASSWORD' | tr -d '"') 
    DB_TYPE=$(echo "${DB_DATA}" | jq '.DB_TYPE' | tr -d '"') 
    # echo $DB_HOST_NAME
    # echo $DB_NAME
    # echo $DB_USERNAME
    # echo $DB_PASSWORD
    # echo $DB_TYPE
    echo "connecting DB : $DB_DATA"
    add_DB_to_metabase $DB_HOST_NAME $DB_NAME $DB_USERNAME $DB_PASSWORD $DB_TYPE
done

