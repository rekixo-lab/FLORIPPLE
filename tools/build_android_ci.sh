#!/usr/bin/env bash
set -euo pipefail

: "${ANDROID_HOME:?Set ANDROID_HOME to the Android SDK path}"
: "${JAVA_HOME:?Set JAVA_HOME to JDK 17}"
scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
export XDG_CONFIG_HOME="$scratch/config"
mkdir -p "$XDG_CONFIG_HOME/godot" build
touch build/.gdignore

# Godot reads its SDK settings from the runner's editor configuration.
cat > "$XDG_CONFIG_HOME/godot/editor_settings-4.7.tres" <<SETTINGS
[gd_resource type="EditorSettings" format=3]

[resource]
export/android/android_sdk_path = "$ANDROID_HOME"
export/android/java_sdk_path = "$JAVA_HOME"
SETTINGS

export GODOT_ANDROID_KEYSTORE_DEBUG_PATH="$scratch/debug.keystore"
export GODOT_ANDROID_KEYSTORE_DEBUG_USER=androiddebugkey
export GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD=android
"$JAVA_HOME/bin/keytool" -genkeypair -noprompt -keystore "$GODOT_ANDROID_KEYSTORE_DEBUG_PATH" \
  -alias "$GODOT_ANDROID_KEYSTORE_DEBUG_USER" -storepass android -keypass android \
  -dname 'CN=Floripple CI Debug' -keyalg RSA -keysize 2048 -validity 3650

apk="$PWD/build/FLORIPPLE-debug.apk"
aab="$PWD/build/FLORIPPLE-unsigned.aab"
godot --headless --path . --export-debug 'Android Debug APK' "$apk"

# Use a disposable copy so CI can build an unsigned AAB with the Play preset.
mkdir -p "$scratch/project"
cp -R assets game scenes ui project.godot export_presets.cfg "$scratch/project/"
sed -i 's/^package\/signed=true$/package\/signed=false/' "$scratch/project/export_presets.cfg"
godot --headless --path "$scratch/project" --install-android-build-template \
  --export-release 'Android Play AAB' "$aab"

build_tools="$ANDROID_HOME/build-tools/36.0.0"
"$build_tools/apksigner" verify "$apk"
"$build_tools/zipalign" -c -P 16 4 "$apk"
"$build_tools/aapt" dump badging "$apk" > "$scratch/apk-badging"
grep -q "^package: name='com.rekixo.floripple'" "$scratch/apk-badging"
grep -qx "targetSdkVersion:'36'" "$scratch/apk-badging"
unzip -tq "$aab"
unzip -Z1 "$aab" > "$scratch/aab-entries"
grep -qx 'base/manifest/AndroidManifest.xml' "$scratch/aab-entries"
grep -qx 'base/lib/arm64-v8a/libgodot_android.so' "$scratch/aab-entries"
