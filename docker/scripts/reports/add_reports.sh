#!/bin/bash

request=$(</app/scripts/reports/openmrs/request/report_request.json)
jq -c '.[]' /app/scripts/reports/openmrs/request/report_inputs.json | while read i; do

  REPORT_NAME=$(echo $i | jq -r .name)
  FILE_NAME=$(echo $i | jq -r .sql)
  PIVOT_COLUMN=$(echo $i | jq -r .pivot_column)
  CELL_COLUMN=$(echo $i | jq -r .cell_column)
  DB=$(echo $i | jq -r .db)
  DB_ID="${DB}_ID"
  DATABASE_ID=`echo ${!DB_ID}`
  echo
  REPORT_SQL=$(</app/scripts/reports/openmrs/sql/${FILE_NAME}.sql)

  report_request=$(jq --arg PIVOT_COLUMN "$PIVOT_COLUMN" --arg CELL_COLUMN "$CELL_COLUMN"  --arg REPORT_NAME "$REPORT_NAME" --argjson COLLECTION_ID $COLLECTION_ID --argjson DATABASE_ID $DATABASE_ID --arg REPORT_SQL "$REPORT_SQL" \
   '(.collection_id = $COLLECTION_ID | .dataset_query.database = $DATABASE_ID|.name=$REPORT_NAME |.dataset_query.native.query = $REPORT_SQL
   |.visualization_settings."table.pivot_column"=$PIVOT_COLUMN | .visualization_settings."table.cell_column"=$CELL_COLUMN)' <<< ${request})

  report_response=$(curl -w "%{http_code}" -X POST  \
   	-H "Content-type: application/json" \
 		-H "X-Metabase-Session: ${MB_TOKEN}" \
		 http://${MB_HOST}:${MB_PORT}/api/card/ \
 		-d "${report_request}")

	STATUS=${report_response: -3}

  if [ "$STATUS" == 200 ]
	then
    	echo "Created report for " ${REPORT_NAME}
	else
    	echo "Could not create report for " ${REPORT_NAME}
	fi
done
