#!/bin/bash
IMAGE_KEY="small"
IMAGE_NAME="demoSpringBoot/$IMAGE_KEY-image"
CONTAINER_NAME="springboot"

docker container stop $CONTAINER_NAME
docker container rm $CONTAINER_NAME
docker run --name $CONTAINER_NAME -p 8080:8080 -d $IMAGE_NAME







