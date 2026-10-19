#!/usr/bin/env bash
# Write <app>/latest.json on main and push, retrying if another publish won.
set -euo pipefail
cd downloads
git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

BASE="https://github.com/$DOWNLOADS_REPO/releases"
mkdir -p "$APP"
files_json=$(while IFS= read -r p; do
  f=$(basename "$p")
  jq -n --arg name "$f" --arg url "$BASE/download/$TAG/$f" '{($name): $url}'
done < ../files.txt | jq -s 'add')
jq -n \
  --arg version "$VERSION" \
  --arg url "$BASE/tag/$TAG" \
  --arg notes "$NOTES" \
  --arg published "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --argjson files "$files_json" \
  '{version: $version, url: $url, notes: $notes, published: $published, files: $files}' > "$APP/latest.json"
cat "$APP/latest.json"

git add "$APP/latest.json"
git commit -m "$APP $VERSION"
for i in 1 2 3 4 5; do
  if git push origin HEAD:main; then exit 0; fi
  sleep $((i * 3))
  git pull --rebase origin main
done
echo "::error::could not push $APP/latest.json"; exit 1
