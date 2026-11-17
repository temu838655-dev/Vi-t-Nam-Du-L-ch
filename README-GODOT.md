# Việt Nam – Hành Trình Bất Tận (Godot 4 port)

The Godot 4 migration is developed on branch `godot4-port`. The Unreal Engine 5.8 project remains preserved on `main`.

## Current playable prototype

Open `Godot/project.godot` with Godot 4.4.1 or compatible Godot 4.x.

- Main menu: start a new journey or continue the last saved session.
- New game begins outside the player's family home.
- Continue restores the last saved player position and facing direction.
- Mobile third-person controls: left-side touch movement, right-side camera drag, jump and interaction buttons.
- Family prototype: talk to mother and father; family affection is tracked.
- Career prototype: interact with the job board to choose one of four careers, then complete one paid shift per real-world date.
- Wallet and career status are displayed in the mobile HUD.
- Local JSON save file stores player profile, wallet, career, family progress, work history and world position. Autosave runs every 15 seconds and when the app is paused or closed.

## Prototype limitations

The house, street, NPCs and player are greybox/procedural placeholders. They are not final photorealistic Vietnam assets, finished character models, or motion-captured animations. Traffic, drivable vehicles, detailed interiors, regional maps, quests, cloud accounts and production-quality art are not implemented yet.

## Android build

The GitHub Actions workflow `.github/workflows/godot-android-apk.yml` validates the project and exports an ARM64 debug APK. A build is considered available only after the workflow succeeds and uploads the artifact named `VietNamHanhTrinh-Godot-Android-ARM64`.

## Branch policy

Keep Unreal Engine 5.8 source on `main` intact until the Godot APK has been installed and smoke-tested on a real Android device. Do not merge the Godot port into `main` before that verification.
