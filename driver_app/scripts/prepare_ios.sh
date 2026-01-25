#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../" || exit 1
if ! command -v flutter &>/dev/null; then
  echo "Flutter not found in PATH. Exiting."
  exit 1
fi
echo "Running flutter pub get..."
flutter pub get
if [ ! -d "ios" ]; then
  echo "iOS folder not found — running flutter create ."
  flutter create .
fi
if [ -d "ios" ]; then
  pushd ios >/dev/null
  pod install --repo-update || pod install || true
  popd >/dev/null
fi
mkdir -p build/ipa
echo "Preparation complete for driver_app."
