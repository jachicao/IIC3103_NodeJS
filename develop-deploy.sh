#!/bin/bash

cd "/home/administrator/develop"

git checkout develop

git fetch --all

git reset --hard origin/develop

rm -rf log

docker system prune -f

docker-compose -f develop-docker-compose.yml build

docker-compose -f develop-docker-compose.yml down

docker-compose -f develop-docker-compose.yml up -d --remove-orphans

sleep 5s

#docker-compose -f develop-docker-compose.yml exec develop-web rails db:create

docker-compose -f develop-docker-compose.yml exec develop-web rails db:migrate

#docker-compose -f develop-docker-compose.yml exec develop-web rails db:seed

docker-compose -f develop-docker-compose.yml exec develop-web bundle exec sidekiq -C config/sidekiq.yml -d

exit 0
