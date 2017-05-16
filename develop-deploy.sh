#!/bin/bash

cd "/home/administrator/develop"

git stash save --keep-index

git clean -df

git checkout develop

git pull

docker-compose -f develop-docker-compose.yml build

docker-compose -f develop-docker-compose.yml down

docker-compose -f develop-docker-compose.yml up -d --remove-orphans

docker-compose -f develop-docker-compose.yml exec develop-web rake db:create

docker-compose -f develop-docker-compose.yml exec develop-web rake db:migrate

docker-compose -f develop-docker-compose.yml exec develop-web rake db:seed

#docker-compose -f develop-docker-compose.yml exec develop-web bundle exec sidekiq -C config/sidekiq.yml -d

exit 0