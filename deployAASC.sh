#!/bin/bash

# Author : Mark Heckler
# Notes  : Must have sourced envAASC.sh and run configAASC.sh before
#          this script per previous instructions
# History: Official "version 1" 20220214. Happy Valentine's Day! <3

clear
printf "\nDeploying app artifacts to Spring Cloud\n"

# ==== Build and deploy ====
printf "\n\nDeploying $API_GATEWAY_ID\n"
az spring-cloud app deploy -n $API_GATEWAY_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $API_GATEWAY_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $ADMIN_SERVICE_ID\n"
az spring-cloud app deploy -n $ADMIN_SERVICE_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $ADMIN_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'
    
printf "\n\nDeploying $AIRPORT_SERVICE_ID\n"
az spring-cloud app deploy -n $AIRPORT_SERVICE_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $AIRPORT_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $WEATHER_SERVICE_ID\n"
az spring-cloud app deploy -n $WEATHER_SERVICE_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $WEATHER_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $CONDITIONS_SERVICE_ID\n"
az spring-cloud app deploy -n $CONDITIONS_SERVICE_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $CONDITIONS_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

# cd $PROJECT_DIRECTORY

GATEWAY_URI=$(az spring-cloud app show -n $API_GATEWAY_ID -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE --query properties.url --output tsv)
# | jq -r '.properties.url')

printf "\n\nTesting deployed services at ${GATEWAY_URI}\n"

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

    #   curl -g https://$SPRING_CLOUD_SERVICE-$AIRPORT_SERVICE_ID.azuremicroservices.io/
    #   curl -g https://$SPRING_CLOUD_SERVICE-$AIRPORT_SERVICE_ID.azuremicroservices.io/airport/KALN

    #   curl -g https://$SPRING_CLOUD_SERVICE-$WEATHER_SERVICE_ID.azuremicroservices.io
    #   curl -g https://$SPRING_CLOUD_SERVICE-$WEATHER_SERVICE_ID.azuremicroservices.io/metar/KSUS
    #   curl -g https://$SPRING_CLOUD_SERVICE-$WEATHER_SERVICE_ID.azuremicroservices.io/taf/KSUS
done

printf "\n\nAPI exercises complete via gateway $GATEWAY_URI\n"
