#!/bin/bash

# Load environment variables from .env file
. ./.env

# create and use a buildx buildx
docker buildx create --use --name multi-builder
docker buildx inspect --bootstrap

# build and push multi-platform image
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t tareqmy/postgres:latest \
  --push .

# build and push multi-platform image with tag
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t tareqmy/postgres:${TAG} \
  --push .
