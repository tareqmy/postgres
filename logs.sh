#!/bin/bash
set -e

. ./.env

docker exec -it postgres_test bash -c 'tail -f /var/lib/postgresql/data/log/postgresql*.log'
