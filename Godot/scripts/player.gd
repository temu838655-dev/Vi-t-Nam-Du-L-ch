extends CharacterBody3D

signal interaction_message(message: String)

@export var move_speed: float = 5.0
@export var acceleration: float = 18.0
@export var gravity: float = 22.0
var camera_pivot: Node3D
var camera: Camera3D
var player_visual: MeshInstance3D
var mobile_input := Vector2.ZERO
var look_delta := Vector2.ZERO
var current_vehicle: Node3D

func _ready() -> void:
	add_to_group("player")
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.38
	capsule.height = 1.8
	player_visual = MeshInstance3D.new()
	player_visual.mesh = capsule
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.12, 0.32, 0.75)
	player_visual.material_override = mat
	player_visual.position.y = 0.9
	add_child(player_visual)
	var collision := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.38
	shape.height = 1.8
	collision.shape = shape
	collision.position.y = 0.9
	add_child(collision)
	camera_pivot = Node3D.new()
	camera_pivot.position = Vector3(0, 1.55, 0)
	add_child(camera_pivot)
	camera = Camera3D.new()
	camera.position = Vector3(0, 2.2, 5.5)
	camera.rotation_degrees = Vector3(-13, 0, 0)
	camera.current = true
	camera_pivot.add_child(camera)

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
		interaction_message.emit("Hãy đến gần bố mẹ, điểm tuyển dụng hoặc xe máy để tương tác.")

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
