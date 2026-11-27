#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
PIPELINES_ROOT="${ROOT}/pipelines"
CURSOR="${HOME}/.cursor"
PIPELINE="${1:-}"

usage() {
  echo "Usage: ./sync-from-cursor.sh <pipeline-name>"
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

DEST="${PIPELINES_ROOT}/${PIPELINE}"
if [[ ! -d "${DEST}" ]]; then
  echo "Pipeline not found: ${DEST}" >&2
  usage
  exit 1
fi

# Sync owned files under agents/commands/rules
for part in agents commands rules; do
  owned="${DEST}/${part}"
  [[ -d "${owned}" ]] || continue
  while IFS= read -r -d '' file; do
    rel="${file#${owned}/}"
    src="${CURSOR}/${part}/${rel}"
    if [[ -f "${src}" ]]; then
      cp "${src}" "${file}"
      echo "synced ${part}/${rel} <- ${src}"
    else
      echo "missing in Cursor, skip: ${part}/${rel}" >&2
    fi
  done < <(find "${owned}" -type f -print0)
done

# Sync plugin dirs owned by this pipeline
plugins_owned="${DEST}/plugins/local"
if [[ -d "${plugins_owned}" ]]; then
  for plugin_dir in "${plugins_owned}"/*; do
    [[ -d "${plugin_dir}" ]] || continue
    name="$(basename "${plugin_dir}")"
    src_plugin="${CURSOR}/plugins/local/${name}"
    if [[ ! -d "${src_plugin}" ]]; then
      echo "missing plugin in Cursor, skip: ${name}" >&2
      continue
    fi
    rm -rf "${plugin_dir}"
    cp -R "${src_plugin}" "${plugin_dir}"
    echo "synced plugins/local/${name} <- ${src_plugin}"
  done
fi

echo
echo "Done: Cursor -> pipelines/${PIPELINE}"
echo "Review git status and commit with your personal account."
