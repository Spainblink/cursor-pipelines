#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PIPELINES_ROOT="${ROOT}/pipelines"
CURSOR="${HOME}/.cursor"
PIPELINE="${1:-}"

usage() {
  echo "Usage: ./install.sh <pipeline-name>"
  echo
  echo "Available pipelines:"
  if [[ -d "${PIPELINES_ROOT}" ]]; then
    find "${PIPELINES_ROOT}" -mindepth 1 -maxdepth 1 -type d -printf "  - %f\n" 2>/dev/null \
      || find "${PIPELINES_ROOT}" -mindepth 1 -maxdepth 1 -type d | while read -r d; do echo "  - $(basename "$d")"; done
  else
    echo "  (none — create pipelines/<name>/)"
  fi
}

if [[ -z "${PIPELINE}" ]]; then
  usage
  exit 1
fi

SRC="${PIPELINES_ROOT}/${PIPELINE}"
if [[ ! -d "${SRC}" ]]; then
  echo "Pipeline not found: ${SRC}" >&2
  usage
  exit 1
fi

for part in agents commands rules; do
  from="${SRC}/${part}"
  [[ -d "${from}" ]] || continue
  to="${CURSOR}/${part}"
  mkdir -p "${to}"
  cp -R "${from}/." "${to}/"
  echo "installed ${PIPELINE}/${part} -> ${to}"
done

plugins_local="${SRC}/plugins/local"
if [[ -d "${plugins_local}" ]]; then
  to_plugins="${CURSOR}/plugins/local"
  mkdir -p "${to_plugins}"
  for plugin_dir in "${plugins_local}"/*; do
    [[ -d "${plugin_dir}" ]] || continue
    name="$(basename "${plugin_dir}")"
    dest="${to_plugins}/${name}"
    rm -rf "${dest}"
    cp -R "${plugin_dir}" "${dest}"
    echo "installed ${PIPELINE}/plugins/local/${name} -> ${dest}"
  done
fi

echo
echo "Done: pipeline '${PIPELINE}' applied to ${CURSOR}"
echo "Reload Cursor window, then try /php-js-pipeline (for php-js)."
