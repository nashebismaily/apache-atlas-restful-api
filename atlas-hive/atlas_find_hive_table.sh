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

## Run the create_hive_table.sql script to create the employees table in the default Hive database ##
## The code below will find the GUID for the newly created employees table ##

# Get all entities of a particular type
curl -u $atlas_user:$atlas_password -X GET http://$atlas_host:$atlas_port/api/atlas/types

# Request al entriries of hive_table type
curl -u $atlas_user:$atlas_password -X GET http://$atlas_host:$atlas_port/api/atlas/entities?type=hive_table

# Iterate through the GUID to find the correct Hive table
#TODO
#for...
#
#curl -u $atlas_user:$atlas_password -X GET http://$atlas_host:$atlas_port/api/atlas/entities/<GUID>
#end


