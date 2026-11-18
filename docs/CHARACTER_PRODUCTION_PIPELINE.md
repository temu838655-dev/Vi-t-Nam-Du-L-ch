# Character production pipeline — Việt Nam Hành Trình Bất Tận

## Current truth

The playable prototype still uses a procedural capsule-based player. It is not a production Vietnamese human model. Do not describe it as realistic or final.

The target is a realistic, game-ready Vietnamese hero and a reusable NPC family, exported as self-contained GLB files for Godot 4. The character source must be inspected and accepted before the procedural prototype is replaced.

## Source candidates researched

1. **Vietnamese Man (Basic Rig), Sketchfab**
   - https://sketchfab.com/3d-models/vietnamese-man-basic-rig-7dffbc85e8044a2f9198e626ef95aa92
   - The creator labels the subject Vietnamese; the listing reports approximately 356.7k triangles and CC BY-SA.
   - Treat as an identity/reference candidate, not mobile-ready production art.
   - Verify creator-enabled download, current license text, attribution, share-alike implications, rig quality and mesh separation before use.
2. **Ara 3D Gen**
   - https://github.com/TuriaArt/3d-gen-TU
   - Open-source MIT generator; its documentation describes GLB/FBX/OBJ export and 48 animation options. Character data is MakeHuman CC0.
   - Useful to create editable base meshes and test a repeatable export pipeline. It does not automatically produce a culturally accurate Vietnamese face or clothing.
3. **EMA rigged character**
   - https://theunseenvulga.itch.io/3d-character-riggedema
   - GLB/FBX, approximately 76k triangles, Mixamo-ready rig, CC0.
   - Generic character; suitable only for validating the rig/import workflow, not as the Vietnamese hero.
4. **Grab3D Character Mixer**
   - https://grab3d.com/tools/character-mixer/
   - CC0 modular rigged GLB export, but current visual styles are stylized/low-poly. Useful for placeholder NPC prototyping only.

## Production workflow

### A. Reference and design
- Build a reference board from licensed photographs of Vietnamese adults across age groups and regions.
- Define one hero design and separate NPC archetypes: parents, shop owners, street vendors, office workers, students, drivers and tourists.
- Model cultural specificity through clothing, hairstyles, accessories and local context; do not rely on skin tone alone.
- Record provenance for every photograph, texture, garment and model. Do not scrape copyrighted character art.

### B. Base mesh and topology
- Use Ara/MakeHuman as an editable base only if the result passes the art review.
- Sculpt and adjust the face, ears, hands, feet and body proportions in Blender.
- Retopologize to a deformation-friendly mesh. Keep facial loops around eyes and mouth.
- Separate hair, eyebrows, eyes, teeth, shoes and clothing where practical.
- Keep clothing as swappable meshes for the in-game wardrobe.
- Make a clean humanoid skeleton with consistent naming and skin weights.

### C. Materials
- Use physically based materials: base color, roughness, normal and metallic only where physically appropriate.
- Avoid plastic-looking skin. Use subtle roughness variation and restrained subsurface scattering only on supported renderer/device tiers.
- Pack texture maps and use mobile-friendly resolutions; hero 2K maximum initially, distant NPC 1K or lower.
- Do not use unlicensed photographs as skin or clothing textures.

### D. Animation
Required clips: Idle, Walk, Run, Jump, Land, Talk, Interact, Sit, Stand, RideMount, RideIdle, RideDismount.
- Use a consistent skeleton and retarget animations in Blender/Godot.
- Check feet sliding, ground contact, hand positions, shoulder deformation and clothing clipping.
- Use animation LOD and reduce update frequency for distant NPCs.

### E. Mobile optimization
- Hero target: approximately 25k–45k triangles for the body and outfit combined as a starting budget, then profile on real devices.
- NPC LOD0: 15k–30k triangles; LOD1: 5k–10k; LOD2: 1k–3k. These are project budgets, not universal limits.
- Use 3 LODs, impostors only for far crowds, shared materials and texture atlases.
- Limit real-time shadows and expensive skin effects on low-end devices.
- Test Android ARM64 with the actual target devices; do not infer performance from editor preview.

### F. Godot import and acceptance
- Export a self-contained glTF 2.0 binary (.glb) with embedded textures.
- Keep scale in metres and root pivot at the feet.
- Include the humanoid skeleton and named animation clips.
- Run Godot/tools/validate_asset_manifest.py after adding the binary.
- Open the imported scene in Godot and inspect material import, animation playback, skeleton mapping, bounds, collision, LOD and mobile frame time.
- Only then change player_hero_v1 from blocked_no_production_model to needs_review, and to accepted after art, technical and license approval.

## Current blocker

The GitHub text-file integration can update GDScript and documentation, but it has not downloaded or committed a real GLB binary in this project. No placeholder text file may be renamed to .glb. A real binary-capable upload path and a verified source download are required before replacing the procedural player.
