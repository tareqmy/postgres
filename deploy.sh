#!/bin/bash
set -e

. ./.env

docker run -d \
  --name postgres_$TAG \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DB \
  -p 5432:5432 \
  postgres:$TAG