#!/usr/bin/env bash
# Builds the web app so it works with no connection: CanvasKit is served from this site rather
# than Google's CDN, and tool/gen_sw.mjs writes the service worker that caches the build.
set -euo pipefail
cd "$(dirname "$0")/.."
flutter build web --release --no-web-resources-cdn --pwa-strategy=none
# What this renderer never loads, so it isn't deployed or cached.
rm -rf build/web/flutter_service_worker.js build/web/canvaskit/wimp* build/web/canvaskit/skwasm*
find build/web -name '*.symbols' -delete
node tool/gen_sw.mjs build/web
