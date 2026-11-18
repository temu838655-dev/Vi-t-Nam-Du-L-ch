extends Node3D

@export var display_name := "Xe máy"
@export var body_color := Color(0.82, 0.12, 0.08)

var rider: CharacterBody3D
var label: Label3D
var speed_label: Label3D
var wheel_nodes: Array[Node3D] = []
var front_wheel: Node3D
var wheel_rotation := 0.0
const PRODUCTION_MODEL_PATH := "res://assets/vehicles/motorbikes/honda_wave_alpha_110.glb"
var using_production_model := false
var production_model: Node3D
var steering_pivot: Node3D

func _ready() -> void:
	add_to_group("interactable")
	_build_motorbike()
	label = Label3D.new()
	_refresh_label()
	label.position = Vector3(0, 2.0, 0)
	label.font_size = 24
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)
	speed_label = Label3D.new()
	speed_label.name = "Speedometer3D"
	speed_label.position = Vector3(0, 1.72, -0.72)
	speed_label.font_size = 30
	speed_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	speed_label.modulate = Color(0.55, 0.95, 1.0)
	add_child(speed_label)

func _process(delta: float) -> void:
	if is_instance_valid(rider):
		global_position = rider.global_position - Vector3(0, 1.1, 0)
		global_rotation.y = rider.global_rotation.y
		var speed_mps := Vector2(rider.velocity.x, rider.velocity.z).length()
		var speed_kmh := int(round(speed_mps * 3.6))
		wheel_rotation += speed_mps * delta / 0.38
		for wheel in wheel_nodes:
			wheel.rotation.x = wheel_rotation
		if is_instance_valid(steering_pivot):
			steering_pivot.rotation.y = clampf(-rider.velocity.dot(global_transform.basis.x) * 0.035, -0.32, 0.32)
		elif is_instance_valid(front_wheel):
			front_wheel.rotation.y = clampf(-rider.velocity.dot(global_transform.basis.x) * 0.035, -0.32, 0.32)
		rotation.z = lerpf(rotation.z, clampf(-rider.velocity.dot(global_transform.basis.x) * 0.018, -0.12, 0.12), delta * 5.0)
		if label:
			label.text = display_name + "\nĐANG SỬ DỤNG"
		if speed_label:
			speed_label.text = "%03d km/h" % speed_kmh
	else:
		rotation.z = lerpf(rotation.z, 0.0, delta * 4.0)
		if speed_label:
			speed_label.text = "00 km/h"

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
	_refresh_label()

func clear_rider() -> void:
	rider = null
	_refresh_label()

func _refresh_label() -> void:
	if not is_instance_valid(label):
		return
	if is_instance_valid(rider):
		label.text = display_name + "\nĐANG SỬ DỤNG"
	elif using_production_model:
		label.text = display_name + "\nNHẤN TƯƠNG TÁC"
	else:
		label.text = display_name + "\nMÔ HÌNH THỬ NGHIỆM"

func _build_motorbike() -> void:
	if _load_production_model():
		return

	# Clearly identified prototype fallback. It is not production vehicle art.
	var lower_name := display_name.to_lower()
	var is_scooter := "vision" in lower_name or "air blade" in lower_name or "sh" in lower_name or "lead" in lower_name or "janus" in lower_name
	var is_sport := "exciter" in lower_name
	var paint := _material(body_color)
	var black := _material(Color(0.035, 0.04, 0.045))
	var rubber := _material(Color(0.018, 0.02, 0.022))
	var metal := _material(Color(0.48, 0.52, 0.56))
	var seat_material := _material(Color(0.075, 0.06, 0.055))
	var headlight := _material(Color(1.0, 0.9, 0.62), true)
	var tail_light := _material(Color(0.9, 0.035, 0.025), true)
	var signal_light := _material(Color(1.0, 0.48, 0.04), true)

	_add_box("Khung sườn", Vector3(0, 0.78, 0), Vector3(0.34, 0.22, 1.42), black)
	_add_box("Động cơ", Vector3(0, 0.61, 0.05), Vector3(0.48, 0.42, 0.52), metal)
	_add_box("Yên xe", Vector3(0, 1.18, 0.42), Vector3(0.5, 0.17, 0.78), seat_material)
	_add_box("Đuôi xe", Vector3(0, 1.05, 0.86), Vector3(0.46, 0.22, 0.38), paint)
	_add_box("Đèn hậu", Vector3(0, 1.12, 1.06), Vector3(0.3, 0.12, 0.08), tail_light)
	_add_box("Tay lái", Vector3(0, 1.43, -0.86), Vector3(0.88, 0.065, 0.08), metal)
	_add_box("Cụm đồng hồ", Vector3(0, 1.43, -0.7), Vector3(0.32, 0.18, 0.24), black)
	_add_box("Đèn pha", Vector3(0, 1.34, -0.98), Vector3(0.32, 0.22, 0.12), headlight)
	_add_box("Phuộc trước trái", Vector3(-0.1, 0.88, -0.92), Vector3(0.07, 0.76, 0.1), metal)
	_add_box("Phuộc trước phải", Vector3(0.1, 0.88, -0.92), Vector3(0.07, 0.76, 0.1), metal)
	_add_box("Ống xả", Vector3(0.31, 0.58, 0.53), Vector3(0.14, 0.15, 0.74), metal)

	if is_scooter:
		_add_box("Yếm trước xe tay ga", Vector3(0, 1.08, -0.56), Vector3(0.62, 0.78, 0.28), paint)
		_add_box("Mặt nạ đầu xe", Vector3(0, 1.42, -0.82), Vector3(0.56, 0.42, 0.22), paint)
		_add_box("Sàn để chân", Vector3(0, 0.76, -0.1), Vector3(0.58, 0.12, 0.82), black)
		_add_box("Ốp hông trái", Vector3(-0.25, 0.91, 0.45), Vector3(0.12, 0.38, 0.72), paint)
		_add_box("Ốp hông phải", Vector3(0.25, 0.91, 0.45), Vector3(0.12, 0.38, 0.72), paint)
	elif is_sport:
		_add_box("Bình xăng thể thao", Vector3(0, 1.25, -0.16), Vector3(0.58, 0.44, 0.66), paint)
		_add_box("Dàn áo trái", Vector3(-0.29, 1.02, -0.28), Vector3(0.12, 0.52, 0.64), paint)
		_add_box("Dàn áo phải", Vector3(0.29, 1.02, -0.28), Vector3(0.12, 0.52, 0.64), paint)
		_add_box("Mỏ cày", Vector3(0, 0.63, -0.28), Vector3(0.52, 0.18, 0.58), black)
	else:
		_add_box("Yếm xe số", Vector3(0, 1.02, -0.46), Vector3(0.46, 0.56, 0.22), paint)
		_add_box("Ốp hông trái", Vector3(-0.24, 0.94, 0.34), Vector3(0.1, 0.3, 0.52), paint)
		_add_box("Ốp hông phải", Vector3(0.24, 0.94, 0.34), Vector3(0.1, 0.3, 0.52), paint)

	_add_box("Xi nhan trái", Vector3(-0.3, 1.31, -0.88), Vector3(0.12, 0.1, 0.12), signal_light)
	_add_box("Xi nhan phải", Vector3(0.3, 1.31, -0.88), Vector3(0.12, 0.1, 0.12), signal_light)
	_add_mirror(Vector3(-0.39, 1.68, -0.83), metal)
	_add_mirror(Vector3(0.39, 1.68, -0.83), metal)
	_add_box("Biển số", Vector3(0, 0.88, 1.12), Vector3(0.28, 0.16, 0.035), _material(Color(0.92, 0.92, 0.88)))

	var wheel_radius := 0.36 if is_scooter else 0.39
	front_wheel = _add_wheel("Bánh trước", Vector3(0, 0.43, -1.02), wheel_radius, rubber, metal)
	_add_wheel("Bánh sau", Vector3(0, 0.43, 0.95), wheel_radius, rubber, metal)


func _load_production_model() -> bool:
	if not ResourceLoader.exists(PRODUCTION_MODEL_PATH):
		return false
	var packed_model := load(PRODUCTION_MODEL_PATH) as PackedScene
	if packed_model == null:
		push_warning("Motorbike GLB exists but could not be loaded: " + PRODUCTION_MODEL_PATH)
		return false
	var instance := packed_model.instantiate()
	if not instance is Node3D:
		push_warning("Motorbike GLB root must be Node3D.")
		instance.queue_free()
		return false
	production_model = instance as Node3D
	_collect_production_rigs(production_model)
	var validation := _validate_production_motorbike(production_model)
	if not bool(validation.get("valid", false)):
		push_warning("Production motorbike GLB rejected by runtime quality gate: " + str(validation.get("errors", [])))
		production_model.queue_free()
		production_model = null
		wheel_nodes.clear()
		front_wheel = null
		steering_pivot = null
		return false
	production_model.name = "ProductionMotorbikeModel"
	add_child(production_model)
	using_production_model = true
	return true


func _validate_production_motorbike(root: Node) -> Dictionary:
	var report := {"valid": false, "errors": [], "parts": {}}
	_inspect_motorbike_parts(root, report["parts"])
	var parts: Dictionary = report["parts"]
	var errors: Array[String] = []
	for part in ["front_wheel", "rear_wheel", "steering", "front_suspension", "rear_suspension", "seat", "headlight", "tail_light", "mirror", "exhaust", "brake", "body_panel"]:
		if not bool(parts.get(part, false)):
			errors.append("missing named production component: " + part)
	if wheel_nodes.size() < 2:
		errors.append("front and rear wheel pivot nodes must both be discoverable")
	if steering_pivot == null:
		errors.append("steering pivot node is missing")
	report["errors"] = errors
	report["valid"] = errors.is_empty()
	return report


func _inspect_motorbike_parts(node: Node, parts: Dictionary) -> void:
	var n := node.name.to_lower().replace("_", "").replace("-", "").replace(" ", "")
	var checks := {
		"front_wheel": ("front" in n and "wheel" in n) or ("wheel" in n and "front" in n) or "banhtruoc" in n,
		"rear_wheel": ("rear" in n and "wheel" in n) or ("wheel" in n and "rear" in n) or "banhsau" in n,
		"steering": "steer" in n or "handlebar" in n or "ghidong" in n,
		"front_suspension": ("front" in n and ("fork" in n or "suspension" in n)) or "phuoctruoc" in n,
		"rear_suspension": ("rear" in n and ("shock" in n or "suspension" in n)) or "phuocsau" in n,
		"seat": "seat" in n or "saddle" in n or "yenxe" in n,
		"headlight": "headlight" in n or "frontlamp" in n or "denpha" in n,
		"tail_light": "taillight" in n or "rearlamp" in n or "denhau" in n,
		"mirror": "mirror" in n or "guong" in n,
		"exhaust": "exhaust" in n or "muffler" in n or "ongxa" in n,
		"brake": "brake" in n or "disc" in n or "drum" in n or "phanh" in n,
		"body_panel": "body" in n or "fairing" in n or "panel" in n or "cowling" in n or "danao" in n
	}
	for key in checks:
		if bool(checks[key]):
			parts[key] = true
	for child in node.get_children():
		_inspect_motorbike_parts(child, parts)


func _collect_production_rigs(root: Node) -> void:
	wheel_nodes.clear()
	front_wheel = null
	steering_pivot = null
	_find_rig_nodes(root)


func _find_rig_nodes(node: Node) -> void:
	var node_name := node.name.to_lower().replace("_", "").replace("-", "").replace(" ", "")
	if node is Node3D:
		var node_3d := node as Node3D
		if ("front" in node_name and "wheel" in node_name) or ("wheel" in node_name and "front" in node_name):
			front_wheel = node_3d
			wheel_nodes.append(node_3d)
		elif "rear" in node_name and "wheel" in node_name:
			wheel_nodes.append(node_3d)
		if ("steer" in node_name or "handlebar" in node_name) and steering_pivot == null:
			steering_pivot = node_3d
	for child in node.get_children():
		_find_rig_nodes(child)

func _add_mirror(at: Vector3, material: StandardMaterial3D) -> void:
	_add_box("Cần gương", at + Vector3(0, -0.13, 0.03), Vector3(0.035, 0.28, 0.035), material)
	var mirror := MeshInstance3D.new()
	var mirror_mesh := SphereMesh.new()
	mirror_mesh.radius = 0.11
	mirror_mesh.height = 0.12
	mirror.mesh = mirror_mesh
	mirror.scale = Vector3(1.0, 0.7, 0.45)
	mirror.position = at
	mirror.material_override = material
	add_child(mirror)

func _add_wheel(wheel_name: String, at: Vector3, radius: float, tire_material: StandardMaterial3D, rim_material: StandardMaterial3D) -> Node3D:
	var wheel := Node3D.new()
	wheel.name = wheel_name + "Assembly"
	wheel.position = at
	add_child(wheel)
	wheel_nodes.append(wheel)
	var tire_node := MeshInstance3D.new()
	var tire := CylinderMesh.new()
	tire.top_radius = radius
	tire.bottom_radius = radius
	tire.height = 0.18
	tire_node.mesh = tire
	tire_node.material_override = tire_material
	tire_node.rotation.z = PI * 0.5
	wheel.add_child(tire_node)

	var hub := MeshInstance3D.new()
	var hub_mesh := CylinderMesh.new()
	hub_mesh.top_radius = radius * 0.42
	hub_mesh.bottom_radius = radius * 0.42
	hub_mesh.height = 0.2
	hub.mesh = hub_mesh
	hub.material_override = rim_material
	hub.rotation.z = PI * 0.5
	wheel.add_child(hub)
	return wheel

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
	material.roughness = 0.72
	if emission:
		material.emission_enabled = true
		material.emission = color
	return material
