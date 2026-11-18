# Vietnam 3D asset sourcing shortlist

This catalog is a research shortlist, not a claim that the models have been downloaded or integrated. Before adding any binary to the game, verify the live download button, license text, attribution requirements, source file, texture embedding, scale, topology, and mobile performance.

## Candidate assets

| Asset | Source | Format / technical notes | License / integration decision |
|---|---|---|---|
| Vietnamese House in 2000s | https://sketchfab.com/3d-models/vietnamese-house-in-2000s-582936c8eac641a885343e91766e71b1 | 8.5k triangles; family home from southern Vietnam, late 1990s/early 2000s | CC BY; credit creator Khoa Nguyen. Strong candidate for family-home art pass after download and GLB inspection. |
| BanhMi Cart | https://sketchfab.com/3d-models/banhmi-cart-f45b8dfd3a874779ac18323399a10258 | 7.1k triangles; Vietnamese street-food cart | CC BY; credit Khoa Nguyen. Candidate for street-food vendor. |
| Vietnamese Vegetable Market | https://sketchfab.com/3d-models/vietnamese-vegetable-market-a3c935d758624c8f866bc27776f86712 | 6.7k triangles; low-poly market scene | CC BY; credit Khoa Nguyen. Useful as a layout/reference asset, but stylized rather than photoreal. |
| Vietnamese Meat Market stall | https://sketchfab.com/3d-models/vietnamese-meat-market-stall-0cd04f3c727347d9899b52b9b88be871 | 3.7k triangles; stall prop | CC BY; credit Khoa Nguyen. Candidate for market props. |
| Vietnamese streets | https://sketchfab.com/3d-models/vietnamese-streets-e2ce91e4d7d349c7912a0ad065ceec56 | 6.9k triangles; creator points to an external Google Drive download | CC BY; creator asks for attribution. Verify external archive and contents before use. |
| Vietnamese Man (Basic Rig) | https://sketchfab.com/3d-models/vietnamese-man-basic-rig-7dffbc85e8044a2f9198e626ef95aa92 | 356.7k triangles; basic rig | CC BY-SA; credit and share-alike obligations apply. Too heavy for direct mobile use; retopology, rig inspection and LOD required. |
| Traditional Vietnamese Clothes Ao Dai | https://sketchfab.com/3d-models/traditional-vietnamese-clothes-ao-dai-861b18ca3b954fad9b0b3d84f6a81fc0 | 37.6k triangles; clothing model | Search result did not expose a clear license/download confirmation. Hold until the model page's current license and download permission are checked. |
| Vietnamese nón lá | https://sketchfab.com/3d-models/vietnamese---non-la-abd86436d03344b9a40c82e127fb6252 | 1.5k triangles | CC BY; credit creator NNgan. Good small wearable prop candidate. |
| Vietnamese traditional house (North) | https://3dwarehouse.sketchup.com/model/da8d410f-af22-49cd-9f7b-08bd8e16a6fe/Vietnamese-Traditional-House-model-3 | 16,291 polygons; 105 materials; SketchUp model | Download shown, but verify SketchUp model terms and convert SKP to GLB in Blender. Inspect material cleanup and collision. |
| Traditional Vietnamese thatched-roof house | https://3dlabtools.com/resources/traditional-vietnamese-thatched-roof-house-historical-3d-game-asset-f0da80eb | GLB, 486,124 triangles, 15.4 MB | 3DLabTools Original Content License: commercial use and modification allowed; no standalone redistribution. Far too dense for direct mobile use; retopology/LOD and texture optimization required. |
| Vietnamese red plastic stool | https://saigonsidewalk.itch.io/vietnamese-plastic-stool | GLB/FBX/OBJ/Blend; 1,500 triangles; PBR 1K | Free for personal and commercial projects; do not resell or redistribute raw files. Excellent small street-life prop candidate. |
| Pho dining set | https://alleybits.itch.io/pho-dining-set-free-low-poly-asian-street-food | GLB/FBX/OBJ; 42 meshes, 10,018 triangles | Personal and commercial use allowed; no royalty/attribution; do not redistribute source assets. Stylized/low-poly, useful as temporary prop kit, not final photoreal art. |
| Traditional Vietnamese temple | https://3dlabtools.com/resources/traditional-vietnamese-ancient-temple-historical-3d-game-asset-1ae90d74 | GLB, 929,006 triangles, 28.7 MB | 3DLabTools Original Content License; optimize heavily before mobile use. |
| Vietnamese old town scan | https://sketchfab.com/3d-models/vietnams-old-town-c1251dd5edfb4f73ab6ac98ca3e3a188 | 2.2M triangles | CC BY. Photogrammetry-scale candidate only; decimate, split into modular chunks, bake textures and create LODs. |

## Character pipeline candidates

| Candidate | Source | Technical notes | Decision |
|---|---|---|---|
| Vietnamese Man (Basic Rig) | https://sketchfab.com/3d-models/vietnamese-man-basic-rig-7dffbc85e8044a2f9198e626ef95aa92 | The model is explicitly presented as Vietnamese and has a basic rig, but is about 356.7k triangles and carries CC BY-SA terms. | Best identity-specific reference candidate found so far. Do not ship directly; obtain creator-enabled download, inspect the rig and license compatibility, retopologize, bake textures and create mobile LODs. |
| Ara 3D Gen | https://github.com/TuriaArt/3d-gen-TU | Open-source MIT generator; exports GLB/FBX/OBJ and includes 48 animation options. Character data is MakeHuman CC0. Can generate editable base bodies, hair and clothing. | Useful for generating a custom base and testing a production pipeline. It does not automatically guarantee a recognizably Vietnamese face or wardrobe; art direction and reference-based sculpting remain necessary. |
| 3D Character Rigged (EMA) | https://theunseenvulga.itch.io/3d-character-riggedema | GLB 7.8 MB / FBX 5.3 MB; approximately 76k triangles; rigged for Mixamo; hand-painted textures. | CC0 personal/commercial use. Generic female character, not Vietnamese-specific. Keep only as a rig/import pipeline test candidate, not the final hero. |
| Grab3D Character Mixer | https://grab3d.com/tools/character-mixer/ | Modular character creator with rigged GLB export and selectable animations. | CC0, but its available styles are stylized/low-poly. Useful for prototyping NPC variety, not the photoreal hero target. |

Character acceptance requirements remain: Vietnamese visual references reviewed by an art lead; facial proportions, skin/hair materials, hairstyle, realistic hands and shoes; separate clothing meshes; humanoid skeleton; idle/walk/run/talk/interact animations; mobile LODs; PBR materials; and a clear redistribution/commercial license. Generic low-poly models must not be represented as finished Vietnamese people.

## Vehicle sourcing

| Asset | Source | Format / technical notes | License / integration decision |
|---|---|---|---|
| DRIVER MOTOR BIKE (Honda Wave) | https://www.cgtrader.com/free-3d-models/vehicle/motorcycle/driver-motor-bike | FBX, 2.52 MB; CGTrader page description says “DRIVER BIKE HONDA WAVE”; CGTrader technical check reports PBR base color, roughness, metalness and normal maps, UV unwrapped, no N-gons/faceted geometry; textures are not embedded | Listed as free with Royalty Free License; creator ppphuthuy. Promising first Honda Wave-family candidate, but inspect the downloaded model visually and confirm the license terms and whether the rider is a separate mesh before production integration. |
| Official Honda Super Cub C125 | https://global.honda/en/motorcycle/3d-models/ | Honda official 3D model data; Super Cub C125 variants offered via CLIP STUDIO ASSETS and Unity Asset Store | Honda says the models are royalty-free subject to each platform's terms. Authentic Honda asset, but it is not a Wave Alpha; use only as a separate Cub-family vehicle. |
| Official Honda CT125 and CB1000F | https://global.honda/en/motorcycle/3d-models/ | Official Honda creator assets; multiple color variants | Royalty-free subject to platform terms. Useful authentic vehicles for later expansion, not substitutes for Vietnamese commuter models. |

- TurboSquid motor-scooter catalog: https://www.turbosquid.com/Search/3D-Models/motor-scooter
- TurboSquid lists FBX, GLTF/GLB and OBJ among exchange formats. Filter for downloadable, game-ready models and verify each product license.
- Do not substitute a generic scooter for Honda Wave Alpha, Vision, Air Blade, SH, Lead, Future, Winner X, Yamaha Sirius, Exciter, Janus or Grande. Exact model/year, body panels, wheelbase, headlamp, tail lamp, mirrors, seat and control rig must be checked against reference photos.
- The CGTrader Wave model is a candidate, not yet accepted as the exact Wave Alpha. Do not label it Wave Alpha without matching its body design and model year to reference photos.

## Important platform and license notes

- Sketchfab's Download API requires an authenticated Sketchfab account; its API supports GLB/glTF/USDZ and only allows downloads for models whose creator enabled downloads. See https://sketchfab.com/developers/download-api.
- A visible Sketchfab viewer or a search result is not proof that the binary can be downloaded without login.
- CC BY assets need creator attribution in the game's credits and asset manifest. CC BY-SA assets need a separate compatibility review before inclusion in a closed-source/commercial distribution.
- Never commit a model until its original archive is downloaded, inspected, converted if needed, and the license/provenance recorded.
- For Android, make mobile LODs, reduce draw calls, atlas materials, compress textures, create collision proxies, and test memory/GPU cost on low-end devices.
- Do not place HTML pages, download links, or text placeholders under a .glb filename. A real GLB binary must pass the project's GLB validator before status changes from blocked.

## Newly identified Sketchfab Vietnam catalog and collections

The user's Vietnam search link is a useful discovery entry point, not a single downloadable asset pack. Search results mix downloadable and view-only models, photogrammetry scans, low-poly/stylized props, and city-scale scenes. Review each model page individually and filter for downloadable models before production use.

- Vietnam search: https://sketchfab.com/search?q=vi%E1%BB%87t+nam&type=models
- Vietnam tag catalog: https://sketchfab.com/tags/vietnam
- Khoa Nguyen's Vietnam collection (16 models): https://sketchfab.com/ngdkh/collections/vietnam-f6280289e8054cc08c31891fced8d623. Listed examples include Vietnamese House in 2000s, Vietnamese Vegetable Market, Vietnamese Meat Market stall, ModularKit Vietnam, Vietnamese lantern, altar, bed and street props. Treat each item as a separate asset with its own license/download verification.
- Saigon 3D City creator page: https://sketchfab.com/saigon3dcity/models. Listed scenes include Hanoi 3D City (9/2025), Ho Chi Minh City 2025, Chợ Lớn, Nguyễn Huệ walking street and District 1 test. City-scale scenes may be heavy and should be split/optimized into streamed chunks; inspect coverage and source accuracy before use.
- Saigon tag: https://sketchfab.com/tags/saigon. Search result examples include Independence Palace, Saigon Notre-Dame Cathedral, Bưu Điện Thành Phố, Landmark 81, Vietnamese hat and street-food carts.
- Vietnamese streets by NGUYENNGHIAKK: https://sketchfab.com/3d-models/vietnamese-streets-e2ce91e4d7d349c7912a0ad065ceec56 — 6.9k triangles, CC BY; creator's page points to an external Google Drive archive, so inspect the archive and retain attribution.
- Vietnamese old town scan: https://sketchfab.com/3d-models/vietnams-old-town-c1251dd5edfb4f73ab6ac98ca3e3a188 — 2.2M triangles, CC BY; scan source requires decimation, texture baking, modular splitting and LODs.
- Vietnamese Vegetable Market: https://sketchfab.com/3d-models/vietnamese-vegetable-market-a3c935d758624c8f866bc27776f86712 — 6.7k triangles, low-poly, CC BY; useful as a market layout/prop candidate but not photoreal final art.
- ModularKit Vietnam: https://sketchfab.com/3d-models/modularkit-vietnam-40c57d9e7d944ee5a0524f0677349c04 — 24.2k triangles, CC BY; modular street/environment parts candidate.
- Vietnamese nón lá: https://sketchfab.com/3d-models/vietnamese---non-la-abd86436d03344b9a40c82e127fb6252 — 1.5k triangles, CC BY; wearable prop candidate.

### Collection triage rules

1. Prioritize downloadable CC BY/CC0 assets with clear creator attribution and embedded textures.
2. Use accurate Vietnamese architecture, markets, street props and landmarks as environment assets; do not assume every result is realistic or game-ready.
3. Treat city scans as source geometry/reference. Split by blocks, decimate, rebake normals/AO, create collision proxies and LODs before mobile import.
4. Human models must pass the project's face anatomy, skeleton, animation and mobile LOD checks. A Vietnam tag alone does not establish facial authenticity.
5. Vehicle models must match exact make/model/year and have separate named mechanical parts and wheel/steering pivots. Generic scooters are not acceptable as named Honda/Yamaha models.
6. Record exact model URL, creator, license, download date, original archive checksum, conversion steps and in-game credit in the asset manifest.
7. Search results and collections are discovery indexes only. Do not mark an asset downloaded, integrated or accepted until the actual binary has been obtained and inspected.
