extends Node3D

const MALE_RESIDENT_MODEL_PATH := "res://assets/characters/player/player_hero.glb"
const FEMALE_RESIDENT_MODEL_PATH := "res://assets/characters/npc/vietnamese_woman.glb"

# Mobile-friendly daily routine for a small number of sidewalk residents.
# Residents share the same accelerated world clock as the player.
@export var resident_name := "Cư dân"
@export var home_position := Vector3(-5.15, 0.0, -18.0)
@export var work_position := Vector3(-5.15, 0.0, 5.0)
@export var shop_position := Vector3(-5.15, 0.0, 23.0)
@export var shirt_color := Color(0.2, 0.42, 0.68)
@export var schedule_offset := 0.0

var left_leg: MeshInstance3D
var right_leg: MeshInstance3D
var status_label: Label3D
var walk_phase := 0.0
var previous_position := Vector3.ZERO
var conversation_count := 0
var current_activity := "Ở nhà"
var production_visual: Node3D
var production_animation_player: AnimationPlayer
var using_production_visual := false
var talk_time_remaining := 0.0
var facial_clock := 0.0
var facial_meshes: Array[MeshInstance3D] = []

func _ready() -> void:
	add_to_group("interactable")
	_build_resident()
	position = home_position
	previous_position = position
	_update_schedule(0.0)

func _process(delta: float) -> void:
	talk_time_remaining = maxf(0.0, talk_time_remaining - delta)
	_update_facial_animation(delta)
	_update_schedule(delta)

func _update_schedule(delta: float) -> void:
	var clock := fposmod(GameState.world_time_seconds + schedule_offset, 240.0)
	var target := home_position
	var state := "Ở nhà"
	var walking := false

	if clock >= 35.0 and clock < 65.0:
		target = home_position.lerp(work_position, (clock - 35.0) / 30.0)
		state = "Đang đi làm"
		walking = true
	elif clock >= 65.0 and clock < 130.0:
		target = work_position
		state = "Đang làm việc"
	elif clock >= 130.0 and clock < 150.0:
		target = work_position.lerp(shop_position, (clock - 130.0) / 20.0)
		state = "Đang đi mua đồ"
		walking = true
	elif clock >= 150.0 and clock < 175.0:
		target = shop_position
		state = "Đang ở cửa hàng"
	elif clock >= 175.0 and clock < 205.0:
		target = shop_position.lerp(home_position, (clock - 175.0) / 30.0)
		state = "Đang về nhà"
		walking = true

	previous_position = position
	position = target
	if walking and delta > 0.0:
		walk_phase += delta * 8.0
		var swing := sin(walk_phase) * 0.42
		var movement := position - previous_position
		if movement.length_squared() > 0.0001:
			rotation.y = atan2(movement.x, movement.z)
		if using_production_visual:
			if talk_time_remaining <= 0.0:
				_play_resident_animation("walk")
		else:
			left_leg.rotation.x = swing
			right_leg.rotation.x = -swing
	else:
		if using_production_visual:
			if talk_time_remaining <= 0.0:
				_play_resident_animation("idle")
		else:
			left_leg.rotation.x = 0.0
			right_leg.rotation.x = 0.0
	current_activity = state
	status_label.text = "%s\n%s" % [resident_name, state]


func interact() -> String:
	talk_time_remaining = 2.6
	_play_resident_animation("talk")
	conversation_count += 1
	var replies: Array[String] = []
	match current_activity:
		"Ở nhà":
			replies = ["Tôi đang nghỉ ở nhà. Hôm nay bạn định đi đâu?", "Ở nhà một chút cho khỏe, ngoài đường hôm nay khá đông đấy."]
		"Đang đi làm":
			replies = ["Tôi đang trên đường đi làm, hẹn gặp lại nhé!", "Sắp muộn giờ rồi, chúc bạn một ngày vui."]
		"Đang làm việc":
			replies = ["Công việc hôm nay cũng bận rộn, còn bạn làm nghề gì?", "Làm việc chăm chỉ mới có tiền đi du lịch chứ!"]
		"Đang đi mua đồ":
			replies = ["Tôi ghé cửa hàng mua ít đồ dùng.", "Bạn có biết quán ăn ngon nào gần đây không?"]
		"Đang ở cửa hàng":
			replies = ["Tôi đang chọn vài món đồ cần thiết.", "Đi mua sắm nhớ xem giá trước nhé!"]
		"Đang về nhà":
			replies = ["Tôi đang về nhà sau một ngày dài.", "Chúc bạn đi đường cẩn thận nhé!"]
	var index := (conversation_count - 1) % replies.size()
	return "%s: %s" % [resident_name, replies[index]]

func _build_resident() -> void:
	if _try_build_production_resident():
		_add_status_label()
		return
	push_warning("Resident production GLB missing or failed quality gate; using prototype: " + resident_name)
	var skin := _material(Color(0.69, 0.49, 0.36))
	var hair := _material(Color(0.045, 0.035, 0.03))
	var shirt := _material(shirt_color)
	var trousers := _material(Color(0.12, 0.15, 0.19))
	_add_capsule("Torso", 0.25, 0.72, Vector3(0, 1.02, 0), shirt)
	_add_capsule("Head", 0.19, 0.38, Vector3(0, 1.62, 0), skin)
	_add_sphere("Hair", Vector3(0, 1.77, 0.015), Vector3(0.2, 0.11, 0.2), hair)
	left_leg = _add_capsule("LeftLeg", 0.095, 0.55, Vector3(-0.12, 0.38, 0), trousers)
	right_leg = _add_capsule("RightLeg", 0.095, 0.55, Vector3(0.12, 0.38, 0), trousers)
	_add_status_label()


func _try_build_production_resident() -> bool:
	# Deterministically mix the authored male and female resident meshes.
	# The current library has one base model per presentation; this is not yet age/body diversity.
	var use_female_model := posmod(resident_name.hash(), 3) == 0
	var model_path := FEMALE_RESIDENT_MODEL_PATH if use_female_model else MALE_RESIDENT_MODEL_PATH
	if not ResourceLoader.exists(model_path):
		return false
	var packed := load(model_path) as PackedScene
	if packed == null:
		return false
	var instance := packed.instantiate()
	if not instance is Node3D:
		instance.queue_free()
		return false
	var report := {"skeleton": false, "animation": false, "eyes": 0, "nose": false, "mouth": false, "brows": false, "ears": 0, "teeth": 0, "blend_shapes": 0}
	_inspect_resident_model(instance, report)
	if not report.skeleton or not report.animation or int(report.eyes) < 2 or not report.nose or not report.mouth or not report.brows or int(report.ears) < 2 or int(report.teeth) < 1 or int(report.blend_shapes) < 5:
		instance.queue_free()
		return false
	production_visual = instance as Node3D
	production_visual.name = "ProductionResidentVisual"
	add_child(production_visual)
	production_animation_player = _find_resident_animation_player(production_visual)
	_collect_facial_meshes(production_visual)
	_apply_resident_visual_variant()
	using_production_visual = true
	_play_resident_animation("idle")
	return true


func _inspect_resident_model(node: Node, report: Dictionary) -> void:
	var node_name := node.name.to_lower().replace("_", "").replace("-", "").replace(" ", "")
	if node is Skeleton3D:
		report.skeleton = true
	if node is AnimationPlayer and not (node as AnimationPlayer).get_animation_list().is_empty():
		report.animation = true
	if node is MeshInstance3D:
		if "eye" in node_name or "iris" in node_name or "pupil" in node_name:
			report.eyes = int(report.eyes) + 1
		if "nose" in node_name:
			report.nose = true
		if "mouth" in node_name or "lip" in node_name:
			report.mouth = true
		if "brow" in node_name:
			report.brows = true
		if "ear" in node_name:
			report.ears = int(report.ears) + 1
		if "teeth" in node_name:
			report.teeth = int(report.teeth) + 1
		if node.mesh is ArrayMesh:
			report.blend_shapes = int(report.blend_shapes) + (node.mesh as ArrayMesh).get_blend_shape_count()
	for child in node.get_children():
		_inspect_resident_model(child, report)


func _collect_facial_meshes(node: Node) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh is ArrayMesh and (mesh_instance.mesh as ArrayMesh).get_blend_shape_count() > 0:
			facial_meshes.append(mesh_instance)
	for child in node.get_children():
		_collect_facial_meshes(child)


func _set_facial_shape(shape_name: String, value: float) -> void:
	for mesh_instance in facial_meshes:
		var mesh := mesh_instance.mesh as ArrayMesh
		for index in range(mesh.get_blend_shape_count()):
			var current_name := mesh.get_blend_shape_name(index).to_lower().replace("_", "").replace("-", "").replace(" ", "")
			if current_name == shape_name.to_lower().replace("_", "").replace("-", "").replace(" ", ""):
				mesh_instance.set_blend_shape_value(index, clampf(value, 0.0, 1.0))


func _update_facial_animation(delta: float) -> void:
	if not using_production_visual or facial_meshes.is_empty():
		return
	facial_clock += delta
	var talking := talk_time_remaining > 0.0
	var blink_phase := fposmod(facial_clock, 3.8)
	var blink := 1.0 if blink_phase > 3.62 else 0.0
	_set_facial_shape("Blink_Left", blink)
	_set_facial_shape("Blink_Right", blink)
	_set_facial_shape("Jaw_Open", (0.22 + 0.55 * absf(sin(facial_clock * 13.0))) if talking else 0.0)
	_set_facial_shape("Smile", 0.16 if talking else 0.0)
	_set_facial_shape("Brow_Raise", (0.12 + 0.08 * sin(facial_clock * 4.0)) if talking else 0.0)


func _find_resident_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node as AnimationPlayer
	for child in node.get_children():
		var found := _find_resident_animation_player(child)
		if found != null:
			return found
	return null


func _play_resident_animation(state: String) -> void:
	if not is_instance_valid(production_animation_player):
		return
	var aliases := [state, "walking" if state == "walk" else "standingidle"]
	for animation_name in production_animation_player.get_animation_list():
		var normalized := animation_name.to_lower().replace("_", "").replace("-", "").replace(" ", "")
		for alias in aliases:
			if normalized == str(alias).to_lower().replace("_", "").replace("-", "").replace(" ", ""):
				if production_animation_player.current_animation != animation_name:
					production_animation_player.play(animation_name)
				return


func _add_status_label() -> void:
	status_label = Label3D.new()
	status_label.position = Vector3(0, 2.05, 0)
	status_label.font_size = 18
	status_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(status_label)


func _material(tint: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.9
	return material

func _add_capsule(part_name: String, radius: float, height: float, at: Vector3, material: StandardMaterial3D) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = part_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	mesh_instance.mesh = mesh
	mesh_instance.position = at
	mesh_instance.material_override = material
	add_child(mesh_instance)
	return mesh_instance

func _add_sphere(part_name: String, at: Vector3, dimensions: Vector3, material: StandardMaterial3D) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = part_name
	var mesh := SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 1.0
	mesh_instance.mesh = mesh
	mesh_instance.scale = dimensions
	mesh_instance.position = at
	mesh_instance.material_override = material
	add_child(mesh_instance)



func _apply_resident_visual_variant() -> void:
	# Deterministic per-NPC variation: clothing tint and subtle stature differences.
	# This is not a substitute for separate female/elderly/child character meshes.
	var variant_index := posmod(resident_name.hash(), 7)
	var hue := fposmod(0.54 + float(variant_index) * 0.115, 1.0)
	var clothing_tint := Color.from_hsv(hue, 0.42, 0.82)
	var stature := 0.96 + float(posmod(variant_index * 3, 7)) * 0.012
	production_visual.scale = Vector3.ONE * stature
	_apply_clothing_tint(production_visual, clothing_tint)


func _apply_clothing_tint(node: Node, tint: Color) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		var node_name := mesh_instance.name.to_lower()
		if "shirt" in node_name or "blouse" in node_name or "torso" in node_name or "polo" in node_name or "chest" in node_name:
			if mesh_instance.mesh != null:
				for surface_index in range(mesh_instance.mesh.get_surface_count()):
					var source_material := mesh_instance.get_active_material(surface_index)
					if source_material is StandardMaterial3D:
						var material := (source_material as StandardMaterial3D).duplicate() as StandardMaterial3D
						material.albedo_color = material.albedo_color * tint
						mesh_instance.set_surface_override_material(surface_index, material)
	for child in node.get_children():
		_apply_clothing_tint(child, tint)
