#!/bin/bash

cd "/home/administrator/master"

git checkout master

git fetch --all

git reset --hard origin/master

docker-compose -f master-docker-compose.yml build

docker-compose -f master-docker-compose.yml down

docker-compose -f master-docker-compose.yml up -d --remove-orphans

#docker-compose -f master-docker-compose.yml exec web rake db:create

#docker-compose -f master-docker-compose.yml exec web rake db:migrate

#docker-compose -f master-docker-compose.yml exec web rake db:seed

docker-compose -f master-docker-compose.yml exec web bundle exec sidekiq -C config/sidekiq.yml -d

exit 0