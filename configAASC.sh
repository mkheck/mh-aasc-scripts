#!/bin/bash
# set -e

# Author : Mark Heckler
# Notes  : Must have sourced envAASC.sh before this script per envAASC.sh instructions
# History: Official "version 1" 20220214. Happy Valentine's Day! <3
#        : General cleanup of script

function error_handler() {
  az group delete -g $RESOURCE_GROUP --no-wait --subscription $SUBSCRIPTION -y
  echo "ERROR occurred :line no = $2" >&2
  exit 1
}
trap 'error_handler $? ${LINENO}' ERR

clear

# Add required extensions
az extension add -n spring-cloud


# Set origin machine variable (if desired/required)
# DEVBOX_IP_ADDRESS=$(curl ifconfig.me)


# Create and sanitize local code directory
cd ${PROJECT_DIRECTORY}

mkdir -p source-code
cd source-code
rm -rdf $PROJECT_REPO


# Retrieve code from repo, build apps
printf "\n\nCloning the sample project: $REPO_OWNER_URI/$PROJECT_REPO\n"

git clone --recursive $REPO_OWNER_URI/$PROJECT_REPO
cd $PROJECT_REPO
mvn clean package -DskipTests -Denv=cloud

cd "$PROJECT_DIRECTORY/source-code/$PROJECT_REPO"


# Infra configuration
printf "\n\nCreating the Resource Group: ${RESOURCE_GROUP} Region: ${REGION}\n"

az group create -l $REGION -g $RESOURCE_GROUP --subscription $SUBSCRIPTION


printf "\n\nCreating the Spring Cloud infra: ${SPRING_CLOUD_SERVICE}\n"

# --disable-app-insights is likely superfluous per 
# https://docs.microsoft.com/en-us/cli/azure/spring-cloud?view=azure-cli-latest#az-spring-cloud-create
az spring-cloud create -n $SPRING_CLOUD_SERVICE -g $RESOURCE_GROUP -l $REGION --disable-app-insights false
# --subscription $SUBSCRIPTION

# az spring-cloud config-server set --config-file $CONFIG_DIR/application.yml -n $SPRING_CLOUD_SERVICE -g $RESOURCE_GROUP
# OR
az spring-cloud config-server git set -n ${SPRING_CLOUD_SERVICE} -g $RESOURCE_GROUP --uri $REPO_OWNER_URI/$CONFIG_REPO


# Create app constructs in ASC
printf "\n\nCreating the apps in Spring Cloud\n"

az spring-cloud app create -n $API_GATEWAY_ID -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
az spring-cloud app create -n $ADMIN_SERVICE_ID -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
az spring-cloud app create -n $AIRPORT_SERVICE_ID -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
az spring-cloud app create -n $WEATHER_SERVICE_ID -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true
az spring-cloud app create -n $CONDITIONS_SERVICE_ID -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --instance-count 1 --memory 2Gi --runtime-version Java_17 --assign-endpoint true


# Log analysis configuration
printf "\n\nCreating the log analytics workspace: ${LOG_ANALYTICS}\n"

az monitor log-analytics workspace create -g $RESOURCE_GROUP -n $LOG_ANALYTICS -l $REGION
                            
LOG_ANALYTICS_RESOURCE_ID=$(az monitor log-analytics workspace show \
    -g $RESOURCE_GROUP \
    -n $LOG_ANALYTICS --query id --output tsv)

WEBAPP_RESOURCE_ID=$(az spring-cloud show -n $SPRING_CLOUD_SERVICE -g $RESOURCE_GROUP --query id --output tsv)


printf "\n\nCreating the log monitor\n"

az monitor diagnostic-settings create -n "send-spring-logs-and-metrics-to-log-analytics" \
    --resource $WEBAPP_RESOURCE_ID \
    --workspace $LOG_ANALYTICS_RESOURCE_ID \
    --logs '[
         {
           "category": "SystemLogs",
           "enabled": true,
           "retentionPolicy": {
             "enabled": false,
             "days": 0
           }
         },
         {
            "category": "ApplicationConsole",
            "enabled": true,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          }        
       ]' \
       --metrics '[
         {
           "category": "AllMetrics",
           "enabled": true,
           "retentionPolicy": {
             "enabled": false,
             "days": 0
           }
         }
       ]'

printf "\n\nConfiguration complete!\n"
# fin
