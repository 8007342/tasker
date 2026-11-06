#!/usr/bin/env bash
# Runs on Cloudflare Workers Builds (npm run build): fetch the pinned Flutter if the
# machine has none, then test and build. A failing test stops the deploy.
set -euo pipefail
cd "$(dirname "$0")/.."
if ! command -v flutter >/dev/null 2>&1; then
    dir="${FLUTTER_HOME:-$HOME/flutter}"
    [ -x "$dir/bin/flutter" ] || git clone --quiet --depth 1 --branch "$(cat .flutter-version)" \
        https://github.com/flutter/flutter.git "$dir"
    export PATH="$dir/bin:$PATH"
    flutter config --no-analytics >/dev/null
fi
flutter pub get
flutter test
bash tool/build_web.sh
