# MH: Just a collection of commands... #!/bin/bash

# Monitoring/kill/cleanup commands

## Configure defaults so the az client can selectively ignore provided command line parameters
## Example: Creating CosmosDB MongoDB instance
## Note: Not really a great idea for community as it then overrides defaults that may be set by
## a dev's company in their env, sadly...
# az configure -d group=$RESOURCE_GROUP location=$REGION spring-cloud=$SPRING_CLOUD_SERVICE subscription=$SUBSCRIPTION

## Logs
### Tailing
az spring-cloud app logs -n $<app_id> -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE -f

### See more
az spring-cloud app logs -n $<app_id> -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE --lines 200

## List keys for CosmosDB account :O)
az cosmosdb keys list -n $COSMOSDB_ACCOUNT -g $RESOURCE_GROUP

## List all apps in this ASC instance
az spring-cloud app list -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE

## List all databases in Azure Database for MySQL "server"
az mysql db list -g $RESOURCE_GROUP -s $MYSQL

## App delete
az spring-cloud app delete -n $<app_id> -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE

## List resource groups for this account
az group list | jq -r '.[].name'
or
az group list --query "[].name" --output tsv

## Burn it to the ground
az group delete -g $RESOURCE_GROUP --subscription $SUBSCRIPTION -y

## Azure Spring cloud delete, destroy, el fin de la historia
az spring-cloud delete -n $SPRING_CLOUD_SERVICE -g $RESOURCE_GROUP

## Azure Spring cloud stop (pause, deep freeze, save for later)
az spring-cloud stop -n $SPRING_CLOUD_SERVICE -g $RESOURCE_GROUP

## Create/deploy script runner, timer, logger
time <script> | tee deployoutput.txt