# FLORIPPLE — Android Build Setup

## Identity (fixed)

| Setting | Value |
| --- | --- |
| Godot project title | `FLORIPPLE` |
| Android launcher display name | `FLORIPPLE` |
| Game name in documentation | `Floripple` |
| Package / application ID | `com.rekixo.floripple` |
| Version | `0.1.0` |
| Orientation | Portrait |
| Android target SDK | 36 |
| Android min SDK | 24 |

The app ID is configured in both Android export presets, rather than only documented in README. Do not change the package ID after publishing: Google Play treats a new package ID as a different app.

## Project scope

This commit creates a valid Godot project entry scene and export configurations. The entry scene is **only a bootstrap screen**, not the 6×6 production game, and no claim is made that a playable game or finished premium artwork has been implemented. Follow the main README for the complete design specification.

## Open in Godot

1. Install a recent Godot 4 editor with Android export support.
2. Use **Import** in the Godot Project Manager and select `project.godot`.
3. Run the project (F6/F5 as appropriate) to inspect the initial FLORIPPLE branding scene.

## Build a debug APK

1. Install Android SDK and OpenJDK 17, then configure their paths under Godot Editor Settings.
2. Install the matching Godot Android export templates.
3. Choose **Project > Export > Android Debug APK**.
4. Export in debug mode to `build/FLORIPPLE-debug.apk`.
5. Install the resulting APK on a test Android phone.

## Build for Google Play (AAB)

1. In Godot, install the Android build template using **Project > Install Android Build Template**.
2. Choose **Project > Export > Android Play AAB**. Its preset already enables the Gradle build and AAB format.
3. Supply a **private release keystore**, key alias and password in local settings or secure environment variables. Never commit them.
4. Export with debug disabled to `build/FLORIPPLE-release.aab`.
5. Verify the installed app label and package ID; then complete gameplay and store-readiness testing before submitting to Google Play.

For CI, inject signing information through secret environment variables:
`GODOT_ANDROID_KEYSTORE_RELEASE_PATH`, `GODOT_ANDROID_KEYSTORE_RELEASE_USER`, and `GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD`.

The signing key, Android SDK, Godot export templates, Android build template and Godot executable are not bundled with this GitHub repository.

The current `main.tscn` is an identity/bootstrap scene and **must be replaced with the final functional game scene before publication**.
