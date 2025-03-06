#!/bin/bash
SEMVER_REGEX="^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-((0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\.(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(\+([0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*))?$"
IMAGE_NAME="kalmonipa/debugger-image"

if [[ ! "$1" =~ $SEMVER_REGEX ]]; then
    echo "ERROR: Input is not a valid regex"
    exit 1
fi

docker build --tag $IMAGE_NAME:$1 --tag $IMAGE_NAME:latest .
docker push $IMAGE_NAME:$1
docker push $IMAGE_NAME:latest

git tag --annotate $1 --message "Version $1"
git push $1
