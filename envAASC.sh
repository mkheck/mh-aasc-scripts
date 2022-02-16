#!/bin/bash

# Author : Mark Heckler
# Notes  : Run with 'source envAASC.sh' from your shell/commandline environment
# History: Official "version 1" 20220214. Happy Valentine's Day! <3

# Customize for your environment
export SUBSCRIPTION='ca-markheckler-demo-test'
export RESOURCE_GROUP='mh-scitc-rg'
export REGION='centralus'
export SPRING_CLOUD_SERVICE='mh-scitc-service'
export LOG_ANALYTICS='mkheck-scitc-analytics'
export PROJECT_DIRECTORY=$HOME
export REPO_OWNER_URI='https://github.com/mkheck'
export PROJECT_REPO='spring-cloud-in-the-cloud'
export CONFIG_REPO='mh-aasc-config'

# Service/app instances
export API_GATEWAY_ID='api-gateway'
export ADMIN_SERVICE_ID='admin-service'
export AIRPORT_SERVICE_ID='airport-service'
export WEATHER_SERVICE_ID='weather-service'
export CONDITIONS_SERVICE_ID='conditions-service'

# Config repo location
export CONFIG_DIR="$PROJECT_DIRECTORY/source-code/$PROJECT_REPO/config"

# Individual app project directories
export API_GATEWAY_DIR="$PROJECT_DIRECTORY/source-code/$PROJECT_REPO/$API_GATEWAY_ID"
export ADMIN_SERVICE_DIR="$PROJECT_DIRECTORY/source-code/$PROJECT_REPO/$ADMIN_SERVICE_ID"
export AIRPORT_SERVICE_DIR="$PROJECT_DIRECTORY/source-code/$PROJECT_REPO/$AIRPORT_SERVICE_ID"
export WEATHER_SERVICE_DIR="$PROJECT_DIRECTORY/source-code/$PROJECT_REPO/$WEATHER_SERVICE_ID"
export CONDITIONS_SERVICE_DIR="$PROJECT_DIRECTORY/source-code/$PROJECT_REPO/$CONDITIONS_SERVICE_ID"

# Deployables
export API_GATEWAY_JAR="$API_GATEWAY_DIR/target/$API_GATEWAY_ID-0.0.1-SNAPSHOT.jar"
export ADMIN_SERVICE_JAR="$ADMIN_SERVICE_DIR/target/$ADMIN_SERVICE_ID-0.0.1-SNAPSHOT.jar"
export AIRPORT_SERVICE_JAR="$AIRPORT_SERVICE_DIR/target/$AIRPORT_SERVICE_ID-0.0.1-SNAPSHOT.jar"
export WEATHER_SERVICE_JAR="$WEATHER_SERVICE_DIR/target/$WEATHER_SERVICE_ID-0.0.1-SNAPSHOT.jar"
export CONDITIONS_SERVICE_JAR="$CONDITIONS_SERVICE_DIR/target/$CONDITIONS_SERVICE_ID-0.0.1-SNAPSHOT.jar"

# Etc
# export LOG_ANALYTICS_RESOURCE_ID=
# export WEBAPP_RESOURCE_ID=
# export GATEWAY_URI=
