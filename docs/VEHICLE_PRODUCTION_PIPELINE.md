# Vehicle production pipeline — Vietnamese motorcycles

## Goal

Produce recognizable, mechanically coherent Vietnamese road vehicles for the Godot 4 mobile game. The target is high-end open-world presentation, not a claim of GTA V asset parity. Every production vehicle must match a documented manufacturer, model family, model year and variant. A generic scooter must never be relabeled as a Honda Vision, Wave Alpha, Air Blade, SH, Lead, Future, Winner X, Sirius, Exciter, Janus or Grande.

## Reference capture

For each exact variant, collect a reference pack with permission:
- front, rear, left, right and three-quarter views;
- close-ups of headlamp, tail lamp, indicators, mirrors, instrument cluster, seat, wheels, brakes, exhaust, body seams, badges and controls;
- dimensions or reliable manufacturer specifications for wheelbase, overall length, width, height, wheel and tyre size;
- color/trim references and model-year notes.

Record source URLs, capture date, model year and license/permission in the asset manifest. Reference photos are not automatically licensed as game textures.

## Blender authoring requirements

- Separate named meshes for body panels, seat, front/rear wheels, tyres, rims, handlebar, mirrors, lamps, indicators, exhaust, brake components and small controls.
- Use physically plausible proportions and wheelbase; no single undifferentiated scooter mesh.
- Create pivots at wheel axles and steering head. Front wheel rotates with suspension travel and steering; rear wheel rotates with drivetrain motion.
- Rig front fork and rear shock travel. Keep steering, wheel spin and suspension animation independent.
- Provide rider mount transforms for seat position, hand grips and foot rests; verify the rider's hands, knees and feet align without clipping.
- Model real lamp lenses and reflective surfaces. Use emissive materials only for active lights.
- Create a simplified collision proxy separate from the visual mesh.
- PBR materials: base color, roughness, metallic and normal maps where appropriate. Avoid excessive material slots; atlas small details.
- Bake high-detail geometry into normal/AO maps for mobile LODs where practical.

## Mobile performance budgets (initial targets, tune by device)

| Tier | Visible vehicle target | Texture target | Notes |
|---|---:|---:|---|
| Hero vehicle LOD0 | 35k–70k triangles | 2K | Close camera, main player bike |
| LOD1 | 12k–25k triangles | 1K | Normal gameplay distance |
| LOD2 | 3k–8k triangles | 512–1K | Traffic and distant view |
| LOD3 | 500–2k triangles | 256–512 | Far silhouette / impostor |

These are authoring targets, not measured performance guarantees. Use GPU/CPU profiling on real low-end Android devices before finalizing.

## Godot integration and acceptance

- Import self-contained GLB with embedded textures and named nodes.
- Keep visual meshes and collision proxies separate.
- Validate front/rear wheel, steering, suspension, seat, lights, mirrors, exhaust, brake and body-panel nodes.
- Verify wheel rotation, steering angle, suspension compression, rider mounting, head/tail light states and collision shape in a test scene.
- Test all LOD transitions and material readability under daylight, night lighting and rain.
- Do not change an asset status to `accepted` until its original source, license, model-year identity, GLB integrity, PBR textures and mobile LODs have been checked.

## Current status

The project currently has procedural motorcycle prototypes. This specification does not mean a production Honda Wave Alpha model has been downloaded or integrated. The Wave-family CGTrader listing remains a candidate until its downloadable file is inspected against exact model-year references and license terms.
