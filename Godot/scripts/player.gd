extends CharacterBody3D

signal interaction_message(message: String)

const MOTORBIKE_SCRIPT := preload("res://scripts/motorbike.gd")

@export var move_speed: float = 5.0
@export var acceleration: float = 18.0
@export var gravity: float = 22.0
var camera_pivot: Node3D
var camera: Camera3D
var player_visual: Node3D
var upper_body: MeshInstance3D
var lower_body: MeshInstance3D
var shoe_left: MeshInstance3D
var shoe_right: MeshInstance3D
var fullbody_overlay: MeshInstance3D
var helmet_node: MeshInstance3D
var mobile_input := Vector2.ZERO
var look_delta := Vector2.ZERO
var current_vehicle: Node3D

func _ready() -> void:
	add_to_group("player")
	_build_character_model()
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.34
	shape.height = 1.82
	collision.shape = shape
	collision.position.y = 0.91
	add_child(collision)
	camera_pivot = Node3D.new()
	camera_pivot.position = Vector3(0, 1.55, 0)
	add_child(camera_pivot)
	camera = Camera3D.new()
	camera.position = Vector3(0, 2.2, 5.5)
	camera.rotation_degrees = Vector3(-13, 0, 0)
	camera.current = true
	camera_pivot.add_child(camera)
	apply_outfit(GameState.equipped_clothes)

func _build_character_model() -> void:
	player_visual = Node3D.new()
	player_visual.name = "CharacterVisual"
	add_child(player_visual)

	var skin := _make_material(Color(0.72, 0.49, 0.36))
	var hair := _make_material(Color(0.055, 0.045, 0.04))
	var shirt := _make_material(Color(0.12, 0.32, 0.72))
	var pants := _make_material(Color(0.12, 0.22, 0.48))
	var shoes := _make_material(Color(0.16, 0.15, 0.14))
	var eyes := _make_material(Color(0.025, 0.02, 0.02))

	upper_body = _add_capsule("UpperBody", 0.27, 0.86, Vector3(0, 1.13, 0), shirt)
	lower_body = _add_capsule("LowerBody", 0.19, 0.76, Vector3(0, 0.49, 0), pants)
	_add_capsule("LeftArm", 0.105, 0.78, Vector3(-0.36, 1.12, 0), shirt).rotation.z = deg_to_rad(-9)
	_add_capsule("RightArm", 0.105, 0.78, Vector3(0.36, 1.12, 0), shirt).rotation.z = deg_to_rad(9)
	_add_capsule("LeftHand", 0.09, 0.2, Vector3(-0.39, 0.68, -0.01), skin)
	_add_capsule("RightHand", 0.09, 0.2, Vector3(0.39, 0.68, -0.01), skin)
	_add_capsule("LeftLeg", 0.13, 0.7, Vector3(-0.145, 0.36, 0.015), pants)
	_add_capsule("RightLeg", 0.13, 0.7, Vector3(0.145, 0.36, 0.015), pants)
	shoe_left = _add_box_part("LeftShoe", Vector3(-0.15, 0.09, -0.07), Vector3(0.25, 0.16, 0.42), shoes)
	shoe_right = _add_box_part("RightShoe", Vector3(0.15, 0.09, -0.07), Vector3(0.25, 0.16, 0.42), shoes)

	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.235
	head_mesh.height = 0.47
	head.mesh = head_mesh
	head.position = Vector3(0, 1.78, 0)
	head.material_override = skin
	player_visual.add_child(head)

	var hair_cap := MeshInstance3D.new()
	var hair_mesh := SphereMesh.new()
	hair_mesh.radius = 0.245
	hair_mesh.height = 0.22
	hair_cap.mesh = hair_mesh
	hair_cap.scale = Vector3(1.0, 0.55, 1.0)
	hair_cap.position = Vector3(0, 1.94, 0.015)
	hair_cap.material_override = hair
	player_visual.add_child(hair_cap)

	for eye_x in [-0.075, 0.075]:
		var eye := MeshInstance3D.new()
		var eye_mesh := SphereMesh.new()
		eye_mesh.radius = 0.025
		eye_mesh.height = 0.035
		eye.mesh = eye_mesh
		eye.position = Vector3(eye_x, 1.79, -0.207)
		eye.material_override = eyes
		player_visual.add_child(eye)

	var nose := MeshInstance3D.new()
	var nose_mesh := SphereMesh.new()
	nose_mesh.radius = 0.035
	nose_mesh.height = 0.055
	nose.mesh = nose_mesh
	nose.position = Vector3(0, 1.735, -0.225)
	nose.material_override = skin
	player_visual.add_child(nose)

	fullbody_overlay = _add_capsule("TraditionalOutfitOverlay", 0.31, 1.42, Vector3(0, 1.0, -0.015), _make_material(Color(0.72, 0.12, 0.2)))
	fullbody_overlay.visible = false
	helmet_node = _add_sphere_part("Helmet", Vector3(0, 1.98, 0), Vector3(0.29, 0.22, 0.29), _make_material(Color(0.86, 0.12, 0.08)))
	helmet_node.visible = false

func _add_capsule(part_name: String, radius: float, height: float, at: Vector3, material: StandardMaterial3D) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	part.mesh = mesh
	part.position = at
	part.material_override = material
	player_visual.add_child(part)
	return part

func _add_box_part(part_name: String, at: Vector3, dimensions: Vector3, material: StandardMaterial3D) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	part.mesh = mesh
	part.position = at
	part.material_override = material
	player_visual.add_child(part)
	return part

func _add_sphere_part(part_name: String, at: Vector3, dimensions: Vector3, material: StandardMaterial3D) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 1.0
	part.mesh = mesh
	part.scale = dimensions
	part.position = at
	part.material_override = material
	player_visual.add_child(part)
	return part

func _make_material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.86
	return material

func apply_outfit(outfit: Dictionary) -> void:
	if not is_instance_valid(player_visual):
		return
	var top_item: Dictionary = GameState.get_item("clothing", str(outfit.get("top", "")))
	var bottom_item: Dictionary = GameState.get_item("clothing", str(outfit.get("bottom", "")))
	var shoes_item: Dictionary = GameState.get_item("clothing", str(outfit.get("shoes", "")))
	var fullbody_item: Dictionary = GameState.get_item("clothing", str(outfit.get("fullbody", "")))
	var headwear_item: Dictionary = GameState.get_item("clothing", str(outfit.get("headwear", "")))
	if not top_item.is_empty():
		upper_body.material_override = _make_material(top_item.get("color", Color(0.12, 0.32, 0.72)))
	if not bottom_item.is_empty():
		lower_body.material_override = _make_material(bottom_item.get("color", Color(0.12, 0.22, 0.48)))
	if not shoes_item.is_empty():
		var shoe_material := _make_material(shoes_item.get("color", Color(0.16, 0.15, 0.14)))
		shoe_left.material_override = shoe_material
		shoe_right.material_override = shoe_material
	fullbody_overlay.visible = not fullbody_item.is_empty()
	if not fullbody_item.is_empty():
		fullbody_overlay.material_override = _make_material(fullbody_item.get("color", Color(0.72, 0.12, 0.2)))
	helmet_node.visible = not headwear_item.is_empty()
	if not headwear_item.is_empty():
		helmet_node.material_override = _make_material(headwear_item.get("color", Color(0.86, 0.12, 0.08)))

func spawn_owned_vehicle(vehicle_name: String, vehicle_color: Color) -> void:
	var vehicle := Node3D.new()
	vehicle.name = "OwnedMotorbike_" + str(Time.get_ticks_msec())
	vehicle.set_script(MOTORBIKE_SCRIPT)
	vehicle.set("display_name", vehicle_name)
	vehicle.set("body_color", vehicle_color)
	vehicle.position = Vector3(global_position.x + 3.0, 0.0, global_position.z + 1.0)
	get_parent().add_child(vehicle)
	interaction_message.emit("Xe %s đã được đưa đến gần bạn. Hãy đến gần xe và nhấn TƯƠNG TÁC để lái." % vehicle_name)

func set_mobile_move(value: Vector2) -> void:
	mobile_input = value.limit_length(1.0)

func add_mobile_look(value: Vector2) -> void:
	look_delta += value

func enter_vehicle(vehicle: Node3D) -> String:
	if is_instance_valid(current_vehicle):
		return "Bạn đang sử dụng một phương tiện rồi."
	if not is_instance_valid(vehicle) or global_position.distance_to(vehicle.global_position) > 4.0:
		return "Hãy đến gần xe máy hơn."
	global_position = vehicle.global_position + Vector3(0, 1.1, 0)
	current_vehicle = vehicle
	velocity = Vector3.ZERO
	player_visual.visible = false
	camera_pivot.position.y = 1.4
	camera.position = Vector3(0, 2.7, 7.0)
	vehicle.call("set_rider", self)
	return "Bạn đã lên xe máy. Dùng cần điều khiển bên trái để chạy, vuốt bên phải để xoay camera. Nhấn TƯƠNG TÁC để xuống xe."

func exit_vehicle() -> String:
	if not is_instance_valid(current_vehicle):
		current_vehicle = null
		return "Bạn hiện không ở trên xe."
	var vehicle := current_vehicle
	current_vehicle = null
	vehicle.call("clear_rider")
	global_position += global_transform.basis.x * 1.15
	velocity = Vector3.ZERO
	player_visual.visible = true
	camera_pivot.position.y = 1.55
	camera.position = Vector3(0, 2.2, 5.5)
	return "Bạn đã xuống xe máy. Xe được giữ lại tại vị trí này."

func is_riding_vehicle() -> bool:
	return is_instance_valid(current_vehicle)

func interact_nearby() -> void:
	var closest: Node3D
	var closest_distance := 3.8
	for candidate in get_tree().get_nodes_in_group("interactable"):
		if not candidate is Node3D:
			continue
		var distance := global_position.distance_to(candidate.global_position)
		if distance < closest_distance:
			closest = candidate
			closest_distance = distance
	if closest:
		var message := str(closest.call("interact"))
		GameState.save_game(global_position, rotation.y)
		interaction_message.emit(message)
	else:
		interaction_message.emit("Hãy đến gần bố mẹ, cửa hàng, điểm tuyển dụng hoặc xe máy để tương tác.")

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if mobile_input.length() > 0.05:
		input = mobile_input

	if is_instance_valid(current_vehicle):
		var throttle := -input.y
		if absf(throttle) > 0.05:
			rotate_y(-input.x * 1.65 * delta)
		var bike_direction := -global_transform.basis.z * throttle
		velocity.x = move_toward(velocity.x, bike_direction.x * 12.0, 26.0 * delta)
		velocity.z = move_toward(velocity.z, bike_direction.z * 12.0, 26.0 * delta)
		if not is_on_floor():
			velocity.y -= gravity * delta
		else:
			velocity.y = 0.0
	else:
		var direction := (transform.basis * Vector3(input.x, 0, input.y)).normalized()
		velocity.x = move_toward(velocity.x, direction.x * move_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * move_speed, acceleration * delta)
		if not is_on_floor():
			velocity.y -= gravity * delta
		elif Input.is_action_just_pressed("jump"):
			velocity.y = 6.0

	move_and_slide()
	if look_delta.length() > 0.0:
		rotate_y(-look_delta.x * 0.004)
		camera_pivot.rotate_x(-look_delta.y * 0.004)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-55), deg_to_rad(35))
		look_delta = Vector2.ZERO
