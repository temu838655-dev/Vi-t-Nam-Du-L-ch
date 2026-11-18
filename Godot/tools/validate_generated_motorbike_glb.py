#!/usr/bin/env python3
"""Structural gate for the original project-authored underbone motorcycle GLB."""
import json, pathlib, struct, sys
path=pathlib.Path(sys.argv[1] if len(sys.argv)>1 else "Godot/assets/vehicles/motorbikes/honda_wave_alpha_110.glb")
blob=path.read_bytes()
if len(blob)<20: raise SystemExit("GLB too small")
magic,version,total=struct.unpack_from("<4sII",blob,0)
if magic!=b"glTF" or version!=2 or total!=len(blob): raise SystemExit("Invalid GLB v2 header/length")
chunk_len,chunk_type=struct.unpack_from("<I4s",blob,12)
if chunk_type!=b"JSON": raise SystemExit("First GLB chunk is not JSON")
doc=json.loads(blob[20:20+chunk_len].decode("utf-8"))
names=[n.get("name","").lower().replace("_","").replace("-","").replace(" ","") for n in doc.get("nodes",[])]
checks={
 "front_wheel_rig": any("frontwheel" in n for n in names),
 "rear_wheel_rig": any("rearwheel" in n for n in names),
 "steering_pivot": any("steeringpivot" in n for n in names),
 "front_suspension": any("frontsuspension" in n for n in names),
 "rear_suspension": any("rearsuspension" in n for n in names),
 "seat": any("seatu pholstery".replace(" ","") in n for n in names),
 "headlight": any(n=="headlight" for n in names),
 "tail_light": any(n=="taillight" for n in names),
 "mirrors": sum(n.startswith("mirror") and not n.startswith("mirrorback") and not n.startswith("mirrorstem") for n in names)>=2,
 "exhaust": any("exhaustmuffler" in n for n in names),
 "brake_disc": any("frontbrakedisc" in n for n in names),
 "body_panels": sum("sidecover" in n or "legshield" in n or "fender" in n for n in names)>=5,
 "pbr_materials": len(doc.get("materials",[]))>=8,
 "mesh_count": len(doc.get("meshes",[]))>=35,
}
for key,ok in checks.items(): print(("PASS " if ok else "FAIL ")+key)
if not all(checks.values()): raise SystemExit("Motorcycle GLB failed structural gate")
print("GLB bytes:",len(blob),"nodes:",len(names),"meshes:",len(doc.get("meshes",[])),"materials:",len(doc.get("materials",[])))
