# Emberfall MOBA Prototype 0.1

A small, original 3D MOBA-style Android prototype built with Godot 4.3.

## Current prototype features
- Procedurally generated 3D arena, stone lane, trees, boundary rocks and crystal objective
- Blue player warrior with a sword
- Four red enemy guardians that chase and attack
- Basic melee attack with range and cooldown
- Health bar and victory status
- Keyboard controls and on-screen touch buttons

## Controls
- PC: WASD or arrow keys to move; Space is not yet mapped, use the on-screen ATTACK button.
- Touch: use the arrow buttons and ATTACK button.

## Open the project
1. Install Godot Engine 4.3 or a compatible Godot 4.x release on a Windows, macOS or Linux computer.
2. Extract the ZIP.
3. In Godot, choose Import and select `project.godot`.
4. Press Play.

## Android export
This ZIP is the editable source project, not a signed APK/AAB yet.
To export to Android, install Godot export templates and configure the Android SDK/JDK in Godot Editor, then create an Android export preset and build an APK/AAB.

## Next development milestones
- Add hero skill buttons and skill effects
- Add minion waves, towers and a base objective
- Add hero selection and item shop
- Improve character models, animation and environment art
- Add match flow, sound and performance optimization
- Add multiplayer only after the offline game is stable

All names, models and gameplay in this prototype are original placeholders.


## Cloud Android build from a phone (GitHub Actions)
This project includes `.github/workflows/android.yml` and `export_presets.cfg`.
1. Create a GitHub repository named `emberfall-moba` (a public repository is easiest for a free starter workflow).
2. Upload the contents of this ZIP to the repository root. Make sure `project.godot`, `export_presets.cfg`, `scripts/`, and `.github/` are at the root.
3. Open the repository's Actions tab and enable Actions if prompted.
4. Select **Build Android APK** and tap **Run workflow** (or push to `main`).
5. When the workflow finishes successfully, open that run, find **Artifacts**, and download `Emberfall-Android-debug-APK`.
6. Extract the artifact ZIP on your phone; tap the APK to install. Android may ask you to allow your browser/files app to install unknown apps.

This is a debug APK for personal testing, not a Play Store release. Do not put passwords, signing keys, or other secrets in the repository. The workflow uses GitHub-hosted runners and public Godot/Android build tools. A successful build is not guaranteed until the project is actually run through the workflow; check the Actions logs if it fails.
