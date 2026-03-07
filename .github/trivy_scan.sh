# This Source Code Form is subject to the terms of the Mozilla Public License,
# v. 2.0. If a copy of the MPL was not distributed with this file, You can
# obtain one at https://www.bahmni.org/license/mplv2hd.
#
# Copyright (C) OpenMRS Inc. OpenMRS is a registered trademark and the OpenMRS
# graphic logo is a trademark of OpenMRS Inc.

#!/bin/bash

#Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

#Make an array of input paths
TARGETS=("$@")
#Count number of inputs
NUMBER_OF_PATHS=${#args[@]} 
#If no input given scan all
if [ -z "$TARGETS" ]; then
    TARGETS=(".")
fi
#Trivy scan the elements of array
for TARGET_PATH in "${TARGETS[@]}";
do
echo "scanning $TARGET_PATH"
trivy fs --severity "MEDIUM,HIGH,CRITICAL" --exit-code 1 $TARGET_PATH
done