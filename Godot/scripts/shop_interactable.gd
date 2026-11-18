extends Node3D

class ShopSeatInteractable:
	extends Node3D

	var display_name := "Chỗ ngồi trong quán"

	func _ready() -> void:
		add_to_group("interactable")

	func interact() -> String:
		var player_node := get_tree().get_first_node_in_group("player")
		if is_instance_valid(player_node) and player_node.has_method("begin_home_action"):
			player_node.call("begin_home_action", "cafe")
			return "Bạn ngồi nghỉ tại %s. Hãy thư giãn và ngắm không khí nhộn nhịp của quán." % display_name
		return "Bạn tìm một chỗ ngồi trong quán."

@export var shop_type := "food"
@export var shop_name := "Cửa hàng"
@export var sign_color := Color(0.82, 0.2, 0.12)

var staff_left_arm: MeshInstance3D
var staff_right_arm: MeshInstance3D
var staff_idle_time := 0.0

func _ready() -> void:
	add_to_group("interactable")
	_build_shopfront()

func _process(delta: float) -> void:
	staff_idle_time += delta
	if is_instance_valid(staff_left_arm):
		staff_left_arm.rotation.z = sin(staff_idle_time * 1.25) * 0.055
	if is_instance_valid(staff_right_arm):
		staff_right_arm.rotation.z = sin(staff_idle_time * 1.25 + 1.2) * 0.055

func interact() -> String:
	var shop_ui := get_tree().get_first_node_in_group("shop_ui")
	if shop_ui and shop_ui.has_method("open_shop"):
		shop_ui.open_shop(shop_type, shop_name)
		return "Đã mở %s." % shop_name
	return "Cửa hàng đang chuẩn bị mở. Hãy thử lại sau."

func _build_shopfront() -> void:
	# Walk-in shop shell: an open entrance, side/back walls and a walkable floor.
	_add_solid_box("Shop_Floor", Vector3(0, 0.04, 0), Vector3(5.0, 0.12, 3.2), Color(0.55, 0.51, 0.43))
	_add_solid_box("Shop_LeftWall", Vector3(-2.45, 1.35, 0), Vector3(0.16, 2.7, 3.2), Color(0.82, 0.76, 0.63))
	_add_solid_box("Shop_RightWall", Vector3(2.45, 1.35, 0), Vector3(0.16, 2.7, 3.2), Color(0.82, 0.76, 0.63))
	_add_solid_box("Shop_BackWall", Vector3(0, 1.35, 1.52), Vector3(5.0, 2.7, 0.16), Color(0.82, 0.76, 0.63))
	_add_solid_box("Shop_Roof", Vector3(0, 2.78, 0), Vector3(5.0, 0.16, 3.2), sign_color.darkened(0.32))
	# Front facade is split into two side pillars, leaving a central walk-in doorway.
	_add_solid_box("Shop_FrontLeft", Vector3(-2.0, 1.25, -1.52), Vector3(0.9, 2.5, 0.16), Color(0.82, 0.76, 0.63))
	_add_solid_box("Shop_FrontRight", Vector3(2.0, 1.25, -1.52), Vector3(0.9, 2.5, 0.16), Color(0.82, 0.76, 0.63))
	_add_solid_box("Shop_FrontLintel", Vector3(0, 2.48, -1.52), Vector3(3.2, 0.24, 0.16), Color(0.82, 0.76, 0.63))
	_add_visual_box("Awning", Vector3(0, 2.65, -1.9), Vector3(5.3, 0.18, 0.85), sign_color)
	_add_visual_box("SignBoard", Vector3(0, 2.12, -1.64), Vector3(4.5, 0.62, 0.12), sign_color)
	var sign := Label3D.new()
	sign.text = shop_name.to_upper()
	sign.position = Vector3(0, 2.1, -1.72)
	sign.font_size = 25
	sign.modulate = Color.WHITE
	sign.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	add_child(sign)
	_add_visual_box("Counter", Vector3(0, 0.58, -0.42), Vector3(3.5, 1.05, 0.52), Color(0.34, 0.2, 0.12))
	_add_visual_box("CounterTop", Vector3(0, 1.13, -0.42), Vector3(3.7, 0.12, 0.62), Color(0.55, 0.39, 0.24))
	_add_visual_box("CashRegister", Vector3(1.15, 1.28, -0.42), Vector3(0.42, 0.22, 0.32), Color(0.08, 0.10, 0.12))
	_build_shop_displays()

func _build_shop_displays() -> void:
	match shop_type:
		"vehicle":
			_add_visual_box("VehicleDisplayPlatform", Vector3(0, 0.18, 0.95), Vector3(3.8, 0.24, 1.0), Color(0.24, 0.25, 0.27))
			_add_visual_box("VehicleBackShelf", Vector3(0, 1.65, 1.32), Vector3(4.0, 1.25, 0.12), Color(0.24, 0.27, 0.31))
			for index in range(4):
				var x := -1.35 + float(index) * 0.9
				_add_visual_box("VehicleStand_%02d" % index, Vector3(x, 0.45, 0.72), Vector3(0.52, 0.28, 0.62), Color(0.58, 0.56, 0.5))
				_add_visual_box("VehicleSample_%02d" % index, Vector3(x, 0.85, 0.72), Vector3(0.42, 0.5, 0.18), [Color(0.78,0.08,0.06),Color(0.08,0.16,0.28),Color(0.72,0.72,0.68),Color(0.12,0.38,0.22)][index])
		"clothing":
			for rack_index in range(2):
				var z := 0.35 + float(rack_index) * 0.85
				_add_visual_box("ClothingRack_%02d" % rack_index, Vector3(-1.25, 1.35, z), Vector3(0.12, 1.7, 0.12), Color(0.18, 0.2, 0.23))
				_add_visual_box("ClothingRail_%02d" % rack_index, Vector3(-1.25, 2.12, z), Vector3(1.35, 0.08, 0.08), Color(0.65, 0.64, 0.6))
				for hanger in range(4):
					_add_visual_box("ClothingItem_%02d_%02d" % [rack_index, hanger], Vector3(-1.72 + float(hanger) * 0.31, 1.55, z), Vector3(0.25, 0.75, 0.10), [Color(0.72,0.12,0.18),Color(0.12,0.32,0.68),Color(0.16,0.42,0.3),Color(0.82,0.72,0.52)][hanger])
			_add_visual_box("ClothingMirrorFrame", Vector3(1.45, 1.25, 0.75), Vector3(0.12, 1.9, 0.8), Color(0.18, 0.2, 0.22))
			_add_visual_box("ClothingMirror", Vector3(1.38, 1.25, 0.75), Vector3(0.035, 1.65, 0.58), Color(0.42, 0.62, 0.68))
		_:
			_add_visual_box("FoodDisplay", Vector3(0, 0.95, 0.9), Vector3(3.8, 0.8, 0.72), Color(0.58, 0.32, 0.12))
			_add_visual_box("FoodShelf_Back", Vector3(0, 1.85, 1.35), Vector3(4.0, 0.12, 0.18), Color(0.34, 0.22, 0.12))
			for index in range(5):
				var x := -1.55 + float(index) * 0.77
				_add_visual_box("FoodPackage_%02d" % index, Vector3(x, 1.42, 0.82), Vector3(0.42, 0.52, 0.38), [Color(0.72,0.18,0.12),Color(0.82,0.62,0.18),Color(0.18,0.42,0.24),Color(0.78,0.72,0.58),Color(0.16,0.32,0.58)][index])
			_add_visual_box("DiningTable", Vector3(1.45, 0.72, 1.0), Vector3(1.1, 0.12, 0.72), Color(0.42, 0.25, 0.13))
			_add_visual_box("DiningChair_Seat", Vector3(1.45, 0.48, 0.18), Vector3(0.62, 0.12, 0.62), Color(0.36, 0.22, 0.12))
			_add_visual_box("DiningChair_Back", Vector3(1.45, 0.86, -0.08), Vector3(0.62, 0.72, 0.10), Color(0.36, 0.22, 0.12))
			for leg_x in [-0.22, 0.22]:
				for leg_z in [-0.20, 0.20]:
					_add_visual_box("DiningChair_Leg_%s_%s" % [str(leg_x), str(leg_z)], Vector3(1.45 + leg_x, 0.24, 0.18 + leg_z), Vector3(0.07, 0.48, 0.07), Color(0.28, 0.18, 0.10))
			var seat_target := ShopSeatInteractable.new()
			seat_target.name = "DiningSeatInteraction"
			seat_target.display_name = "Bàn ăn của " + shop_name
			seat_target.position = Vector3(1.45, 0.0, -0.35)
			add_child(seat_target)
	# Static low-poly attendant behind the counter; interaction is handled by the shop itself.
	_build_shop_staff()


func _build_shop_staff() -> void:
	var uniform_color := sign_color.lightened(0.18)
	_add_person_capsule("Staff_Torso", 0.25, 0.78, Vector3(0, 1.08, 0.42), uniform_color)
	_add_person_capsule("Staff_Head", 0.19, 0.38, Vector3(0, 1.72, 0.42), Color(0.72, 0.49, 0.36))
	staff_left_arm = _add_person_capsule("Staff_LeftArm", 0.085, 0.58, Vector3(-0.31, 1.12, 0.34), uniform_color)
	staff_right_arm = _add_person_capsule("Staff_RightArm", 0.085, 0.58, Vector3(0.31, 1.12, 0.34), uniform_color)
	var label := Label3D.new()
	label.text = "NHÂN VIÊN"
	label.position = Vector3(0, 2.18, 0.42)
	label.font_size = 17
	label.modulate = Color(1.0, 0.9, 0.72)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func _add_person_capsule(part_name: String, radius: float, height: float, at: Vector3, tint: Color) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	part.mesh = mesh
	part.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.88
	part.material_override = material
	add_child(part)
	return part

func _add_solid_box(object_name: String, at: Vector3, dimensions: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = object_name
	body.position = at
	var mesh_instance := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = dimensions
	mesh_instance.mesh = box
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.86
	mesh_instance.material_override = material
	body.add_child(mesh_instance)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	body.add_child(collision)
	add_child(body)

func _add_visual_box(object_name: String, at: Vector3, dimensions: Vector3, color: Color) -> void:
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
