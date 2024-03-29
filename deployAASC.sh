#!/bin/bash

# Author  : Mark Heckler
# Notes   : Must have sourced envAASC.sh and run configAASC.sh before
#           this script per previous instructions
# History : Official "version 1" 20220214. Happy Valentine's Day! <3
#         : General cleanup of script
# 20220406: Added test endpoints to verify Config Server values passed

clear
printf "\nDeploying app artifacts to Spring Cloud\n"

# Deploy the actual applications
printf "\n\nDeploying $API_GATEWAY_ID\n"
az spring app deploy -n $API_GATEWAY_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $API_GATEWAY_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $ADMIN_SERVICE_ID\n"
az spring app deploy -n $ADMIN_SERVICE_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $ADMIN_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'
    
printf "\n\nDeploying $AIRPORT_SERVICE_ID\n"
az spring app deploy -n $AIRPORT_SERVICE_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $AIRPORT_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $WEATHER_SERVICE_ID\n"
az spring app deploy -n $WEATHER_SERVICE_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $WEATHER_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

printf "\n\nDeploying $CONDITIONS_SERVICE_ID\n"
az spring app deploy -n $CONDITIONS_SERVICE_ID \
    -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE \
    --artifact-path $CONDITIONS_SERVICE_JAR \
    --jvm-options='-Xms2048m -Xmx2048m'

# Exercise those endpoints
GATEWAY_URI=$(az spring app show -n $API_GATEWAY_ID -g $RESOURCE_GROUP -s $SPRING_CLOUD_SERVICE --query properties.url --output tsv)

printf "\n\nTesting deployed services at $GATEWAY_URI\n"
for i in `seq 1 3`; 
do
  printf "\n\nRetrieving default value via airport app: testplane\n"
  curl -g $GATEWAY_URI/airports/testplane
  printf "\n\nRetrieving default value via airport app: testcomplexplane\n"
  curl -g $GATEWAY_URI/airports/testcomplexplane
  printf "\n\nRetrieving default value via airport app: testairport\n"
  curl -g $GATEWAY_URI/airports/testairport
  printf "\n\nRetrieving default value via airport app: testfuel\n"
  curl -g $GATEWAY_URI/airports/testfuel

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
