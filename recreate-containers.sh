#!/usr/bin/env bash
sudo docker-compose stop
sudo docker-compose rm -f

sudo docker-compose up -d
sudo docker-compose logs -f

