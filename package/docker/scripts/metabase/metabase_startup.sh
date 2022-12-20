#!/bin/bash
echo "Starting and intializing the Metabase."

echo ${CONNECT_TO_DB}
echo "********1"
echo "${CONNECT_TO_DB}"
echo "********2"
echo $CONNECT_TO_DB
echo "********3"
echo "$CONNECT_TO_DB"
echo "********4"

/app/run_metabase.sh & /app/scripts/metabase/metabase_init.sh

wait ${!}