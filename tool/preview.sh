#!/usr/bin/env bash
# Assembles preview-site/, a self-contained copy for the forge's local preview: same Worker and
# build, a local database id and no production route. Deploys use the root wrangler.jsonc.
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf preview-site/public preview-site/worker
mkdir -p preview-site
cp -r build/web preview-site/public
cp -r worker preview-site/worker
cat > preview-site/wrangler.jsonc <<'JSON'
{
  "name": "tasker-preview",
  "main": "worker/index.js",
  "compatibility_date": "2026-11-05",
  "assets": {
    "directory": "public",
    "binding": "ASSETS",
    "not_found_handling": "single-page-application",
    "run_worker_first": ["/api/*"]
  },
  "d1_databases": [{ "binding": "DB", "database_name": "tasker", "database_id": "local-preview" }]
}
JSON
