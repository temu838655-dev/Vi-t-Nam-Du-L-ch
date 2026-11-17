# Việt Nam – Hành Trình Bất Tận (Godot 4 port)

The Godot 4 migration is being developed on branch `godot4-port`. The Unreal Engine 5.8 project remains preserved on `main`.

Open `Godot/project.godot` with Godot 4.4 or compatible 4.x. The initial milestone contains a third-person mobile prototype and family-home blockout.

Android ARM64 builds are automated by `.github/workflows/godot-android-apk.yml` on pushes to this branch or manual workflow dispatch. The first CI run is required to confirm the export image/templates are available.
