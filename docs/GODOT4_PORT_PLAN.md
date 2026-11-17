# Godot 4 port — Việt Nam – Hành Trình Bất Tận

## Migration policy
- This is a parallel port on branch `godot4-port`; the original UE5.8 project on `main` is preserved.
- Initial target: Android ARM64 APK. iOS export follows after the Android vertical slice is verified.
- Godot renderer: Compatibility (OpenGL) for broader mobile support.
- The first milestone is a bootable greybox vertical slice, not a finished realistic open world.

## Initial vertical slice
- Main scene and generated prototype environment.
- Starter family-home exterior blockout.
- Third-person character, camera and movement.
- Touch movement and camera-look controls.
- Android ARM64 export workflow using GitHub Actions.

## Systems to port in later milestones
1. Save/load, continue/new life and fallback to family home.
2. Family profiles, parents, relationships and daily schedules.
3. Career selection, jobs, income, wallet and expenses.
4. Vehicles: motorcycle, car, fuel, stations and traffic.
5. Vietnam locations, POIs, route/travel data and streaming regions.
6. NPC navigation, pedestrian/traffic AI and interaction system.
7. Day/night clock, weather, UI, localization and accessibility.
8. iOS export and signing on macOS runners.

## Current limitations
- Prototype geometry and capsule character are placeholders.
- No production character meshes, animation, interior home, family NPCs, vehicle models, map data, cloud accounts or realistic Vietnam asset packs are included yet.
- Android export depends on the Godot CI image containing matching export templates and Android build dependencies. The first Actions run must verify this.
- Do not delete the UE5.8 project until Godot APK has been installed and smoke-tested on a real Android device.
