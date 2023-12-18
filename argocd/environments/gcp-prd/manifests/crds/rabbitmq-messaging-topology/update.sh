#!/bin/bash
set -e
CRDS_VERSION="v1.12.0"

for file in `ls | grep -E 'yml|yaml'`
do
  CRDS_OLD_VERSION=$(echo $file | awk -F'.' '{print $1"."$2"."$3}')
  CRDS_NAME=$(echo $file | grep -v "$CRDS_VERSION" | sed "s/$CRDS_OLD_VERSION\.//g")
  echo "Downloading ${CRDS_VERSION}.${CRDS_NAME}"
  #WARNING the crd is taken from bitnami charts repo
  #bitnami doesnt use versioning in its chart repo
  #so we get only the version from main
  #you need to check yourself to what version you are updating
  curl -L -s -o "${CRDS_VERSION}.${CRDS_NAME}" https://raw.githubusercontent.com/bitnami/charts/main/bitnami/rabbitmq-cluster-operator/crds/crds-messaging-topology-operator.yaml
  echo "Removing ${CRDS_OLD_VERSION}.${CRDS_NAME}"
  rm "${CRDS_OLD_VERSION}.${CRDS_NAME}"
done
