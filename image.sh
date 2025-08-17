#!/bin/bash
set -e

. ./.env

docker build -t postgres:$TAG .
