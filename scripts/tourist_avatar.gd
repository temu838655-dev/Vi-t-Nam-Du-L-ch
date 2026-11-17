extends Node3D
# Stylized temporary tourist avatar. Replace with licensed, rigged Vietnamese character assets for final realism.

func _ready() -> void:
    _part("Head", SphereMesh.new(), Vector3(0, 1.42, 0), Vector3(0.34, 0.38, 0.31), Color("#f2c7a5"))
    _part("Hair", SphereMesh.new(), Vector3(0, 1.63, -0.06), Vector3(0.36, 0.25, 0.34), Color("#30231f"))
    _part("Shirt", CapsuleMesh.new(), Vector3(0, 0.91, 0), Vector3(0.55, 0.55, 0.36), Color("#f3f1e8"))
    _part("Backpack", BoxMesh.new(), Vector3(0, 0.98, 0.28), Vector3(0.48, 0.58, 0.2), Color("#1756a5"))
    _part("Pants", CapsuleMesh.new(), Vector3(0, 0.39, 0), Vector3(0.43, 0.48, 0.29), Color("#243e68"))
    _part("LeftShoe", BoxMesh.new(), Vector3(-0.16, 0.08, -0.04), Vector3(0.22, 0.13, 0.34), Color("#dce5ef"))
    _part("RightShoe", BoxMesh.new(), Vector3(0.16, 0.08, -0.04), Vector3(0.22, 0.13, 0.34), Color("#dce5ef"))
    _part("FlagPatch", BoxMesh.new(), Vector3(0.0, 1.0, -0.13), Vector3(0.12, 0.08, 0.025), Color("#da2929"))

func _part(part_name: String, mesh: Mesh, pos: Vector3, scale_value: Vector3, tint: Color) -> void:
    var node := MeshInstance3D.new()
    node.name = part_name
    node.mesh = mesh
    node.position = pos
    node.scale = scale_value
    var material := StandardMaterial3D.new()
    material.albedo_color = tint
    material.roughness = 0.82
    node.material_override = material
    add_child(node)
