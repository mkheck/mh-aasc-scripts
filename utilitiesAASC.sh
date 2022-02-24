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

## Exercise endpoints

### If not already done, source envAASC.sh first! Then...
export GATEWAY_URI=$(az spring-cloud app show -n $API_GATEWAY_ID -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE --query properties.url --output tsv)

printf "\n\nTesting deployed services at $GATEWAY_URI\n"
for i in `seq 1 3`; 
do
  printf "\n\nRetrieving airports list\n"
  curl -g $GATEWAY_URI/airports/

  printf "\n\nRetrieving airport\n"
  curl -g $GATEWAY_URI/airports/airport/KALN

  printf "\n\nRetrieving default weather (METAR: KSTL)\n"
  curl -g $GATEWAY_URI/weather

  printf "\n\nRetrieving METAR for KSUS\n"
  curl -g $GATEWAY_URI/weather/metar/KSUS

  printf "\n\nRetrieving TAF for KSUS\n"
  curl -g $GATEWAY_URI/weather/taf/KSUS

  printf "\n\nRetrieving current conditions greeting\n"
  curl -g $GATEWAY_URI/conditions

  printf "\n\nRetrieving METARs for Class B, C, & D airports in vicinity of KSTL\n"
  curl -g $GATEWAY_URI/conditions/summary
done

printf "\n\nAPI exercises complete via gateway $GATEWAY_URI\n"