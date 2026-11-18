#!/usr/bin/env python3
"""Structural quality gate for the original Blender-generated hero GLB."""
import json
import pathlib
import struct
import sys

path = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "Godot/assets/characters/player/player_hero.glb")
blob = path.read_bytes()
if len(blob) < 20:
    raise SystemExit("GLB too small")
magic, version, total = struct.unpack_from("<4sII", blob, 0)
if magic != b"glTF" or version != 2 or total != len(blob):
    raise SystemExit("Invalid GLB v2 header/length")
chunk_len, chunk_type = struct.unpack_from("<I4s", blob, 12)
if chunk_type != b"JSON":
    raise SystemExit("First GLB chunk is not JSON")
doc = json.loads(blob[20:20 + chunk_len].decode("utf-8"))
nodes = [n.get("name", "").lower() for n in doc.get("nodes", [])]
meshes = doc.get("meshes", [])
animations = doc.get("animations", [])
skins = doc.get("skins", [])
all_names = nodes + [m.get("name", "").lower() for m in meshes]
checks = {
    "eyes": sum("eye" in n or "iris" in n or "pupil" in n for n in all_names) >= 4,
    "eyebrows": any("eyebrow" in n for n in all_names),
    "nose": any("nose" in n for n in all_names),
    "mouth_and_lips": any("mouth" in n for n in all_names) and any("lip" in n for n in all_names),
    "teeth": any("teeth" in n for n in all_names),
    "ears": sum("ear_" in n for n in all_names) >= 2,
    "skeleton_skin": bool(skins) and any(len(s.get("joints", [])) >= 15 for s in skins),
    "facial_morph_targets": any(p.get("targets") for m in meshes for p in m.get("primitives", [])),
    "animation_clips": len(animations) >= 4,
}
for key, ok in checks.items():
    print(("PASS" if ok else "FAIL") + " " + key)
if not all(checks.values()):
    raise SystemExit("Generated hero GLB failed structural quality gate")
print("GLB bytes:", len(blob), "nodes:", len(nodes), "meshes:", len(meshes), "animations:", len(animations))
