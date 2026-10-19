#!/usr/bin/env bash
# Validate inputs and build the release body. Inputs come in as env vars
# (never interpolated into the script) so release notes can't inject shell.
set -euo pipefail

[[ "$APP" =~ ^[a-z0-9][a-z0-9-]*$ ]] || { echo "::error::app must be lowercase letters, digits, dashes: '$APP'"; exit 1; }
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+([-+][0-9A-Za-z.-]+)?$ ]] || { echo "::error::version must look like 1.2.3: '$VERSION'"; exit 1; }
TAG="$APP-v$VERSION"

: > files.txt
while IFS= read -r f; do
  f="${f#"${f%%[![:space:]]*}"}"; f="${f%"${f##*[![:space:]]}"}"
  [[ -z "$f" ]] && continue
  [[ -f "dist/$f" ]] || { echo "::error::'$f' is not in the downloaded artifacts:"; ls -la dist; exit 1; }
  echo "dist/$f" >> files.txt
done <<< "$FILES"
[[ -s files.txt ]] || { echo "::error::no files to publish"; exit 1; }

{
  if [[ -n "$NOTES" ]]; then printf '%s\n\n' "$NOTES"; fi
  echo "## Download"
  echo
  if [[ -n "$INSTALL" ]]; then printf '%s\n\n' "$INSTALL"; fi
  echo "Apps that support it remind their users when a newer version is published here."
} > body.md

{
  echo "tag=$TAG"
  echo "files<<__FILES__"
  cat files.txt
  echo "__FILES__"
} >> "${GITHUB_OUTPUT:-/dev/stdout}"
