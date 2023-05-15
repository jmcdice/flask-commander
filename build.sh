#!/usr/bin/env bash

source env.sh

function docker_build() {

  docker build --no-cache -t gcr.io/$PROJECT_ID/$IMAGE .
  docker push gcr.io/$PROJECT_ID/$IMAGE
}

function deploy_cloud_run() {

  echo "Deploying to Google Cloud Run..." 
  gcloud run deploy exec-api \
  --project=$PROJECT_ID \
  --image gcr.io/$PROJECT_ID/$IMAGE:latest \
  --platform managed \
  --no-cpu-throttling \
  --region $REGION \
  --allow-unauthenticated \
  --memory 2Gi \
  --cpu 2 \
  --set-env-vars "FLASK_TOKEN=${FLASK_TOKEN}"
}

docker_build
deploy_cloud_run

