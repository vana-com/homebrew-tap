#!/usr/bin/env bash
set -euo pipefail

REPO="${VANA_RELEASE_REPO:-vana-com/vana-connect}"
TAG="${VANA_RELEASE_TAG:-canary-feat-connect-cli-v1}"
FORMULA_URL="${VANA_FORMULA_URL:-https://github.com/${REPO}/releases/download/${TAG}/vana.rb}"
DESTINATION="${VANA_FORMULA_DESTINATION:-Formula/vana.rb}"

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

curl --retry 8 --retry-delay 2 --retry-all-errors -fsSL "$FORMULA_URL" -o "$tmp_file"

if [ -f "$DESTINATION" ] && cmp -s "$tmp_file" "$DESTINATION"; then
  echo "Formula already up to date."
  exit 0
fi

mkdir -p "$(dirname "$DESTINATION")"
mv "$tmp_file" "$DESTINATION"
echo "Updated $DESTINATION from $FORMULA_URL"
