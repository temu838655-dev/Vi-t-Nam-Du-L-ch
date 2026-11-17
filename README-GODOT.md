# Việt Nam – Hành Trình Bất Tận (Godot 4 port)

The Godot 4 migration is developed on branch `godot4-port`. The Unreal Engine 5.8 project remains preserved on `main`.

## Current playable prototype

Open `Godot/project.godot` with Godot 4.4.1 or compatible Godot 4.x.

- Main menu: start a new journey or continue the last saved session.
- New game begins outside the player's family home.
- Continue restores the last saved player position and facing direction.
- Mobile third-person controls: visible left-side touch joystick, right-side camera drag, jump and interaction buttons. The joystick relocates to the initial touch point on the left side.
- Motorbike prototype: approach the parked test bike, tap TƯƠNG TÁC to mount, steer and accelerate with the left joystick, then tap XUỐNG XE to dismount. The rider camera pulls back while driving.
- Three interactive shops: a motorcycle dealer, a Vietnamese clothing shop and a food/specialty stall. The catalogs include popular models such as Wave Alpha, Vision, Air Blade, SH160i, Sirius FI, Exciter 155, LEAD and Janus; everyday clothes and traditional outfits; and dishes/specialties from multiple regions.
- Vehicle purchases are saved as owned vehicles and spawn a rideable bike near the player. Clothing purchases are saved and immediately equip the selected outfit. Prepared dishes deduct money and increase the character satiety meter; packaged regional specialties are stored in the player inventory.
- Character prototype now uses separate head, hair, face, torso, arms, legs and shoes meshes. Outfit slots update the visible colors and traditional outfit/helmet overlays.
- Family prototype: talk to mother and father; family affection is tracked.
- Career prototype: interact with the job board to choose one of four careers, then complete one paid shift per real-world date.
- Wallet and career status are displayed in the mobile HUD.
- Local JSON save file stores player profile, wallet, career, family progress, work history and world position. Autosave runs every 15 seconds and when the app is paused or closed.

## Prototype limitations

The house, street, shops, NPCs, character and motorcycles are still procedural prototype geometry. The listed vehicle names are game catalog entries; current bike meshes are not manufacturer-accurate licensed models. Character proportions, face, clothes and movement are early placeholders, not photorealistic scans or motion-captured animation. Shop prices are balancing values, not official retail quotations. Production-quality character/vehicle assets, traffic, detailed interiors, full regional maps, quests, cloud accounts and final sound design remain future work.

## Android build

The GitHub Actions workflow `.github/workflows/godot-android-apk.yml` validates the project and exports an ARM64 debug APK. A build is considered available only after the workflow succeeds and uploads the artifact named `VietNamHanhTrinh-Godot-Android-ARM64`.

## Branch policy

Keep Unreal Engine 5.8 source on `main` intact until the Godot APK has been installed and smoke-tested on a real Android device. Do not merge the Godot port into `main` before that verification.
