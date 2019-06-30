#!/usr/bin/env bash

set -e

echo $GCLOUD_API_BASE64 | base64 --decode --ignore-garbage > ./gcloud-api-key.json
gcloud auth activate-service-account --key-file /gcloud-api-key.json
gcloud config set project $GCLOUD_PROJECT

if [[ ! -z "$GCLOUD_ZONE" ]]; then
    gcloud config set compute/zone $GCLOUD_ZONE
fi

if [[ ! -z "$GCLOUD_REGION" ]]; then
    gcloud config set compute/region $GCLOUD_REGION
fi

gcloud auth configure-docker --quiet

gcloud container clusters get-credentials $CLUSTER \
    || { echo "No matching cluster, entering infinite loop"; exit 1; }

kubectl port-forward svc/$SERVICE_NAME $TARGET_PORT:$SOURCE_PORT
