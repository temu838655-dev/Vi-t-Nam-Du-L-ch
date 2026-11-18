#!/usr/bin/env python3
"""Validate production 3D asset manifest without treating placeholders as finished assets."""
import json
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
manifest_path = root / "assets" / "asset_manifest.json"

try:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError) as exc:
    print(f"ASSET MANIFEST ERROR: {exc}", file=sys.stderr)
    raise SystemExit(1)

allowed = {"blocked_no_production_model", "in_production", "needs_review", "accepted"}
errors = []
assets = manifest.get("assets")
if not isinstance(assets, list):
    errors.append("'assets' must be an array")
    assets = []

seen = set()
for asset in assets:
    asset_id = asset.get("id")
    if not asset_id or asset_id in seen:
        errors.append(f"missing or duplicate asset id: {asset_id!r}")
        continue
    seen.add(asset_id)

    status = asset.get("status")
    if status not in allowed:
        errors.append(f"{asset_id}: unsupported status {status!r}")
        continue

    files = asset.get("required_files", [])
    if not isinstance(files, list) or not files:
        errors.append(f"{asset_id}: required_files must be a non-empty array")
        continue

    missing = [path for path in files if not (root / "assets" / path).is_file()]
    if status == "accepted":
        if missing:
            errors.append(f"{asset_id}: accepted asset has missing files: {missing}")
        if not asset.get("source") or not asset.get("license"):
            errors.append(f"{asset_id}: accepted asset must record source and license")
        if not asset.get("requirements"):
            errors.append(f"{asset_id}: accepted asset must declare acceptance requirements")

if errors:
    print("3D ASSET VALIDATION FAILED:")
    for error in errors:
        print(f"- {error}")
    raise SystemExit(1)

print(f"3D asset manifest valid: {len(assets)} tracked assets.")
for asset in assets:
    print(f"- {asset['id']}: {asset['status']}")
