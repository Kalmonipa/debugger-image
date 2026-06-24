#!/bin/bash
set -euo pipefail
SEMVER_REGEX="^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-((0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(\.(0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(\+([0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*))?$"
IMAGE_NAME="docker.io/kalmonipa/debugger-image"
PLATFORMS="linux/amd64,linux/arm64"

if command -v podman &>/dev/null; then
    CONTAINER_TOOL="podman"
else
    CONTAINER_TOOL="docker"
fi

if [[ ! "${1:-}" =~ $SEMVER_REGEX ]]; then
    echo "ERROR: '$1' is not a valid semver version (e.g. 1.2.3)"
    exit 1
fi

# A plain `build`/`push` can only ship the host's native architecture, which
# produces a single-arch image and "exec format error" on mismatched nodes.
# Build a real multi-arch manifest list and push that instead.
if [[ "$CONTAINER_TOOL" == "podman" ]]; then
    podman manifest rm "$IMAGE_NAME:$1" 2>/dev/null || true
    podman build --platform "$PLATFORMS" --manifest "$IMAGE_NAME:$1" .
    podman manifest push --all "$IMAGE_NAME:$1" "docker://$IMAGE_NAME:$1"
    podman manifest push --all "$IMAGE_NAME:$1" "docker://$IMAGE_NAME:latest"
else
    # Requires a buildx builder (docker buildx create --use) for multi-arch.
    docker buildx build --platform "$PLATFORMS" \
        --tag "$IMAGE_NAME:$1" --tag "$IMAGE_NAME:latest" --push .
fi

git tag --annotate "$1" --message "Version $1"
git push origin "$1"
