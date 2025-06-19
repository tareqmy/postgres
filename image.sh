#!/bin/bash
set -e

. ./.env

docker build \
  --build-arg TAG=$TAG \
  -t postgres:$TAG .