extends Node3D

@export var shop_type := "food"
@export var shop_name := "Cửa hàng"
@export var sign_color := Color(0.82, 0.2, 0.12)

func _ready() -> void:
	add_to_group("interactable")
	_build_shopfront()

func interact() -> String:
	var shop_ui := get_tree().get_first_node_in_group("shop_ui")
	if shop_ui and shop_ui.has_method("open_shop"):
		shop_ui.open_shop(shop_type, shop_name)
		return "Đã mở %s." % shop_name
	return "Cửa hàng đang chuẩn bị mở. Hãy thử lại sau."

func _build_shopfront() -> void:
	var wall := _add_box("ShopBody", Vector3(0, 1.25, 0), Vector3(5.0, 2.5, 3.2), Color(0.82, 0.76, 0.63))
	_add_box("Counter", Vector3(0, 0.55, -1.85), Vector3(4.5, 1.1, 0.45), Color(0.34, 0.2, 0.12))
	_add_box("Awning", Vector3(0, 2.45, -1.55), Vector3(5.3, 0.18, 1.2), sign_color)
	_add_box("SignBoard", Vector3(0, 2.05, -1.72), Vector3(4.5, 0.72, 0.12), sign_color)
	var sign := Label3D.new()
	sign.text = shop_name.to_upper()
	sign.position = Vector3(0, 2.05, -1.82)
	sign.font_size = 28
	sign.modulate = Color.WHITE
	sign.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	add_child(sign)
	# Small display props make each shop recognizable even before final art arrives.
	if shop_type == "vehicle":
		_add_box("DisplayPlatform", Vector3(0, 0.12, 2.2), Vector3(4.0, 0.24, 2.0), Color(0.24, 0.25, 0.27))
	elif shop_type == "clothing":
		_add_box("ClothingRack", Vector3(0, 1.25, 2.0), Vector3(3.2, 1.6, 0.12), Color(0.2, 0.22, 0.25))
	else:
		_add_box("FoodDisplay", Vector3(0, 0.9, 2.0), Vector3(3.2, 0.8, 1.0), Color(0.58, 0.32, 0.12))

func _add_box(object_name: String, at: Vector3, dimensions: Vector3, color: Color) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = object_name
	var box := BoxMesh.new()
	box.size = dimensions
	mesh_instance.mesh = box
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.82
	mesh_instance.material_override = material
	mesh_instance.position = at
	add_child(mesh_instance)
	return mesh_instance
