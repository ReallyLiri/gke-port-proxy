# GKE-port-proxy

This docker image is used to expose an internal Google Kubernetes Engine port from a deployed cluster using the builtin port forwarding.

## Docker Image

[![](https://images.microbadger.com/badges/version/reallyliri/gke-port-proxy:1.0.svg)](https://microbadger.com/images/reallyliri/gke-port-proxy:1.0 "Get your own version badge on microbadger.com")

Available on [Dockerhub](https://hub.docker.com/r/reallyliri/gke-port-proxy) or by pulling `reallyliri/gke-port-proxy:1.0`.
## Build

`docker build -t gke-port-proxy .`

## Required Parameters

Prepare in advance a file with the credentials to connect to your GCloud: `gcloud-api-key.json`: [creating-managing-service-account-keys](https://cloud.google.com/iam/docs/creating-managing-service-account-keys).

Now that you have the `.json` file, encode it to `base64` and keep the single string you acquired, we will use it as an environment variable in the `run` command.

`export GCLOUD_API_BASE64=$(base64 gcloud-api-key.json)`

Other required parameters:

* `SOURCE_PORT`: port to forward from
* `TARGET_PORT`: port to forward to
* `GCLOUD_PROJECT`: the internal name of your project in Google Cloud
* `GCLOUD_ZONE` or `GCLOUD_REGION`: you need to supply a location to connect to GKE, you can use either a zone or a region.
* `CLUSTER`: the name of your GKE cluster
* `SERVICE_NAME`: the name of the service to forward

## Run

Run command with example parameters set:

```
export SOURCE_PORT=443
export TARGET_PORT=8080
export GCLOUD_PROJECT=gcloud-project-name
export GCLOUD_ZONE=europe-west1-b
export GCLOUD_REGION=us-east4
export GCLOUD_API_BASE64="..."
export CLUSTER=my-cluster-name
export SERVICE_NAME=my-svc-name

docker run -d \
    --name "gke-port-proxy-$TARGET_PORT" \
    --restart unless-stopped \
    -p $TARGET_PORT:$TARGET_PORT \
    -e SOURCE_PORT=$SOURCE_PORT \
    -e TARGET_PORT=$TARGET_PORT \
    -e GCLOUD_PROJECT=$GCLOUD_PROJECT \
    -e GCLOUD_ZONE=$GCLOUD_ZONE \
    -e GCLOUD_REGION=$GCLOUD_REGION \
    -e GCLOUD_API_BASE64=$GCLOUD_API_BASE64 \
    -e CLUSTER=$CLUSTER \
    -e SERVICE_NAME=$SERVICE_NAME \
    gke-port-proxy
```

You can now connect to the your service at `127.0.0.1:$TARGET_PORT`.
