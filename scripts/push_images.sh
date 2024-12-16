#!/bin/bash
docker tag reciever docker.io/execorn/pdris-docker-reciever:latest
docker push execorn/pdris-docker-reciever:latest

docker tag sender docker.io/execorn/pdris-docker-sender:latest
docker push execorn/pdris-docker-sender:latest
w