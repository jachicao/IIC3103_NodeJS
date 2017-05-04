#!/bin/bash

cd "$(dirname "$0")"

cd ..

cd traefik

docker-compose up -d --remove-orphans

cd ..

cd master

sh master-deploy.sh

cd ..

cd develop

cd develop-deploy.sh

cd ..

exit 0
