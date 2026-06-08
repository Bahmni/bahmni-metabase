#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at https://www.bahmni.org/license/mplv2hd.
#
# Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
# graphic logo is a trademark of OpenMRS Inc.

echo "Creating admin user"

SETUP_TOKEN=$(curl -s -m 5 -X GET \
    -H "Content-Type: application/json" \
    http://${MB_HOST}:${MB_PORT}/api/session/properties \
    | jq -r '.["setup-token"]'
)

if [ $SETUP_TOKEN != '' ]
then
    create_admin_response=$(curl -s -w "%{http_code}" -X POST \
        -H "Content-type: application/json" \
        http://${MB_HOST}:${MB_PORT}/api/setup \
        -d '{
        "token": "'${SETUP_TOKEN}'",
        "user": {
            "email": "'${MB_ADMIN_EMAIL}'",
            "first_name": "'${MB_ADMIN_FIRST_NAME}'",
            "password": "'${MB_ADMIN_PASSWORD}'"
        },
        "prefs": {
            "allow_tracking": false,
            "site_name": "Bahmni Metabase"
        }
    }')

    STATUS=${create_admin_response: -3}
    if [ $STATUS == 200 ]
    then
        echo "\n Admin user created!"
        MB_TOKEN=$(jq -s -r '.[0].id' <<< ${create_admin_response})
        source /app/scripts/database/add_databases.sh
    fi
else
    echo 'SETUP_TOKEN not Available'
fi