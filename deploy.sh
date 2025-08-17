#!/bin/bash
set -e

. ./.env

# this is to test run the image built locally
docker run -d \
  --name postgres_test \
  -e POSTGRES_USER=root \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=mydb \
  -e LOG_CONNECTIONS=on \
  -e DB_APP_USER=appuser \
  -e DB_APP_PASS=apppass \
  -p 5432:5432 \
  postgres:$TAG
