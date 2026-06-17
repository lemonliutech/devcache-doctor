#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="DevStorage Doctor"
BUNDLE_NAME="DevStorage Doctor.app"
BINARY_NAME="DevStorageDoctor"
BUILD_CONFIG="${1:-debug}"

cd "$PROJECT_DIR"

echo "→ Building $BINARY_NAME ($BUILD_CONFIG)..."
if [ "$BUILD_CONFIG" = "release" ]; then
    swift build -c release --product "$BINARY_NAME"
    BINARY_PATH="$PROJECT_DIR/.build/release/$BINARY_NAME"
else
    swift build --product "$BINARY_NAME"
    BINARY_PATH="$PROJECT_DIR/.build/debug/$BINARY_NAME"
fi

BUNDLE_PATH="$PROJECT_DIR/$BUNDLE_NAME"
MACOS_DIR="$BUNDLE_PATH/Contents/MacOS"
RESOURCES_DIR="$BUNDLE_PATH/Contents/Resources"

echo "→ Creating .app bundle at $BUNDLE_PATH..."
rm -rf "$BUNDLE_PATH"
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy binary
cp "$BINARY_PATH" "$MACOS_DIR/$BINARY_NAME"

# Copy Info.plist
cp "$PROJECT_DIR/Sources/DevStorageDoctorApp/Info.plist" "$BUNDLE_PATH/Contents/Info.plist"

# Build .icns from the appiconset PNGs
ICONSET_DIR="$(mktemp -d)/AppIcon.iconset"
APPICONSET="$PROJECT_DIR/Sources/DevStorageDoctorApp/Assets.xcassets/AppIcon.appiconset"

mkdir -p "$ICONSET_DIR"
cp "$APPICONSET/icon_16x16.png"   "$ICONSET_DIR/icon_16x16.png"
cp "$APPICONSET/icon_32x32.png"   "$ICONSET_DIR/icon_16x16@2x.png"
cp "$APPICONSET/icon_32x32.png"   "$ICONSET_DIR/icon_32x32.png"
cp "$APPICONSET/icon_64x64.png"   "$ICONSET_DIR/icon_32x32@2x.png"
cp "$APPICONSET/icon_128x128.png" "$ICONSET_DIR/icon_128x128.png"
cp "$APPICONSET/icon_256x256.png" "$ICONSET_DIR/icon_128x128@2x.png"
cp "$APPICONSET/icon_256x256.png" "$ICONSET_DIR/icon_256x256.png"
cp "$APPICONSET/icon_512x512.png" "$ICONSET_DIR/icon_256x256@2x.png"
cp "$APPICONSET/icon_512x512.png" "$ICONSET_DIR/icon_512x512.png"
cp "$APPICONSET/icon_1024x1024.png" "$ICONSET_DIR/icon_512x512@2x.png"

iconutil -c icns "$ICONSET_DIR" -o "$RESOURCES_DIR/AppIcon.icns"

echo "→ Signing ad-hoc..."
codesign --force --deep --sign - "$BUNDLE_PATH"

echo ""
echo "✓ Built: $BUNDLE_PATH"
echo ""
echo "  Run:    open \"$BUNDLE_PATH\""
echo "  Or drag to /Applications"
