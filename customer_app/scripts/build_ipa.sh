#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../" || exit 1

if ! command -v flutter &>/dev/null; then
  echo "Flutter not found in PATH. Exiting."
  exit 1
fi

echo "Building iOS release (no codesign)..."
flutter build ios --release --no-codesign

APP_PATH=$(find build/ios -type d -name "*.app" | head -n 1 || true)
if [ -z "$APP_PATH" ]; then
  echo "Could not find built .app in build/ios. Listing for debug:"
  find build/ios -maxdepth 4 -print
  exit 1
fi

IPA_DIR=build/ipa
mkdir -p "$IPA_DIR"
PAYLOAD_DIR=$(mktemp -d)
mkdir -p "$PAYLOAD_DIR/Payload"
cp -R "$APP_PATH" "$PAYLOAD_DIR/Payload/"

IPA_NAME="customer_app-unsigned.ipa"
pushd "$PAYLOAD_DIR" >/dev/null
zip -qr "$IPA_NAME" Payload
mv "$IPA_NAME" "$OLDPWD/$IPA_DIR/"
popd >/dev/null

rm -rf "$PAYLOAD_DIR"

echo "Unsigned IPA created at: $IPA_DIR/$IPA_NAME"
