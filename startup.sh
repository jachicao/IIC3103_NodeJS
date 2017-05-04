#!/bin/bash

cd "$(dirname "$0")"

cd ..

cd traefik

docker-compose up -d --remove-orphans

exit 0
