#!/bin/bash

echo "Adding Databases to Metabase"

DB_CONNECTIONS=$DB_CONNECTIONS
if !(jq -e . >/dev/null 2>&1 <<< $DB_CONNECTIONS); then
    echo "Database connections cannot be provided for invalid json value. DB_CONNECTIONS: $DB_CONNECTIONS"
    exit 1
fi

add_DB_to_metabase(){
    database_response=$(curl -s -w "%{http_code}" -X POST \
    -H "Content-type: application/json" \
    -H "X-Metabase-Session: ${MB_TOKEN}" \
    http://${MB_HOST}:${MB_PORT}/api/database \
    -d '{
        "engine": "'$1'",
        "name": "'$2'",
        "details": {
            "host": "'$2'",
            "db": "'$3'",
            "user": "'$4'",
            "password": "'$5'"
        }
    }')
    STATUS=${database_response: -3}
${DB_NAME}+”_ID” = (jq database_response)
    if [ $STATUS == 200 ]
    then
        echo "$2 Database added to Metabase" 
    else
        echo "error occured wile connecting DB : $2" 
    fi
}

echo "Database connections : $DB_CONNECTIONS"

length=$(jq '. | length' <<< ${DB_CONNECTIONS} )

for ((i=0; i < $length; i++))
do
    DB_DATA=$(jq ".[$i]" <<< ${DB_CONNECTIONS})

    DB_HOST_NAME=$(echo "${DB_DATA}" | jq '.DB_HOST' | tr -d '"') 
    DB_NAME=$(echo "${DB_DATA}" | jq '.DB_NAME' | tr -d '"') 
    DB_USERNAME=$(echo "${DB_DATA}" | jq '.DB_USERNAME' | tr -d '"') 
    DB_PASSWORD=$(echo "${DB_DATA}" | jq '.DB_PASSWORD' | tr -d '"') 
    DB_TYPE=$(echo "${DB_DATA}" | jq '.DB_TYPE' | tr -d '"') 
    echo "connecting DB : $DB_DATA"

    add_DB_to_metabase  $DB_TYPE $DB_HOST_NAME $DB_NAME $DB_USERNAME $DB_PASSWORD
done

