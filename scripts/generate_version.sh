#!/bin/bash
# Generate version.json file with build information
# This script should be run before building the application

set -e

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

# Target file path for version.json
VERSION_JSON="$PROJECT_ROOT/apps/desktop/assets/version.json"

# Get Git information
COMMIT_HASH=$(git -C "$PROJECT_ROOT" rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_DATE=$(date -u +"%Y-%m-%d")

# Parse current date for version
YEAR=$(date -u +"%y")
MONTH=$(date -u +"%m")
DAY=$(date -u +"%d")

# Read stage from environment or default to "Alpha"
STAGE="${VERSION_STAGE:-Alpha}"

# Read build number from environment or default to 1
BUILD_NUMBER="${VERSION_BUILD:-1}"

# Get Flutter version
FLUTTER_VERSION=$(flutter --version 2>/dev/null | head -1 | sed 's/Flutter //' | sed 's/ .*//' || echo "unknown")

# Create the assets directory if it doesn't exist
mkdir -p "$(dirname "$VERSION_JSON")"

# Create version.json
cat > "$VERSION_JSON" << EOF
{
  "stage": "$STAGE",
  "major": 0,
  "year": $YEAR,
  "month": $MONTH,
  "day": $DAY,
  "build": $BUILD_NUMBER,
  "commitHash": "$COMMIT_HASH",
  "buildDate": "$BUILD_DATE",
  "flutterVersion": "$FLUTTER_VERSION"
}
EOF

echo "Generated version.json:"
cat "$VERSION_JSON"

