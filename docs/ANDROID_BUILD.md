# FLORIPPLE Android builds

| Setting | Value |
| --- | --- |
| Display name | FLORIPPLE |
| Package | `com.rekixo.floripple` |
| Minimum Android API | 24 |
| Target Android API | 36 |
| Rendering | Godot GL Compatibility |
| Orientation | Portrait |
| Debug architectures | arm64-v8a, x86_64 |
| Play architecture | arm64-v8a |

## Toolchain

Use Godot 4.7.2 with matching Android export templates, OpenJDK 17, Android SDK platform 36, and Android build-tools 36.0.0. Set the SDK and Java paths in **Editor Settings → Export → Android**. With the Flatpak build of Godot, the bundled JDK extension can be configured at `/usr/lib/sdk/openjdk17/jvm/openjdk-17` inside the sandbox.

The standalone debug template supplies its own API levels. The Gradle release preset explicitly sets API 24 and 36. The application requests vibration permission for optional haptics. Game logic, daily generation, audio, and saves run locally.

## Debug APK

From the project root, run:

```sh
mkdir -p build
touch build/.gdignore
godot --headless --path . --export-debug "Android Debug APK" "$PWD/build/FLORIPPLE-debug.apk"
adb install -r build/FLORIPPLE-debug.apk
adb shell am start -n com.rekixo.floripple/com.godot.game.GodotAppLauncher
```

If your system uses the Godot Flatpak, replace `godot` with `flatpak run org.godotengine.Godot`. The debug preset uses the editor's debug keystore. Check that Godot can access that key from the configured editor environment.

Verify the APK before distribution:

```sh
apksigner verify --verbose build/FLORIPPLE-debug.apk
aapt dump badging build/FLORIPPLE-debug.apk
zipalign -c -P 16 4 build/FLORIPPLE-debug.apk
```

## Signed Play AAB

Use the Android build template installed by Godot and select the **Android Play AAB** preset. Supply your private Play upload keystore, its key alias, and its password through the editor or secure environment variables. Godot reads `GODOT_ANDROID_KEYSTORE_RELEASE_PATH`, `GODOT_ANDROID_KEYSTORE_RELEASE_USER`, and `GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD`. Keep these values outside Git.

```sh
godot --headless --path . --install-android-build-template \
  --export-release "Android Play AAB" "$PWD/build/FLORIPPLE-release.aab"
```

For local unsigned verification, copy the project into a separate directory and set `package/signed=false` for the Play preset in that copy. Export with the same command and use `FLORIPPLE-unsigned.aab` as the output filename. For a Play upload, use the signed export and validate the bundle with `bundletool validate --bundle=build/FLORIPPLE-release.aab`.

## Repeatable verification

```sh
godot --headless --path . --editor --import
godot --headless --path . --script tests/rules.gd
godot --headless --path . --script tests/ui.gd
godot --headless --path . --script tests/balance.gd
mkdir -p build/qa
FLORIPPLE_SCREENSHOTS="$PWD/build/qa" godot --path . --script tests/ui.gd
```

The rules suite replays a winning sequence for every published level, along with daily samples, and checks score, Echo, chain resolution, and save recovery. The UI suite uses Godot viewport pointer events and a separate test save. The simulation compares five strategies on the production rules. Its Endless runs stop at 100 moves.

Daily puzzles use UTC dates and a deterministic map and orientation derived from the date. Saves store the complete stable state, including RNG and tray, with a version, checksum, temporary-file replacement, and a previous-save backup. Android force-stop after a committed move can be tested by returning to the home screen and using **Continue garden** on relaunch.

For a physical-device pass, test gestures near cutouts, background and resume, headphones and haptics, and frame pacing across graphics presets.
