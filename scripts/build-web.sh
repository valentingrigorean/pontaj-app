#!/bin/bash

# Build Flutter web for GitHub Pages
# Usage: ./scripts/build-web.sh [repo-name]

REPO_NAME=${1:-pontaj-app}

echo "Building Flutter web for repository: $REPO_NAME"

flutter build web --release --base-href "/$REPO_NAME/"

echo ""
echo "Build complete! Output in build/web/"
echo "To test locally with correct base href, use:"
echo "  cd build/web && python3 -m http.server 8000"
echo ""
echo "For local testing without base-href, run:"
echo "  flutter build web --release"
echo "  cd build/web && python3 -m http.server 8000"
