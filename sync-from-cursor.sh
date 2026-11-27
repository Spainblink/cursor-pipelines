#!/usr/bin/env bash
set -euo pipefail
DST="$(cd "$(dirname "$0")" && pwd)"
SRC="${HOME}/.cursor"

for rel in agents commands rules plugins/local/global-dev-rules; do
  if [[ ! -d "${SRC}/${rel}" ]]; then
    echo "skip missing: ${SRC}/${rel}" >&2
    continue
  fi
  mkdir -p "${DST}/${rel}"
  cp -R "${SRC}/${rel}/." "${DST}/${rel}/"
  echo "synced ${rel} <- ${SRC}/${rel}"
done

echo
echo "Done. Review git status and commit with your personal account."
