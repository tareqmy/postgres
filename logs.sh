#!/bin/bash
set -e

. ./.env

docker exec -it postgres_$TAG bash -c 'tail -f /var/lib/postgresql/data/log/postgresql*.log'
