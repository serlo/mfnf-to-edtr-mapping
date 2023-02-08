#!/bin/bash

set -e

cd mfnf2serlo/

VERSION="$(cat version)"
TAG="eu.gcr.io/serlo-shared/mfnf2serlo:$VERSION"

docker build . -t $TAG
docker push $TAG