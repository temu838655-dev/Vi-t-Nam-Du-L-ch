extends CharacterBody3D

signal interaction_message(message: String)

@export var move_speed: float = 5.0
@export var acceleration: float = 18.0
@export var gravity: float = 22.0
var camera_pivot: Node3D
var camera: Camera3D
var mobile_input := Vector2.ZERO
var look_delta := Vector2.ZERO

func _ready() -> void:
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.38
	capsule.height = 1.8
	var visual := MeshInstance3D.new()
	visual.mesh = capsule
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.12, 0.32, 0.75)
	visual.material_override = mat
	visual.position.y = 0.9
	add_child(visual)
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
		interaction_message.emit(message)
	else:
		interaction_message.emit("Hãy đến gần bố mẹ hoặc bảng việc làm để tương tác.")

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if mobile_input.length() > 0.05:
		input = mobile_input
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
