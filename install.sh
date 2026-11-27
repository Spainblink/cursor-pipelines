#!/usr/bin/env bash
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
DST="${HOME}/.cursor"

for rel in agents commands rules plugins/local/global-dev-rules; do
  mkdir -p "${DST}/${rel}"
  cp -R "${SRC}/${rel}/." "${DST}/${rel}/"
  echo "installed ${rel} -> ${DST}/${rel}"
done

echo
echo "Done. Reload Cursor window, then try /php-js-pipeline"
