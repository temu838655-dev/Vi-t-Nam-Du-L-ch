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


## Additional source research (18 November 2026)

5. **Vietnamese Man (Basic Rig), Sketchfab**
   - https://sketchfab.com/3d-models/vietnamese-man-basic-rig-7dffbc85e8044a2f9198e626ef95aa92
   - Listing advertises a downloadable model, reports about 356.7k triangles and CC BY-SA.
   - This is a potential Vietnamese male reference, not a ready-to-ship character. The share-alike obligation must be reviewed before inclusion in a proprietary/commercial game. Retopology, rig, facial anatomy and animation must be inspected.
6. **Ara 3D Gen, GitHub**
   - https://github.com/TuriaArt/3d-gen-TU
   - Its project documentation describes local character generation and GLB export using MakeHuman CC0 character data; code is MIT according to its repository.
   - Evaluate it as a production tool, not as a prebuilt Vietnamese character. Customize facial proportions, hairstyles and locally accurate wardrobe; inspect the actual exported GLB and licenses of every dependency.

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

### B1. Facial anatomy and performance standard (mandatory)

The hero and close-up NPCs must have a readable, fully modeled face. A blank mask, featureless head, painted-on features or simple dots are not acceptable.

- Eyes: separate left/right eye geometry with visible iris and pupil, believable sclera, eyelid geometry and blink capability. Eye gaze should track conversation targets where supported.
- Eyebrows: separate geometry or groom cards with enough control for expression.
- Nose: modeled bridge, tip, alar wings and nostrils; not a single floating cone.
- Mouth: upper/lower lip volume, mouth opening/cavity and teeth; tongue is desirable for close-up dialogue. Provide visemes or phoneme shapes for speech.
- Other anatomy: ears, cheek volume, jawline and chin must deform naturally with expressions.
- Facial rig: facial bones and/or blendshape morph targets for blink, brow raise/frown, smile, anger, sadness, surprise and mouth/viseme shapes. At minimum, implement eye blink, jaw open and several visemes for dialogue.
- Performance: animate faces for the player and nearby speaking NPCs; disable or simplify facial animation for distant crowds to protect mobile frame time.
- QA: inspect front, profile and three-quarter views in daylight and night lighting; test blink, eye direction, lip-sync and expression transitions. Check for crossed-looking eyes and clipping around lips/teeth.

The intended quality bar is detailed facial readability and animation ambition comparable to high-end open-world games such as GTA V, with an original Vietnamese character design. This is a visual target, not a claim of identical asset fidelity or production budget.

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

## Runtime quality gate

The Godot player loader does not accept a hero GLB merely because the file exists or opens.
Before treating an imported scene as the production player, it checks for:

- A `Skeleton3D` and at least one imported `AnimationPlayer` clip.
- Separate visible eye geometry (two eyes), eyebrows, nose, mouth/lips, teeth and both ears.
- Facial deformation evidence through blend shapes on an `ArrayMesh` or facial bones such as jaw, lip, brow, eyelid or face bones.

A model that fails this gate is rejected and the clearly labelled prototype fallback remains active. This is a structural import gate, not an artistic realism certification: human review is still required for anatomy, topology, skin shading, facial expressions, lip-sync quality, Vietnamese appearance, rig deformation and mobile performance. For blend-shape exports from Blender, enable the glTF deformation/shape-key export options and verify the imported mesh in Godot.
