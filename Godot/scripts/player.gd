extends CharacterBody3D

signal interaction_message(message: String)

const MOTORBIKE_SCRIPT := preload("res://scripts/motorbike.gd")
const HERO_MODEL_PATH := "res://assets/characters/player/player_hero.glb"

@export var move_speed: float = 5.0
@export var acceleration: float = 18.0
@export var gravity: float = 22.0
var camera_pivot: Node3D
var camera: Camera3D
var camera_arm: SpringArm3D
var player_visual: Node3D
var using_production_model := false
var production_animation_player: AnimationPlayer
var upper_body: MeshInstance3D
var lower_body: MeshInstance3D
var shoe_left: MeshInstance3D
var shoe_right: MeshInstance3D
var left_arm: MeshInstance3D
var right_arm: MeshInstance3D
var left_leg: MeshInstance3D
var right_leg: MeshInstance3D
var walk_phase := 0.0
var fullbody_overlay: MeshInstance3D
var helmet_node: MeshInstance3D
var mobile_input := Vector2.ZERO
var mobile_sprint := false
var camera_sensitivity := 1.0
var look_delta := Vector2.ZERO
var current_vehicle: Node3D
var home_action_remaining := 0.0
var home_action_pose := ""
var home_action_blend := 0.0
var talk_expression_remaining := 0.0
var facial_meshes: Array[MeshInstance3D] = []

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
	camera_arm = SpringArm3D.new()
	camera_arm.name = "CameraCollisionArm"
	camera_arm.spring_length = 5.5
	camera_arm.margin = 0.18
	camera_arm.collision_mask = 1
	camera_arm.add_excluded_object(get_rid())
	camera_pivot.add_child(camera_arm)
	camera = Camera3D.new()
	camera.position = Vector3.ZERO
	camera.rotation_degrees = Vector3(-13, 0, 0)
	camera.current = true
	camera_arm.add_child(camera)
	apply_outfit(GameState.equipped_clothes)

func _build_character_model() -> void:
	# Prefer a real, reviewed GLB when one is supplied. Keep the prototype fallback
	# until the binary asset exists; never disguise the fallback as production art.
	if ResourceLoader.exists(HERO_MODEL_PATH):
		var packed_model := load(HERO_MODEL_PATH) as PackedScene
		if packed_model != null:
			var imported_model := packed_model.instantiate()
			if imported_model is Node3D:
				var validation := _validate_production_hero(imported_model)
				if bool(validation.get("valid", false)):
					player_visual = imported_model as Node3D
					player_visual.name = "CharacterVisual"
					add_child(player_visual)
					using_production_model = true
					production_animation_player = _find_animation_player(player_visual)
					_play_production_animation("idle")
					return
				push_warning("Hero GLB rejected by runtime quality gate: " + str(validation.get("errors", [])))
				imported_model.queue_free()
	push_warning("Production hero GLB missing or failed quality gate; using clearly marked prototype character.")
	_build_procedural_character_model()

func _find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node as AnimationPlayer
	for child in node.get_children():
		var found := _find_animation_player(child)
		if found != null:
			return found
	return null

func _validate_production_hero(root: Node) -> Dictionary:
	# A file existing on disk is not enough: reject generic/static meshes that
	# cannot meet the project's articulated, facially-detailed character target.
	var report := {
		"valid": false,
		"errors": [],
		"has_skeleton": false,
		"has_animation": false,
		"has_facial_deformation": false,
		"face_parts": {"eye": 0, "brow": 0, "nose": 0, "mouth": 0, "teeth": 0, "ear": 0}
	}
	_inspect_hero_nodes(root, report)
	var errors: Array[String] = []
	if not report["has_skeleton"]:
		errors.append("missing humanoid Skeleton3D")
	if not report["has_animation"]:
		errors.append("missing imported AnimationPlayer clips")
	if not report["has_facial_deformation"]:
		errors.append("missing facial blend shapes or facial bones")
	var parts: Dictionary = report["face_parts"]
	for part in ["eye", "brow", "nose", "mouth", "teeth", "ear"]:
		var minimum := 2 if part == "eye" or part == "ear" else 1
		if int(parts.get(part, 0)) < minimum:
			errors.append("insufficient visible face geometry: " + part)
	report["errors"] = errors
	report["valid"] = errors.is_empty()
	return report


func _inspect_hero_nodes(node: Node, report: Dictionary) -> void:
	var normalized := node.name.to_lower().replace("_", "").replace("-", "").replace(" ", "")
	if node is Skeleton3D:
		report["has_skeleton"] = true
		var skeleton := node as Skeleton3D
		for bone_index in range(skeleton.get_bone_count()):
			var bone_name := skeleton.get_bone_name(bone_index).to_lower()
			if "jaw" in bone_name or "lip" in bone_name or "brow" in bone_name or "eyelid" in bone_name or "face" in bone_name:
				report["has_facial_deformation"] = true
	if node is AnimationPlayer:
		if not (node as AnimationPlayer).get_animation_list().is_empty():
			report["has_animation"] = true
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh is ArrayMesh:
			if (mesh_instance.mesh as ArrayMesh).get_blend_shape_count() > 0:
				report["has_facial_deformation"] = true
		var parts: Dictionary = report["face_parts"]
		if "eye" in normalized or "eyeball" in normalized or "iris" in normalized or "pupil" in normalized:
			parts["eye"] = int(parts["eye"]) + (2 if "eyes" in normalized else 1)
		if "brow" in normalized:
			parts["brow"] = int(parts["brow"]) + 1
		if "nose" in normalized:
			parts["nose"] = int(parts["nose"]) + 1
		if "mouth" in normalized or "lip" in normalized:
			parts["mouth"] = int(parts["mouth"]) + 1
		if "teeth" in normalized or "tooth" in normalized:
			parts["teeth"] = int(parts["teeth"]) + 1
		if "ear" in normalized:
			parts["ear"] = int(parts["ear"]) + 1
		report["face_parts"] = parts
	for child in node.get_children():
		_inspect_hero_nodes(child, report)


func _normalize_animation_name(value: String) -> String:
	var normalized := value.to_lower()
	for separator in [" ", "_", "-", "|", ":", ".", "/", "\\"]:
		normalized = normalized.replace(separator, "")
	return normalized

func _animation_aliases(state_name: String) -> Array[String]:
	match state_name.to_lower():
		"idle":
			return ["idle", "breathingidle", "standingidle", "stand", "standing", "rest"]
		"walk":
			return ["walk", "walking", "walkforward", "locomotionwalk"]
		"run":
			return ["run", "running", "sprint", "jog", "fastwalk"]
		_:
			return [state_name.to_lower()]

func _play_production_animation(state_name: String) -> void:
	if not is_instance_valid(production_animation_player):
		return
	var animations: Array = production_animation_player.get_animation_list()
	var aliases := _animation_aliases(state_name)
	var selected: StringName = &""
	var best_score := -1
	for animation_name in animations:
		var normalized := _normalize_animation_name(str(animation_name))
		for alias_name in aliases:
			var score := -1
			if normalized == alias_name:
				score = 100
			elif normalized.ends_with(alias_name):
				score = 80
			elif normalized.contains(alias_name):
				score = 60
			if score > best_score:
				best_score = score
				selected = animation_name
	if selected == &"" and state_name.to_lower() == "run":
		_play_production_animation("walk")
		return
	if selected == &"":
		return
	if production_animation_player.current_animation != selected:
		production_animation_player.play(selected)

func _build_procedural_character_model() -> void:
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
	left_arm = _add_capsule("LeftArm", 0.105, 0.78, Vector3(-0.36, 1.12, 0), shirt)
	left_arm.rotation.z = deg_to_rad(-9)
	right_arm = _add_capsule("RightArm", 0.105, 0.78, Vector3(0.36, 1.12, 0), shirt)
	right_arm.rotation.z = deg_to_rad(9)
	_add_capsule("LeftHand", 0.09, 0.2, Vector3(-0.39, 0.68, -0.01), skin)
	_add_capsule("RightHand", 0.09, 0.2, Vector3(0.39, 0.68, -0.01), skin)
	left_leg = _add_capsule("LeftLeg", 0.13, 0.7, Vector3(-0.145, 0.36, 0.015), pants)
	right_leg = _add_capsule("RightLeg", 0.13, 0.7, Vector3(0.145, 0.36, 0.015), pants)
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
	if is_instance_valid(upper_body) and not top_item.is_empty():
		upper_body.material_override = _make_material(top_item.get("color", Color(0.12, 0.32, 0.72)))
	if is_instance_valid(lower_body) and not bottom_item.is_empty():
		lower_body.material_override = _make_material(bottom_item.get("color", Color(0.12, 0.22, 0.48)))
	if is_instance_valid(shoe_left) and is_instance_valid(shoe_right) and not shoes_item.is_empty():
		var shoe_material := _make_material(shoes_item.get("color", Color(0.16, 0.15, 0.14)))
		shoe_left.material_override = shoe_material
		shoe_right.material_override = shoe_material
	if is_instance_valid(fullbody_overlay):
		fullbody_overlay.visible = not fullbody_item.is_empty()
		if not fullbody_item.is_empty():
			fullbody_overlay.material_override = _make_material(fullbody_item.get("color", Color(0.72, 0.12, 0.2)))
	if is_instance_valid(helmet_node):
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

func begin_home_action(action: String) -> void:
	if is_instance_valid(current_vehicle):
		return
	home_action_pose = action
	home_action_remaining = 8.0 if action == "sofa" or action == "tv" or action == "bench" or action == "cafe" else 5.0
	velocity = Vector3.ZERO
	mobile_input = Vector2.ZERO
	if action == "meal" or action == "cafe":
		player_visual.rotation.y = PI
	elif action == "tv":
		player_visual.rotation.y = PI * 0.5

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
	if is_instance_valid(camera_arm):
		camera_arm.spring_length = 7.0
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
	if is_instance_valid(camera_arm):
		camera_arm.spring_length = 5.5
	return "Bạn đã xuống xe máy. Xe được giữ lại tại vị trí này."

func is_riding_vehicle() -> bool:
	return is_instance_valid(current_vehicle)

func get_nearby_interactable_name() -> String:
	var closest: Node3D
	var closest_distance := 3.8
	for candidate in get_tree().get_nodes_in_group("interactable"):
		if not candidate is Node3D:
			continue
		var distance := global_position.distance_to(candidate.global_position)
		if distance < closest_distance:
			closest = candidate
			closest_distance = distance
	if not is_instance_valid(closest):
		return ""
	var label := str(closest.get("display_name"))
	if label.is_empty() or label == "<null>":
		label = str(closest.name)
	return label

func interact_nearby() -> void:
	if home_action_remaining > 0.0:
		interaction_message.emit("Bạn đang nghỉ ngơi. Chờ một chút để tiếp tục di chuyển.")
		return
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
		play_talk_expression(2.4)
		var target_role := str(closest.get("role"))
		if target_role == "mother" or target_role == "father":
			GameState.advance_tutorial("talk_family")
			var hud := get_tree().get_first_node_in_group("shop_ui")
			if is_instance_valid(hud) and hud.has_method("open_family_dialogue"):
				hud.call("open_family_dialogue", target_role, str(closest.get("current_activity")))
				GameState.save_game(global_position, rotation.y)
				return
		var message := str(closest.call("interact"))
		if target_role.begins_with("career_"):
			GameState.advance_tutorial("choose_career")
		GameState.save_game(global_position, rotation.y)
		interaction_message.emit(message)
	else:
		interaction_message.emit("Hãy đến gần bố mẹ, cửa hàng, điểm tuyển dụng hoặc xe máy để tương tác.")

func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if mobile_input.length() > 0.05:
		input = mobile_input
	if home_action_remaining > 0.0:
		input = Vector2.ZERO

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
		var effective_speed := move_speed * (1.55 if mobile_sprint else 1.0)
		velocity.x = move_toward(velocity.x, direction.x * effective_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * effective_speed, acceleration * delta)
		if not is_on_floor():
			velocity.y -= gravity * delta
		elif Input.is_action_just_pressed("jump"):
			velocity.y = 6.0

	move_and_slide()
	_animate_character(delta)
	_update_facial_expression(delta)
	if home_action_remaining > 0.0:
		home_action_remaining = maxf(0.0, home_action_remaining - delta)
	elif home_action_pose != "":
		home_action_pose = ""
	var target_pose_blend := 1.0 if home_action_remaining > 0.0 else 0.0
	home_action_blend = move_toward(home_action_blend, target_pose_blend, delta * 3.5)
	if home_action_blend > 0.001 and not using_production_model:
		player_visual.position.y = lerpf(player_visual.position.y, -0.24, home_action_blend)
		left_leg.rotation.x = lerpf(left_leg.rotation.x, -0.62, home_action_blend)
		right_leg.rotation.x = lerpf(right_leg.rotation.x, -0.62, home_action_blend)
		left_arm.rotation.x = lerpf(left_arm.rotation.x, -0.18, home_action_blend)
		right_arm.rotation.x = lerpf(right_arm.rotation.x, -0.18, home_action_blend)
	if look_delta.length() > 0.0:
		rotate_y(-look_delta.x * 0.004 * camera_sensitivity)
		camera_pivot.rotate_x(-look_delta.y * 0.004 * camera_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-55), deg_to_rad(35))
		look_delta = Vector2.ZERO


func _animate_character(delta: float) -> void:
	if not is_instance_valid(player_visual) or not player_visual.visible:
		return
	var horizontal_speed := Vector2(velocity.x, velocity.z).length()
	var moving := horizontal_speed > 0.18 and not is_instance_valid(current_vehicle)
	if using_production_model:
		var animation_state := "idle"
		if moving:
			animation_state = "run" if mobile_sprint else "walk"
		_play_production_animation(animation_state)
		return
	if moving:
		walk_phase += delta * clampf(horizontal_speed * 2.6, 5.0, 13.0)
		var swing := sin(walk_phase) * 0.48
		left_leg.rotation.x = swing
		right_leg.rotation.x = -swing
		left_arm.rotation.x = -swing * 0.62
		right_arm.rotation.x = swing * 0.62
		player_visual.position.y = absf(sin(walk_phase * 2.0)) * 0.035
		var local_direction := global_transform.basis.inverse() * Vector3(velocity.x, 0.0, velocity.z).normalized()
		var target_yaw := atan2(-local_direction.x, -local_direction.z)
		player_visual.rotation.y = lerp_angle(player_visual.rotation.y, target_yaw, minf(1.0, delta * 9.0))
	else:
		left_leg.rotation.x = move_toward(left_leg.rotation.x, 0.0, delta * 4.0)
		right_leg.rotation.x = move_toward(right_leg.rotation.x, 0.0, delta * 4.0)

		left_arm.rotation.x = move_toward(left_arm.rotation.x, 0.0, delta * 4.0)
		right_arm.rotation.x = move_toward(right_arm.rotation.x, 0.0, delta * 4.0)
		player_visual.position.y = move_toward(player_visual.position.y, 0.0, delta * 0.12)

func play_talk_expression(duration: float = 2.0) -> void:
	# Triggers the exported facial blend shapes when the production GLB provides them.
	talk_expression_remaining = maxf(talk_expression_remaining, duration)


func _update_facial_expression(delta: float) -> void:
	if not using_production_model or not is_instance_valid(player_visual):
		return
	if facial_meshes.is_empty():
		_collect_facial_meshes(player_visual)
	talk_expression_remaining = maxf(0.0, talk_expression_remaining - delta)
	var clock := float(Time.get_ticks_msec()) * 0.001
	# A short periodic eyelid closure gives the character a natural idle blink.
	var blink_phase := fposmod(clock, 3.7)
	var blink := 0.0
	if blink_phase > 3.48 and blink_phase < 3.62:
		blink = sin((blink_phase - 3.48) / 0.14 * PI)
	var talking := 1.0 if talk_expression_remaining > 0.0 else 0.0
	for mesh_instance in facial_meshes:
		if not is_instance_valid(mesh_instance) or mesh_instance.mesh == null:
			continue
		for shape_index in range(mesh_instance.mesh.get_blend_shape_count()):
			var shape_name := _normalize_animation_name(str(mesh_instance.mesh.get_blend_shape_name(shape_index)))
			var target := 0.0
			if shape_name.contains("blinkleft") or shape_name.contains("blinkright") or shape_name == "blink":
				target = blink
			elif shape_name.contains("jawopen"):
				target = talking * 0.22
			elif shape_name.contains("smile"):
				target = talking * 0.12
			mesh_instance.set_blend_shape_value(shape_index, target)


func _collect_facial_meshes(node: Node) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh != null and mesh_instance.mesh.get_blend_shape_count() > 0:
			facial_meshes.append(mesh_instance)
	for child in node.get_children():
		_collect_facial_meshes(child)

func set_mobile_sprint(enabled: bool) -> void:
	mobile_sprint = enabled

func set_camera_sensitivity(value: float) -> void:
	camera_sensitivity = clampf(value, 0.5, 2.0)
