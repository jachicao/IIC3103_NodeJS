#!/bin/bash

cd "/home/administrator/master"

git checkout master

git pull

docker-compose -f master-docker-compose.yml build

docker-compose -f master-docker-compose.yml down

docker-compose -f master-docker-compose.yml up -d --remove-orphans

docker-compose -f master-docker-compose.yml exec web rake db:create

docker-compose -f master-docker-compose.yml exec web rake db:migrate

docker-compose -f master-docker-compose.yml exec web rake db:seed

exit 0