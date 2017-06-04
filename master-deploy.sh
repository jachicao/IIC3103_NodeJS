#!/bin/bash

cd "/home/administrator/master"

git checkout master

git fetch --all

git reset --hard origin/master

rm log/production.log
rm log/sidekiq.log

docker system prune -f

docker-compose -f master-docker-compose.yml build

docker-compose -f master-docker-compose.yml down

docker-compose -f master-docker-compose.yml up -d --remove-orphans

#docker-compose -f master-docker-compose.yml exec web rails db:create

docker-compose -f master-docker-compose.yml exec web rails db:migrate

#docker-compose -f master-docker-compose.yml exec web rails db:seed

docker-compose -f master-docker-compose.yml exec web bundle exec sidekiq -C config/sidekiq.yml -d

exit 0