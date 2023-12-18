#!/bin/bash
IMAGE_PRD="eu.gcr.io/alex-370013/zalando/spilo-15:3.0-p1-2"
IMAGE_DEV="eu.gcr.io/alex-370013/zalando/spilo-15:3.0-p1-2"
docker build -t $IMAGE_DEV . && docker push $IMAGE_DEV
docker build -t $IMAGE_PRD . && docker push $IMAGE_PRD

