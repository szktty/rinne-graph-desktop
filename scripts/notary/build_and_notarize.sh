#!/bin/bash

# build_and_notarize.sh
# Automatically builds, signs, notarizes, and packages macOS applications into a DMG.

# --- Configuration ---
# Exit script on error or if undefined variables are used
set -euo pipefail

# --- Setup ---
# Set working directory to the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APP_DIR="$PROJECT_ROOT/apps/desktop"

# --- Load Environment Variables ---
ENV_FILE="$SCRIPT_DIR/env.sh"
if [ ! -f "$ENV_FILE" ]; then
    echo "❌ Error: Configuration file not found at '$ENV_FILE'."
    echo "Please copy 'env.sh.template' to 'env.sh' and fill in your details."
    exit 1
fi
source "$ENV_FILE"

# --- Resolve Relative Paths from env.sh ---
# If paths in env.sh are relative, resolve them based on the script's directory.
if [[ "$AC_API_KEY_PATH" != /* ]]; then
    AC_API_KEY_PATH="$SCRIPT_DIR/$AC_API_KEY_PATH"
fi
if [[ "$CERTIFICATE_P12_PATH" != /* ]]; then
    CERTIFICATE_P12_PATH="$SCRIPT_DIR/$CERTIFICATE_P12_PATH"
fi

# --- Validate Environment Variables ---
variables_to_check=(
    "AC_API_KEY_ID"
    "AC_API_KEY_ISSUER_ID"
    "AC_API_KEY_PATH"
    "CERTIFICATE_P12_PATH"
    "CERTIFICATE_PASSWORD"
    "BUNDLE_ID"
)
for var_name in "${variables_to_check[@]}"; do
    if [ -z "${!var_name}" ]; then
        echo "❌ Error: Environment variable '$var_name' is not set."
        echo "Please define it in '$ENV_FILE'."
        exit 1
    fi
done

if [ ! -f "$AC_API_KEY_PATH" ]; then
    echo "❌ Error: App Store Connect API Key file not found at '$AC_API_KEY_PATH'."
    exit 1
fi

if [ ! -f "$CERTIFICATE_P12_PATH" ]; then
    echo "❌ Error: Certificate .p12 file not found at '$CERTIFICATE_P12_PATH'."
    exit 1
fi

# --- App Information ---
APP_NAME="RinneGraph"

# Use the release version from the environment if available (set by CI/CD).
# Otherwise, fall back to the version from pubspec.yaml for local builds.
if [ -n "$RELEASE_VERSION" ]; then
    echo "✅ Using release version from environment: $RELEASE_VERSION"
    VERSION_STRING="$RELEASE_VERSION"
else
    echo "ℹ️ No RELEASE_VERSION env var found. Using version from pubspec.yaml."
    VERSION=$(grep '^version:' "$APP_DIR/pubspec.yaml" | awk '{print $2}')
    VERSION_STRING=$(echo "$VERSION" | cut -d+ -f1)
fi

# --- Paths & Directories ---
APP_BUNDLE_PATH="$APP_DIR/build/macos/Build/Products/Release/$APP_NAME.app"
DIST_DIR="$PROJECT_ROOT/build/dist/macos"
DMG_NAME="$APP_NAME-$VERSION_STRING.dmg"
FINAL_DMG_PATH="$DIST_DIR/$DMG_NAME"
TEMP_DIR=$(mktemp -d)
TEMP_KEYCHAIN_NAME="notary.keychain"
TEMP_KEYCHAIN_PATH="$TEMP_DIR/$TEMP_KEYCHAIN_NAME"
TEMP_DMG_PATH="$TEMP_DIR/temp_rw.dmg"
MOUNT_POINT="$TEMP_DIR/mount"

# --- Store Original Keychain ---
ORIGINAL_KEYCHAIN=$(security default-keychain | xargs)
echo "🔑 Original default keychain: $ORIGINAL_KEYCHAIN"

# --- Cleanup Function ---
cleanup() {
    echo "🧹 Cleaning up..."
    if [ -n "$ORIGINAL_KEYCHAIN" ]; then
        echo "   - Restoring original default keychain..."
        security default-keychain -s "$ORIGINAL_KEYCHAIN" || echo "⚠️ Could not restore original keychain."
    fi
    if [ -f "$TEMP_KEYCHAIN_PATH" ]; then
        echo "   - Deleting temporary keychain..."
        security delete-keychain "$TEMP_KEYCHAIN_PATH" || echo "⚠️ Could not delete temporary keychain."
    fi
    if [ -d "$MOUNT_POINT" ] && hdiutil info | grep -q "$MOUNT_POINT"; then
        echo "   - Detaching DMG..."
        hdiutil detach "$MOUNT_POINT" -force || echo "⚠️ Could not detach DMG."
    fi
    if [ -d "$TEMP_DIR" ]; then
        echo "   - Removing temporary directory..."
        rm -rf "$TEMP_DIR"
    fi
    echo "✅ Cleanup finished."
}
trap cleanup EXIT INT TERM

# --- Main Script ---

echo "🚀 Starting notarization process for $APP_NAME"
echo "--------------------------------------------------"
echo "Version: $VERSION_STRING"
echo "Project Root: $PROJECT_ROOT"
echo "App Directory: $APP_DIR"
echo "Distribution Directory: $DIST_DIR"
echo "--------------------------------------------------"

# 1. Prepare for Signing (BEFORE BUILD)
echo "🔑 Setting up temporary keychain for signing..."
security create-keychain -p "$CERTIFICATE_PASSWORD" "$TEMP_KEYCHAIN_PATH"
security set-keychain-settings -lut 21600 "$TEMP_KEYCHAIN_PATH" # Timeout
security default-keychain -s "$TEMP_KEYCHAIN_PATH"
security unlock-keychain -p "$CERTIFICATE_PASSWORD" "$TEMP_KEYCHAIN_PATH"
security import "$CERTIFICATE_P12_PATH" -k "$TEMP_KEYCHAIN_PATH" -P "$CERTIFICATE_PASSWORD" -T /usr/bin/codesign > /dev/null
security set-key-partition-list -S apple-tool:,apple: -s -k "$CERTIFICATE_PASSWORD" "$TEMP_KEYCHAIN_PATH"
CERT_IDENTITY=$(security find-identity -v -p codesigning "$TEMP_KEYCHAIN_PATH" | head -n 1 | awk -F'"' '{print $2}')
echo "✒️ Using signing identity: $CERT_IDENTITY"
echo "✅ Keychain setup complete. Temporary keychain is now default."

# 2. Build Flutter App
echo "📦 Building Flutter application..."
cd "$APP_DIR"
flutter build macos --release
echo "✅ Flutter application built successfully."
cd "$PROJECT_ROOT"

# 3. Verify and Re-sign App Bundle (ensure options are correct)
echo "🖋️ Verifying and re-signing the application bundle with correct options..."
codesign --force --options runtime --deep --sign "$CERT_IDENTITY" --keychain "$TEMP_KEYCHAIN_PATH" --timestamp "$APP_BUNDLE_PATH"
echo "✅ Application bundle signed."

# 4. Create and Sign DMG
echo "💽 Creating and signing DMG..."
mkdir -p "$DIST_DIR"
if [ -f "$FINAL_DMG_PATH" ]; then
    rm "$FINAL_DMG_PATH"
fi
mkdir -p "$MOUNT_POINT"

hdiutil create -o "$TEMP_DMG_PATH" -size 500m -volname "$APP_NAME" -fs HFS+
hdiutil attach "$TEMP_DMG_PATH" -readwrite -noverify -mountpoint "$MOUNT_POINT"

ditto "$APP_BUNDLE_PATH" "$MOUNT_POINT/$APP_NAME.app"
ln -s /Applications "$MOUNT_POINT/Applications"

hdiutil detach "$MOUNT_POINT"
hdiutil convert "$TEMP_DMG_PATH" -format UDZO -imagekey zlib-level=9 -o "$FINAL_DMG_PATH"

codesign --force --sign "$CERT_IDENTITY" --keychain "$TEMP_KEYCHAIN_PATH" --timestamp "$FINAL_DMG_PATH"
echo "✅ DMG created and signed."

# 5. Notarize DMG
echo "🍎 Notarizing the DMG with Apple. This may take a while..."
NOTARY_OUTPUT=$(xcrun notarytool submit "$FINAL_DMG_PATH" \
    --key "$AC_API_KEY_PATH" \
    --key-id "$AC_API_KEY_ID" \
    --issuer "$AC_API_KEY_ISSUER_ID" \
    --wait)

echo "$NOTARY_OUTPUT"

if ! echo "$NOTARY_OUTPUT" | grep -q "status: Accepted"; then
    echo "❌ Notarization failed."
    SUBMISSION_ID=$(echo "$NOTARY_OUTPUT" | grep "id:" | awk '{print $2}')
    if [ -n "$SUBMISSION_ID" ]; then
        echo "Fetching notarization log for submission ID: $SUBMISSION_ID"
        xcrun notarytool log "$SUBMISSION_ID" --key "$AC_API_KEY_PATH" --key-id "$AC_API_KEY_ID" --issuer "$AC_API_KEY_ISSUER_ID"
    fi
    exit 1
fi
echo "✅ DMG notarized successfully."

# 6. Staple Notarization Ticket
echo "📎 Stapling notarization ticket to DMG..."
xcrun stapler staple "$FINAL_DMG_PATH"
echo "✅ Ticket stapled successfully."

# 7. Final Verification
echo "🔍 Verifying the final DMG and its contents..."

# Temporarily mount the final DMG to verify the .app bundle inside
# MOUNT_POINT uses an existing path
echo "  - Mounting DMG: $FINAL_DMG_PATH"
hdiutil attach "$FINAL_DMG_PATH" -readonly -noverify -mountpoint "$MOUNT_POINT" > /dev/null
# Confirm success of `hdiutil attach`
if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to mount DMG."
    exit 1
fi

MOUNTED_APP_PATH="$MOUNT_POINT/$APP_NAME.app"

# Perform verification on the mounted .app bundle
echo "  - Verifying application bundle inside DMG: $MOUNTED_APP_PATH"
spctl -a -vvv -t install "$MOUNTED_APP_PATH"
if [ $? -ne 0 ]; then
    echo "❌ Verification failed for application bundle."
    hdiutil detach "$MOUNT_POINT" -force > /dev/null || true # Detach even on error
    exit 1
fi
echo "✅ Application bundle verification successful."

# xcrun stapler validate is performed on the entire DMG (because the ticket is attached to the DMG)
echo "  - Validating notarization ticket for DMG: $FINAL_DMG_PATH"
xcrun stapler validate "$FINAL_DMG_PATH"
if [ $? -ne 0 ]; then
    echo "❌ Stapler validation failed for DMG."
    hdiutil detach "$MOUNT_POINT" -force > /dev/null || true # Detach even on error
    exit 1
fi
echo "✅ Stapler validation successful for DMG."

# Detach (unmount) the DMG
echo "  - Unmounting DMG."
hdiutil detach "$MOUNT_POINT" -force > /dev/null || true
echo "✅ All verifications successful."

# --- Success ---
echo "🎉 Notarization process completed successfully!"
echo "📦 Your notarized application is available at: $FINAL_DMG_PATH"
