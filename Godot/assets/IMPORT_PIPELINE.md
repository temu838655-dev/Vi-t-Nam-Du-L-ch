# Production 3D asset intake (Godot 4)

This document defines the route from a sourced or commissioned model to an in-game asset. A manifest entry is not proof that a model exists or is finished.

## 1. Source and rights gate

For every downloaded, purchased or commissioned asset, keep:

- The original source URL or contract/reference.
- Exact license name and version, plus a copy of the license/receipt where applicable.
- Commercial-use permission, modification permission and redistribution conditions.
- Attribution text and any restrictions on use in a shipped game.
- A short reference sheet showing the real Vietnamese subject being represented.

Do not assume that a marketplace listing grants commercial redistribution. Do not use ripped GTA assets, brand logos, or manufacturer CAD without permission. For Honda/Yamaha-branded vehicles, distinguish a generic inspired vehicle from an officially licensed replica.

## 2. Blender authoring requirements

Use Blender 4.x and export glTF 2.0 binary (.glb).

Common requirements:

- Real-world metre scale; apply object transforms before export.
- Sensible origins and named nodes; no unexplained object names such as Cube.001.
- Separate render meshes from simplified collision meshes.
- PBR base-colour, normal, metallic and roughness maps; pack textures into the GLB.
- UVs, tangents and normals checked; no missing texture paths.
- Mobile LODs and a documented triangle/texture budget per asset.
- Avoid excessive transparent materials and expensive shader features on mobile.
- Record Blender source (.blend) alongside the exported GLB when possible.

### Hero character profile

- A real humanoid mesh with facial geometry, ears, hair and separate clothing pieces.
- A usable humanoid skeleton, skin weights checked in deformation poses.
- At least three embedded animation clips for first acceptance; target idle, walk, run, talk, interaction, sit, mount and dismount.
- Face/eye detail and skin/hair/clothing materials must be visually reviewed at phone screen size.
- Do not use a mannequin, capsule or procedural primitive as the final player.

### Motorbike profile

- Separate body panels, wheels, tyres, lights, seat, mirrors and handlebars.
- Clearly named front/rear wheel nodes and a steering node.
- Pivot/origin positions suitable for wheel rotation and steering animation.
- Verify mount points and rider pose in Godot.
- Use generic branding unless the exact brand/model depiction is licensed.

### Vietnamese building profile

- Photo references from the relevant region and review of local architectural details.
- Distinct roof, facade, doors, windows, balcony, signs and interior/exterior pieces.
- Collision meshes that do not use every decorative detail.
- PBR material set and mobile LODs; validate from street-level camera distance.

## 3. Project folder convention

Place each asset beneath `Godot/assets/` in a stable category folder. Example:

```
Godot/assets/
  characters/player/
    player_hero.blend
    player_hero.glb
    LICENSE.txt
    source.json
  vehicles/motorbikes/
    honda_wave_alpha_110.blend
    honda_wave_alpha_110.glb
    LICENSE.txt
    source.json
  environment/family_home/
    family_home.blend
    family_home.glb
    LICENSE.txt
    source.json
```

The current GitHub text-file integration cannot upload binary .blend/.glb files. Binary asset delivery must use a verified Git LFS, release asset, or other repository upload path; do not create a text file with a .glb extension or claim a model was imported when it was not.

## 4. Godot import and review

1. Copy the licensed GLB into the correct folder.
2. Open the project in the pinned Godot version and let the importer finish.
3. Inspect scale, orientation, material slots, missing textures and skeleton/animation tracks.
4. Add an instance to a dedicated review scene; compare it with the reference sheet.
5. Test collision, interaction sockets, LOD switching and a representative Android device.
6. Update the asset manifest to `needs_review` while visual and runtime review is pending.
7. Change status to `accepted` only after all gates pass and source/license metadata is committed.

The CI GLB validator checks file structure and basic profile signals. It cannot judge realism, correct Vietnamese design, deformation quality, topology, legal rights or phone performance. Human visual review remains mandatory.
