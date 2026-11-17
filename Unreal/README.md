# Unreal Engine 5 game foundation

This directory is the new primary game foundation. The Godot project at the repository root is retained as a prototype and is not deleted.

## Current scaffold
- Unreal Engine project descriptor and C++ game/editor targets.
- Mobile-first renderer defaults: Mobile Forward path, no Nanite, no Lumen dependency, no virtual textures.
- Android arm64 and iOS bundle settings.
- Minimal GameMode, touch-capable PlayerController, and versioned SaveGame data model.

## Open in Unreal Editor
1. Install a compatible Unreal Engine 5.x version and its Android/iOS platform components.
2. Generate IDE project files from `VietNamHanhTrinh.uproject`.
3. Open the project and allow the editor to compile the C++ module.
4. Create the first map and set it as the startup map in Project Settings.
5. Build Android on a configured Windows/macOS/Linux workstation. iOS packaging/signing requires macOS and Xcode.

The scaffold is source/configuration only. It does not yet contain compiled binaries, maps, 3D assets, MetaHumans, terrain, or a playable Unreal build.
