#!/usr/bin/env python3
"""Validate licensed production GLB assets; never accept placeholder geometry."""
import json
import re
import struct
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "assets" / "asset_manifest.json"
ALLOWED = {"blocked_no_production_model", "in_production", "needs_review", "accepted"}


def fail(message):
    raise ValueError(message)


def read_glb(path):
    data = path.read_bytes()
    if len(data) < 20:
        fail("file is too small to be a GLB")
    magic, version, declared_length = struct.unpack_from("<4sII", data, 0)
    if magic != b"glTF" or version != 2 or declared_length != len(data):
        fail("invalid GLB header, version, or declared length")

    offset = 12
    document = None
    while offset + 8 <= len(data):
        chunk_length, chunk_type = struct.unpack_from("<II", data, offset)
        offset += 8
        end = offset + chunk_length
        if end > len(data):
            fail("GLB chunk extends beyond end of file")
        if chunk_type == 0x4E4F534A:
            try:
                document = json.loads(data[offset:end].decode("utf-8").rstrip(" \t\r\n\0"))
            except (UnicodeDecodeError, json.JSONDecodeError) as exc:
                fail(f"invalid GLB JSON chunk: {exc}")
            break
        offset = end
    if not isinstance(document, dict):
        fail("GLB has no valid JSON chunk")
    return document


def names(document):
    return [str(node.get("name", "")).lower() for node in document.get("nodes", [])]


def has_name(all_names, patterns):
    return any(re.search(pattern, name) for name in all_names for pattern in patterns)


def inspect_asset(asset, asset_root):
    problems = []
    asset_id = asset["id"]
    profile = asset.get("validation_profile", asset.get("category"))
    files = asset.get("required_files", [])
    glbs = [asset_root / item for item in files if str(item).lower().endswith(".glb")]
    if not glbs:
        return [f"{asset_id}: no required GLB file is declared"]

    for glb_path in glbs:
        if not glb_path.is_file():
            if asset["status"] == "accepted":
                problems.append(f"{asset_id}: accepted GLB is missing: {glb_path.relative_to(asset_root)}")
            continue
        try:
            doc = read_glb(glb_path)
        except (OSError, ValueError) as exc:
            problems.append(f"{asset_id}: {glb_path.name}: {exc}")
            continue

        meshes = doc.get("meshes", [])
        nodes = names(doc)
        skins = doc.get("skins", [])
        animations = doc.get("animations", [])
        materials = doc.get("materials", [])
        textures = doc.get("textures", [])
        images = doc.get("images", [])
        buffers = doc.get("buffers", [])

        # Android-ready GLBs should be self-contained; external file references
        # are easy to omit accidentally when importing assets into the project.
        external_refs = [
            item.get("uri") for item in buffers + images
            if isinstance(item, dict) and item.get("uri", "").startswith(("http://", "https://", "file://", "../", "./"))
        ]
        if external_refs:
            problems.append(f"{asset_id}: GLB contains external resource references: {external_refs}")

        if profile == "character":
            if not skins:
                problems.append(f"{asset_id}: character GLB has no skin/skeletal rig")
            if len(animations) < 3:
                problems.append(f"{asset_id}: character needs at least 3 embedded animation clips (found {len(animations)})")
            if len(meshes) < 1:
                problems.append(f"{asset_id}: character has no meshes")
            if not has_name(nodes, [r"head", r"face"]):
                problems.append(f"{asset_id}: no clearly named head/face node for art review")
            if not has_name(nodes, [r"hair"]):
                problems.append(f"{asset_id}: no clearly named hair node for art review")
            facial_parts = {
                "left eye": [r"eye[_ .-]?l(eft)?", r"l[_ .-]?eye"],
                "right eye": [r"eye[_ .-]?r(ight)?", r"r[_ .-]?eye"],
                "iris": [r"iris"],
                "pupil": [r"pupil"],
                "eyelid": [r"eyelid", r"eye[_ .-]?lid"],
                "eyebrow": [r"brow", r"eyebrow"],
                "nose bridge/tip": [r"nose"],
                "nostril": [r"nostril"],
                "upper/lower lips": [r"lip"],
                "mouth cavity": [r"mouth", r"oral"],
                "teeth": [r"teeth", r"tooth"],
                "left/right ears": [r"ear"],
                "jaw/chin": [r"jaw", r"chin"]
            }
            for part, patterns in facial_parts.items():
                if not has_name(nodes, patterns):
                    problems.append(f"{asset_id}: missing clearly named facial feature node: {part}")
            # Require distinct left and right eye nodes rather than one generic eye mesh.
            left_eye = has_name(nodes, [r"eye[_ .-]?l(eft)?", r"l[_ .-]?eye"])
            right_eye = has_name(nodes, [r"eye[_ .-]?r(ight)?", r"r[_ .-]?eye"])
            if not left_eye or not right_eye:
                problems.append(f"{asset_id}: eyes must be separate named left/right nodes")
            # Facial movement may be authored as glTF morph targets or facial bones.
            morph_targets = any(
                isinstance(primitive, dict) and bool(primitive.get("targets"))
                for mesh in meshes if isinstance(mesh, dict)
                for primitive in mesh.get("primitives", [])
            )
            facial_bones = has_name(nodes, [
                r"jaw", r"mouth", r"lip", r"eyelid", r"eye.?lid",
                r"brow", r"cheek", r"facial"
            ])
            if not morph_targets and not facial_bones:
                problems.append(f"{asset_id}: no facial morph targets or facial rig bones for expressions/lip sync")
        elif profile == "motorbike":
            if len(meshes) < 10:
                problems.append(f"{asset_id}: production motorbike needs at least 10 distinct mesh parts (found {len(meshes)})")
            motorbike_parts = {
                "front wheel": [r"wheel.*front", r"front.*wheel", r"banh.*truoc"],
                "rear wheel": [r"wheel.*rear", r"rear.*wheel", r"banh.*sau"],
                "steering/handlebar": [r"steer", r"handlebar", r"ghi.?dong"],
                "front suspension/fork": [r"fork", r"suspension.*front", r"front.*suspension"],
                "rear suspension": [r"suspension.*rear", r"rear.*suspension", r"shock"],
                "seat": [r"seat", r"saddle", r"yen"],
                "headlight": [r"head.?light", r"front.?lamp", r"den.?pha"],
                "tail light": [r"tail.?light", r"rear.?lamp", r"den.?hau"],
                "mirror": [r"mirror", r"guong"],
                "exhaust/muffler": [r"exhaust", r"muffler", r"ong.?xa"],
                "brake detail": [r"brake", r"disc", r"drum"],
                "body panels": [r"body", r"fairing", r"panel", r"cowling"]
            }
            for part, patterns in motorbike_parts.items():
                if not has_name(nodes, patterns):
                    problems.append(f"{asset_id}: missing separately named production part: {part}")
        elif profile == "environment":
            if len(meshes) < 8:
                problems.append(f"{asset_id}: environment needs at least 8 mesh parts for detail review (found {len(meshes)})")
        else:
            problems.append(f"{asset_id}: unknown validation profile {profile!r}")

        if asset["status"] == "accepted":
            if not materials:
                problems.append(f"{asset_id}: accepted GLB has no materials")
            if not textures:
                problems.append(f"{asset_id}: accepted GLB has no embedded PBR textures")
            if not images:
                problems.append(f"{asset_id}: accepted GLB has no embedded image data")

    return problems


try:
    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError) as exc:
    print(f"ASSET MANIFEST ERROR: {exc}", file=sys.stderr)
    raise SystemExit(1)

assets = manifest.get("assets")
errors = []
if not isinstance(assets, list):
    errors.append("'assets' must be an array")
    assets = []

seen = set()
for asset in assets:
    if not isinstance(asset, dict):
        errors.append("each asset entry must be an object")
        continue
    asset_id = asset.get("id")
    if not asset_id or asset_id in seen:
        errors.append(f"missing or duplicate asset id: {asset_id!r}")
        continue
    seen.add(asset_id)

    status = asset.get("status")
    if status not in ALLOWED:
        errors.append(f"{asset_id}: unsupported status {status!r}")
        continue

    files = asset.get("required_files", [])
    if not isinstance(files, list) or not files:
        errors.append(f"{asset_id}: required_files must be a non-empty array")
        continue

    safe_paths = []
    for relative in files:
        candidate = (ROOT / "assets" / str(relative)).resolve()
        try:
            candidate.relative_to((ROOT / "assets").resolve())
        except ValueError:
            errors.append(f"{asset_id}: asset path escapes Godot/assets: {relative!r}")
            continue
        safe_paths.append(candidate)

    if status == "accepted":
        missing = [str(path) for path in safe_paths if not path.is_file()]
        if missing:
            errors.append(f"{asset_id}: accepted asset has missing files: {missing}")
        if not asset.get("source") or not asset.get("license"):
            errors.append(f"{asset_id}: accepted asset must record source and license")
        if not asset.get("requirements"):
            errors.append(f"{asset_id}: accepted asset must declare acceptance requirements")

    if status in {"in_production", "needs_review", "accepted"}:
        errors.extend(inspect_asset(asset, ROOT / "assets"))

if errors:
    print("3D ASSET VALIDATION FAILED:")
    for error in errors:
        print(f"- {error}")
    raise SystemExit(1)

print(f"3D asset manifest valid: {len(assets)} tracked assets.")
for asset in assets:
    print(f"- {asset['id']}: {asset['status']}")
