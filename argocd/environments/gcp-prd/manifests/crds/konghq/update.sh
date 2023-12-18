#!/bin/bash
set -e
CRDS_VERSION="v2.11.0"

#We download crds from official konghq chart
#chart version does not match kong ingress version
#so we need to introduce additional var here
HELM_CHART_VERSION="2.27.0"

for file in `ls | grep -E 'yml|yaml'`
do
  CRDS_OLD_VERSION=$(echo $file | awk -F'.' '{print $1"."$2"."$3}')
  CRDS_NAME=$(echo $file | grep -v "$CRDS_VERSION" | sed "s/$CRDS_OLD_VERSION\.//g")
  echo "Downloading ${CRDS_VERSION}.${CRDS_NAME}"
  curl -s -o "${CRDS_VERSION}.${CRDS_NAME}" https://raw.githubusercontent.com/Kong/charts/kong-${HELM_CHART_VERSION}/charts/kong/crds/${CRDS_NAME}
  echo "Removing ${CRDS_OLD_VERSION}.${CRDS_NAME}"
  rm "${CRDS_OLD_VERSION}.${CRDS_NAME}"
done
