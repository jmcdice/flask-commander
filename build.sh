#!/usr/bin/env bash

source env.sh

function docker_build() {

  docker build --no-cache -t gcr.io/$PROJECT_ID/$IMAGE .
  docker push gcr.io/$PROJECT_ID/$IMAGE
}

function deploy_cloud_run() {

  echo "Deploying to Google Cloud Run..." 
  gcloud run deploy $IMAGE \
  --project=$PROJECT_ID \
  --image gcr.io/$PROJECT_ID/$IMAGE:latest \
  --platform managed \
  --no-cpu-throttling \
  --region $REGION \
  --allow-unauthenticated \
  --memory 1Gi \
  --cpu 1 \
  --set-env-vars "FLASK_TOKEN=${FLASK_TOKEN}"
}

function delete_cloud_run() {
  echo "Deleting Cloud Run Service..."
  gcloud run services delete $IMAGE \
  --project=$PROJECT_ID \
  --platform managed \
  --region $REGION
}

case $1 in
  build)
    docker_build
    ;;
  deploy)
    deploy_cloud_run
    ;;
  delete)
    delete_cloud_run
    ;;
  *)
    echo "Invalid option. Use either 'build', 'deploy' or 'delete'."
    ;;
esac

