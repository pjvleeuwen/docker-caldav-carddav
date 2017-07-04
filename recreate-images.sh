#!/usr/bin/env bash
sudo docker-compose stop
sudo docker-compose rm -f
sudo docker images -f reference=*-caldav-* -q |sudo xargs docker rmi
sudo docker-compose up -d
sudo docker-compose logs -f

