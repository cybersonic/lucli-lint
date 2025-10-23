#!/bin/bash
# Get the version from the module.json file use jq
VERSION=$(jq -r '.version' module.json)
echo "Building multi-platform Docker image...'markdrew/lucli-lint:${VERSION}'"

# Create and use buildx builder if it doesn't exist
docker buildx create --name multiarch --use 2>/dev/null || docker buildx use multiarch

# Build multi-platform images
docker buildx build \
    --platform linux/amd64,linux/arm/v7,linux/arm64/v8 \
    -t markdrew/lucli-lint:${VERSION} \
    -t markdrew/lucli-lint:latest \
    --push \
    .
docker pull markdrew/lucli-lint:${VERSION}
docker run --rm markdrew/lucli-lint:latest modules list 
echo "Build complete."
echo "You can now ue the image with 'docker run --rm markdrew/lucli-lint:${VERSION} <module> <command>'"