# Android Screenshots Guide

## Play Store Requirements

### Phone Screenshots
- **Required**: Minimum 2, Maximum 8
- **Recommended Size**: 1080x1920 (16:9 portrait) or 1920x1080 (16:9 landscape)
- **Format**: PNG or JPEG
- **Max File Size**: 8MB per screenshot

### Tablet Screenshots (Optional)
- **7-inch**: 1200x1920 or 1920x1200
- **10-inch**: 1600x2560 or 2560x1600

## Method 1: Automated Screenshots (Recommended)

### Prerequisites

1. **Start an emulator**:
   ```bash
   # List available emulators
   emulator -list-avds

   # Start a Pixel emulator
   emulator -avd Pixel_7_API_34 &
   ```

2. **Or connect a physical device** via USB with debugging enabled

### Generate Screenshots

```bash
cd android
bundle exec fastlane screenshots_generate
```

This will:
1. Build a debug APK
2. Run integration tests
3. Capture screenshots automatically

### Organize Screenshots

Screenshots will be saved to the device. You need to:

1. **Pull screenshots from device/emulator**:
   ```bash
   adb shell ls /sdcard/Pictures/
   adb pull /sdcard/Pictures/screenshot_*.png ./screenshots/
   ```

2. **Organize into fastlane structure**:
   ```bash
   # Copy to English directory
   cp screenshots/01_*.png fastlane/metadata/android/en-US/images/phoneScreenshots/

   # Copy to Korean directory
   cp screenshots/01_*.png fastlane/metadata/android/ko-KR/images/phoneScreenshots/
   ```

## Method 2: Manual Screenshots

### Steps

1. **Run the app on emulator/device**:
   ```bash
   flutter run
   ```

2. **Navigate to each screen**:
   - Home screen (trip list)
   - Create trip screen
   - Expense list
   - Statistics/charts
   - Settings

3. **Capture screenshots**:
   - **Emulator**: Click camera icon in emulator toolbar
   - **Physical device**: Power + Volume Down
   - **ADB command**: `adb shell screencap -p /sdcard/screenshot.png`

4. **Pull and organize**:
   ```bash
   adb pull /sdcard/screenshot.png ./fastlane/metadata/android/en-US/images/phoneScreenshots/01_home.png
   ```

## Recommended Screenshots

Create at least these 5 screenshots:

1. **Home Screen** - Trip list with sample data
2. **Trip Detail** - Expense list with multiple entries
3. **Statistics** - Pie chart showing expense breakdown
4. **Budget Overview** - Budget tracking with visual indicators
5. **Settings** - Premium/settings screen

## File Naming Convention

Use sequential numbering:
```
01_home_screen.png
02_trip_detail.png
03_statistics.png
04_budget_tracking.png
05_settings.png
```

## Screenshot Tips

- **Use sample data**: Create realistic-looking trips and expenses
- **Show key features**: Highlight multi-currency, charts, budget tracking
- **Clean UI**: Hide navigation bar if possible
- **Consistent locale**: Use same language for all screenshots in a locale
- **Avoid personal info**: Don't include real trip names or amounts

## Directory Structure

```
android/fastlane/metadata/android/
├── en-US/
│   ├── title.txt
│   ├── short_description.txt
│   ├── full_description.txt
│   └── images/
│       └── phoneScreenshots/
│           ├── 01_home_screen.png
│           ├── 02_trip_detail.png
│           ├── 03_statistics.png
│           ├── 04_budget_tracking.png
│           └── 05_settings.png
└── ko-KR/
    ├── title.txt
    ├── short_description.txt
    ├── full_description.txt
    └── images/
        └── phoneScreenshots/
            ├── 01_home_screen.png
            ├── 02_trip_detail.png
            ├── 03_statistics.png
            ├── 04_budget_tracking.png
            └── 05_settings.png
```

## Uploading Screenshots

### Via Fastlane

```bash
cd android
bundle exec fastlane screenshots
```

### Via Play Console

1. Go to Play Console → Your app → Store presence → Main store listing
2. Scroll to "Screenshots" section
3. Select device type (Phone, 7-inch tablet, 10-inch tablet)
4. Upload PNG/JPEG files
5. Drag to reorder
6. Save

## Troubleshooting

### Integration test fails

- Make sure emulator/device is running
- Check that app builds: `flutter build apk --debug`
- Run test manually: `flutter drive --target=integration_test/screenshot_test.dart`

### Screenshots not found

- Check device storage: `adb shell ls /sdcard/Pictures/`
- Look in DCIM folder: `adb shell ls /sdcard/DCIM/Screenshots/`
- Try manual screencap: `adb shell screencap -p /sdcard/test.png`

### Wrong screen size

- Check emulator settings
- Use standard Pixel devices (Pixel 7, Pixel 7 Pro)
- Resize manually: `convert input.png -resize 1080x1920 output.png` (ImageMagick)
