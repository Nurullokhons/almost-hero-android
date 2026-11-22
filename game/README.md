# Almost Hero - Godot prototype

Lightweight Godot 4 side-view 3D action prototype for Android.

## Current prototype
- Fixed side camera that follows the player horizontally.
- Procedural cartoon soldier in green armor and helmet.
- Simple walk animation.
- Left/right movement, jump, roll and projectile shooting.
- Touchscreen buttons: left, right, jump, fire and roll.
- Small obstacle corridor built from primitive geometry.
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

## Next steps
1. Validate the project in Godot and fix any engine/parser issues.
2. Add enemies, damage and a basic health display.
3. Improve the soldier silhouette and environment art while keeping the low-memory budget.
4. Export a debug APK and test on the target phone.

The current soldier and environment are deliberately built from simple 3D primitives. This keeps the prototype small while gameplay and device performance are validated.
