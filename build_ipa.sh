#!/usr/bin/env bash
set -euo pipefail

# Convenience wrapper to build an unsigned IPA that can be installed via TrollStore.
#
# Usage:
#   ./build_ipa.sh customer
#   ./build_ipa.sh driver
#
# Optional env vars (passed through to the app scripts):
#   BUNDLE_ID="sa.example.naql.customer" APP_DISPLAY_NAME="نقل الأثاث"

APP="${1:-}"
if [ -z "$APP" ] || { [ "$APP" != "customer" ] && [ "$APP" != "driver" ]; }; then
  echo "Usage: $0 {customer|driver}"
  exit 1
fi

case "$APP" in
  customer)
    pushd customer_app >/dev/null
    ./scripts/prepare_ios.sh
    ./scripts/build_ipa.sh
    popd >/dev/null
    ;;
  driver)
    pushd driver_app >/dev/null
    ./scripts/prepare_ios.sh
    ./scripts/build_ipa.sh
    popd >/dev/null
    ;;
esac

echo "Done. Look for the IPA under: <app>/build/ipa/*.ipa"
