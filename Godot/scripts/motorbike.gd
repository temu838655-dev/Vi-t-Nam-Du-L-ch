extends Node3D

@export var display_name := "Xe máy"
@export var body_color := Color(0.82, 0.12, 0.08)

var rider: CharacterBody3D
var label: Label3D

func _ready() -> void:
	add_to_group("interactable")
	_build_motorbike()
	label = Label3D.new()
	label.text = display_name + "\nNHẤN TƯƠNG TÁC"
	label.position = Vector3(0, 2.0, 0)
	label.font_size = 24
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func _process(_delta: float) -> void:
	if is_instance_valid(rider):
		global_position = rider.global_position - Vector3(0, 1.1, 0)
		global_rotation.y = rider.global_rotation.y
		if label:
			label.text = display_name + "\nĐANG SỬ DỤNG"

func interact() -> String:
	if is_instance_valid(rider):
		if rider.has_method("exit_vehicle"):
			return str(rider.exit_vehicle())
		return "Không thể xuống xe lúc này."
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return "Chưa tìm thấy người chơi."
	var player := players[0] as CharacterBody3D
	if player and player.has_method("enter_vehicle"):
		return str(player.enter_vehicle(self))
	return "Không thể sử dụng xe máy."

func set_rider(value: CharacterBody3D) -> void:
	rider = value
	if label:
		label.text = display_name + "\nĐANG SỬ DỤNG"

func clear_rider() -> void:
	rider = null
	if label:
		label.text = display_name + "\nNHẤN TƯƠNG TÁC"

func _build_motorbike() -> void:
	var red := _material(body_color)
	var black := _material(Color(0.045, 0.05, 0.06))
	var metal := _material(Color(0.48, 0.52, 0.56))
	var seat_material := _material(Color(0.12, 0.09, 0.08))
	var light_material := _material(Color(1.0, 0.88, 0.52), true)

	_add_box("Khung xe", Vector3(0, 0.78, 0), Vector3(0.48, 0.34, 1.25), black)
	_add_box("Bình xăng", Vector3(0, 1.12, -0.18), Vector3(0.58, 0.42, 0.62), red)
	_add_box("Yên xe", Vector3(0, 1.18, 0.42), Vector3(0.52, 0.18, 0.72), seat_material)
	_add_box("Đuôi xe", Vector3(0, 1.03, 0.82), Vector3(0.48, 0.2, 0.38), red)
	_add_box("Đèn trước", Vector3(0, 1.35, -0.83), Vector3(0.32, 0.22, 0.12), light_material)
	_add_box("Tay lái", Vector3(0, 1.42, -0.9), Vector3(0.92, 0.07, 0.08), metal)
	_add_box("Phuộc trước", Vector3(0, 0.88, -0.95), Vector3(0.12, 0.76, 0.12), metal)
	_add_box("Ống xả", Vector3(0.32, 0.58, 0.55), Vector3(0.16, 0.16, 0.78), metal)
	_add_wheel("Bánh trước", Vector3(0, 0.43, -1.02), black, metal)
	_add_wheel("Bánh sau", Vector3(0, 0.43, 0.95), black, metal)

func _add_wheel(wheel_name: String, at: Vector3, tire_material: StandardMaterial3D, rim_material: StandardMaterial3D) -> void:
	var wheel := MeshInstance3D.new()
	wheel.name = wheel_name
	var tire := CylinderMesh.new()
	tire.top_radius = 0.4
	tire.bottom_radius = 0.4
	tire.height = 0.18
	wheel.mesh = tire
	wheel.material_override = tire_material
	wheel.position = at
	wheel.rotation.z = PI * 0.5
	add_child(wheel)

	var hub := MeshInstance3D.new()
	var hub_mesh := CylinderMesh.new()
	hub_mesh.top_radius = 0.16
	hub_mesh.bottom_radius = 0.16
	hub_mesh.height = 0.2
	hub.mesh = hub_mesh
	hub.material_override = rim_material
	hub.position = at
	hub.rotation.z = PI * 0.5
	add_child(hub)

func _add_box(object_name: String, at: Vector3, dimensions: Vector3, material: StandardMaterial3D) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = object_name
	var box := BoxMesh.new()
	box.size = dimensions
	mesh_instance.mesh = box
	mesh_instance.material_override = material
	mesh_instance.position = at
	add_child(mesh_instance)

func _material(color: Color, emission: bool = false) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	if emission:
		material.emission_enabled = true
		material.emission = color
	return material
