#!/bin/bash

#
# Find a Hive table in Atlas for tagging
#
# Author: Nasheb Ismaily
#

# Variables
atlas_host=sandbox.hortonworks.com
atlas_port=21000
atlas_user=admin
atlas_password=admin

# Hive Table Name
TABLE_NAME="employees"
# Atlas Tag (assuming its been pre-created in Atlas)
TAG="PII"

## Run the create_hive_table.sql script to create the employees table in the default Hive database ##
## The code below will find the GUID for the newly created employees table ##

# Get all entities of a particular type
#curl -s -u $atlas_user:$atlas_password -X GET http://$atlas_host:$atlas_port/api/atlas/types

# Request al entriries of hive_table type
results=( $(curl -s -u $atlas_user:$atlas_password -X GET http://$atlas_host:$atlas_port/api/atlas/entities?type=hive_table | jq -r '.results') )

# Clean brackets from array
unset 'results[${#results[@]}-1]'
unset results[0]

# Iterate through the GUID to find the correct Hive table
for i in "${results[@]}"
do
   GUID=$(echo $i | cut -d '"' -f2)
   table_found=$(curl -s -u $atlas_user:$atlas_password -X GET http://$atlas_host:$atlas_port/api/atlas/entities/$GUID |jq -r '.definition.values.name' | grep $TABLE_NAME |wc -l)

   if [ "$table_found" -gt "0" ];then

     # Add the Tag
curl -s -u $atlas_user:$atlas_password -v -X POST -H 'Content-Type: application/json' -H 'Accept-Language: en-US,en;q=0.8' -H 'Accept: application/json, text/javascript, */*; q=0.01' --data-binary '{ "jsonClass":"org.apache.atlas.typesystem.json.InstanceSerialization$_Struct", "typeName":"PII", "values":{ } }' --compressed "http://$atlas_host:$atlas_port/api/atlas/entities/$GUID/traits/"
     # exit loop
     break
   fi
done

# Verify Table Tagged

tag_found=$(curl -s -u $atlas_user:$atlas_password -X GET http://$atlas_host:$atlas_port/api/atlas/entities/$GUID | jq -r '.definition.traitNames' | grep $TAG  | wc -l)

if [ "$tag_found" -gt "0" ];then
  echo -e "\n\nTag: $TAG successfully added to Hive Table: $TABLE_NAME"
  exit 0
else
  echo -e "\n\nFailed to add Tag: $TAG to Hive Table: $TABLE_NAME"
  exit 1
fi



