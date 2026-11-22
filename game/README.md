# Almost Hero - Godot prototype

Lightweight Godot 4 side-view 3D action prototype for Android.

## Current prototype
- Fixed side camera that follows the player horizontally.
- Procedural cartoon soldier in green armor and helmet.
- Left/right movement, jump, roll and projectile shooting.
- Touchscreen buttons: left, right, jump, fire and roll.
- Starter corridor with simple obstacles.
- Two patrol enemies with health; projectiles damage them.
- Player health display and contact damage.
- Compatibility renderer (OpenGL ES 3); no external textures or large assets.

## Desktop test controls
- A / Left Arrow: move left
- D / Right Arrow: move right
- Space / W / Up: jump
- S: roll
- Left mouse button / Ctrl: fire

## Android touch controls
- ◀ / ▶: move
- JUMP: jump
- FIRE: shoot
- ROLL: roll

## Target test device
Realme C11 (2021), Android 11, 2 GB RAM.

## Current status
The project files are committed, but the scene has not yet been launched in the Godot editor or exported to an APK. Engine validation and device testing are still required.

## Next steps
1. Open this folder in Godot 4 and validate the scene/scripts.
2. Fix any engine/parser issues found during the first run.
3. Tune controls and performance on the target phone.
4. Export a debug APK for device testing.
