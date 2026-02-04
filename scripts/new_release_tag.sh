#!/bin/bash

# new_release_tag.sh
# Script to generate a new Git tag for releases based on the latest release date and build number.

set -euo pipefail

# Get today's date in YYMMDD format
TODAY=$(date -u +"%y%m%d")

# Get the latest tag of the format v0.YYMMDD.*
# git tag --list "v0.${TODAY}.*" lists all tags for today's date
# sort -V sorts them as version numbers (e.g., v0.260122.9 before v0.260122.10)
# tail -n 1 gets the last line (the latest tag)
LATEST_TODAY_TAG=$(git tag --list "v0.${TODAY}.*" | sort -V | tail -n 1)

NEW_TAG=""

if [ -z "$LATEST_TODAY_TAG" ]; then
    # If no tag exists for today's date, set build number to 1
    NEW_TAG="v0.${TODAY}.1"
else
    # If a tag exists for today's date, increment the build number
    # v0.260122.1 -> 1
    LAST_BUILD_NUMBER=$(echo "$LATEST_TODAY_TAG" | awk -F'.' '{print $NF}')
    NEW_BUILD_NUMBER=$((LAST_BUILD_NUMBER + 1))
    NEW_TAG="v0.${TODAY}.${NEW_BUILD_NUMBER}"
fi

# Output the generated new tag name
echo "$NEW_TAG"
