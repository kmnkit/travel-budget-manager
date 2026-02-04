#!/bin/bash

# App Store Screenshot Automation Script
# This script captures screenshots on multiple iOS simulators

set -e

FLUTTER_BIN="${HOME}/flutter/bin/flutter"
if ! command -v flutter &> /dev/null; then
  FLUTTER_BIN="flutter"
fi

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCREENSHOTS_DIR="$PROJECT_ROOT/ios/fastlane/screenshots"

# Device configurations for App Store
# Format: "Simulator Name|Folder Name|Resolution"
DEVICES=(
  "iPhone 15 Pro Max|iphone_6.7|1290x2796"
  "iPhone 14 Plus|iphone_6.5|1284x2778"
  "iPhone SE (3rd generation)|iphone_5.5|1242x2208"
)

LOCALES=("en-US" "ko")

echo "📱 Starting App Store Screenshot Capture"
echo "========================================"

# Create directories
for locale in "${LOCALES[@]}"; do
  mkdir -p "$SCREENSHOTS_DIR/$locale"
done

# Function to capture screenshots for a device
capture_for_device() {
  local device_name="$1"
  local folder_name="$2"

  echo ""
  echo "📸 Capturing on: $device_name"
  echo "---"

  # Boot simulator
  xcrun simctl boot "$device_name" 2>/dev/null || true

  # Wait for boot
  sleep 5

  for locale in "${LOCALES[@]}"; do
    echo "  🌐 Locale: $locale"

    # Set simulator locale
    if [ "$locale" == "ko" ]; then
      xcrun simctl spawn "$device_name" defaults write -g AppleLocale -string "ko_KR"
      xcrun simctl spawn "$device_name" defaults write -g AppleLanguages -array "ko"
    else
      xcrun simctl spawn "$device_name" defaults write -g AppleLocale -string "en_US"
      xcrun simctl spawn "$device_name" defaults write -g AppleLanguages -array "en"
    fi

    # Run screenshot test
    cd "$PROJECT_ROOT"
    $FLUTTER_BIN drive \
      --driver=test_driver/integration_test.dart \
      --target=integration_test/screenshot_test.dart \
      -d "$device_name" \
      --no-pub \
      2>/dev/null || true

    # Move screenshots to correct folder
    for screenshot in "$PROJECT_ROOT"/build/screenshots/*.png; do
      if [ -f "$screenshot" ]; then
        filename=$(basename "$screenshot")
        mv "$screenshot" "$SCREENSHOTS_DIR/$locale/${folder_name}_${filename}"
        echo "    ✅ Saved: ${folder_name}_${filename}"
      fi
    done
  done

  # Shutdown simulator
  xcrun simctl shutdown "$device_name" 2>/dev/null || true
}

# Main execution
echo ""
echo "⚙️  Building app first..."
cd "$PROJECT_ROOT"
$FLUTTER_BIN build ios --release --no-codesign --simulator

for device_config in "${DEVICES[@]}"; do
  IFS='|' read -r device_name folder_name resolution <<< "$device_config"
  capture_for_device "$device_name" "$folder_name"
done

echo ""
echo "========================================"
echo "✅ Screenshot capture complete!"
echo ""
echo "Screenshots saved to:"
echo "  $SCREENSHOTS_DIR/en-US/"
echo "  $SCREENSHOTS_DIR/ko/"
echo ""
echo "Next steps:"
echo "  cd ios && fastlane screenshots"
