# Almost Hero - Godot prototype

Lightweight Godot 4 side-view 3D action prototype for Android.

## Current prototype
- Fixed side camera that follows the player horizontally.
- Procedural cartoon soldier in green armor and helmet.
- Left/right movement, jump, roll and automatic projectile fire while FIRE is held.
- Brief muzzle flash on each shot.
- Touchscreen buttons: left, right, jump, fire and roll.
- Industrial corridor with dark red-brown wall panels, beams, crates and obstacles.
- Two patrol enemies with articulated silhouettes, health bars and hit feedback.
- Projectiles damage enemies; contact with enemies damages the player.
- Player health shown in the HUD.
- Compatibility renderer (OpenGL ES 3); geometry is procedural and uses simple materials.

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
The project has been launched successfully in Godot 4.7.2 on the developer's Windows PC. Basic movement, jumping, shooting and roll controls were confirmed working. The latest visual and enemy improvements still need to be run and checked in the editor.

## Next steps
1. Run the latest scene and inspect the new corridor, HUD and enemy feedback.
2. Tune enemy hit detection and player damage.
3. Export a debug APK and test it in LDPlayer 9, then on the Realme C11.
