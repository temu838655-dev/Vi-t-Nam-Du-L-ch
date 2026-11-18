# Godot 3D asset production area

This folder is reserved for approved, production-quality 3D assets. Runtime primitive meshes in scripts are prototype fallbacks only; they are not accepted as final art.

## Required folder layout

- `characters/player/`: rigged player body, face, hair, clothing variants, textures and animation clips.
- `characters/npc/`: reusable rigged NPC bodies, face/hair variants and role-specific clothing.
- `vehicles/motorbikes/`: one folder per exact make/model/year with body parts, wheel/steering/suspension rigs and audio references.
- `vehicles/cars/`: licensed or original vehicle models, wheel rigs and audio references.
- `environment/hanoi_ho_guom/`: approved photogrammetry or authored architecture, street props, vegetation and ground materials.
- `environment/family_home/`: exterior shell, interior, furniture and surface materials.
- `materials/atlases/`: PBR texture sets and atlases.
- `audio/`: original or licensed ambience, footsteps, engines and interaction sounds.

## Accepted source formats

Prefer Blender source `.blend` plus exported glTF 2.0 `.glb`. Keep source files outside the runtime export if they are too large. Every imported asset must have a matching manifest entry with author/source, license, scale, texture set, LODs and validation status.

## Mobile delivery requirements

- Real-world scale in metres; character target height documented in the manifest.
- PBR base colour, normal and roughness maps; metallic only where physically appropriate.
- Apply transforms, sensible origins, clean UVs, no missing textures, no non-manifold geometry that breaks the asset.
- Provide LODs for large environments and repeated NPCs/vehicles.
- Use texture compression and mipmaps; avoid oversized 4K textures on small props.
- Rigged characters must include tested idle, walk, run, talk and interaction clips. Vehicle rigs must include steering, wheels and suspension.
- Check collision separately from render meshes.
- Record source and license; no ripped game assets, unauthorized scans, logos or copyrighted models.

## Current status

The manifest currently marks the first hero character, Honda Wave Alpha and family-home environment as blocked because no approved production models are in the repository yet. Do not change a status to `accepted` until the actual GLB, materials, rig/animation (where applicable), license record and in-engine review exist.
