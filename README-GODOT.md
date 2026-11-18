# Việt Nam – Hành Trình Bất Tận (Godot 4)

## Repository and engine

- Active Godot development branch: `godot4-port`.
- Engine: Godot 4.4.1, GDScript, Compatibility renderer (mobile-oriented).
- Android package: `com.bovietnam.hanhtrinh`.
- The previous Unreal Engine project on `main` is preserved and is not part of the Godot Android build.

## Existing playable prototype

Open `Godot/project.godot` in Godot 4.4.1.

- New journey starts outside the family home; Continue restores the saved player position.
- Guest/local save, autosave, wallet, career selection and work-shift prototype.
- Third-person mobile movement, fixed bottom-left joystick, right-side camera drag, jump and interaction.
- Local map overlay (local prototype coordinates only; not GPS or a complete Vietnam map).
- Family NPCs, daily resident routines, contextual dialogue and family progress.
- Motorcycle, clothing and food shops; purchases, inventory and basic vehicle mounting.
- Hồ Gươm prototype district, family home/interior and several shop interiors.
- Basic procedural traffic and pedestrian routines.

## Honest production status

This is still an early gameplay prototype, **not** a photorealistic open-world game.

- The current player is assembled from primitive meshes; it does not yet use a production humanoid GLB, facial rig or motion-captured animation.
- Current motorcycles and traffic are procedural prototypes, not manufacturer-accurate licensed vehicle models.
- Buildings, roads, shops and landmarks are partly procedural/greybox. They are not yet a finished photogrammetry/PBR city.
- Google sign-in is a UI stub. OAuth, backend identity and cloud saves are not configured.
- The map is local and does not yet contain connected, streamed regions of Vietnam.
- Some gameplay systems are prototypes; mission progression, advanced vehicle physics, audio and production QA remain incomplete.

The asset requirements and acceptance gates are tracked in `Godot/assets/asset_manifest.json`. An asset cannot be accepted without its actual files, source and license metadata. Do not label placeholder geometry as production art.

## Android builds

The GitHub Actions workflow validates the project, imports and runs Godot headlessly, exports an ARM64 debug APK, verifies the package ID, uploads a 14-day Actions artifact, and publishes a prerelease to GitHub Releases.

- Workflow: [Godot Android APK](https://github.com/temu838655-dev/Vi-t-Nam-Du-L-ch/actions/workflows/godot-android-apk.yml)
- Releases: [Godot Android test builds](https://github.com/temu838655-dev/Vi-t-Nam-Du-L-ch/releases)
- APK filename: `VietNamHanhTrinh-Android-ARM64.apk`

The current CI signing key is generated for testing. It is not a persistent Play Store signing key. AAB/production signing and iOS Xcode export still require dedicated release configuration and credentials.

## Branch safety

Keep the Godot work on `godot4-port`. Do not overwrite or merge into `main` until a Godot APK has been installed and smoke-tested on a real Android device.


## Cài đặt trong game

- Chất lượng đồ họa: Tiết kiệm (30 FPS), Trung bình (45 FPS), Đẹp (tối đa 60 FPS) và Cao cấp (tối đa 60 FPS, MSAA 4x). Đây là giới hạn mục tiêu; FPS thực tế phụ thuộc thiết bị.
- Độ nhạy xoay camera có thể điều chỉnh từ 0,5x đến 2,0x.
- Âm lượng tổng có thanh trượt riêng.
- Các lựa chọn được lưu cục bộ trong `user://game_settings.cfg` trên thiết bị.
