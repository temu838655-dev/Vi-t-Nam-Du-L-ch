extends Node3D

@export var display_name := "Mẹ"
@export var role := "mother"
@export var body_color := Color(0.72, 0.18, 0.22)

var current_activity := "Ở nhà"
var routine_target := Vector3.ZERO
var last_routine_phase := -1
var idle_phase := 0.0
var left_arm: MeshInstance3D
var right_arm: MeshInstance3D
var torso: MeshInstance3D

const CAREER_BY_ROLE := {
	"career_driver": "Tài xế công nghệ",
	"career_tourism": "Nhân viên du lịch",
	"career_chef": "Đầu bếp",
	"career_photographer": "Nhiếp ảnh gia"
}

func _ready() -> void:
	add_to_group("interactable")
	_build_person()
	routine_target = position
	if role == "mother" or role == "father":
		_update_family_routine(true)

func _process(delta: float) -> void:
	if role != "mother" and role != "father":
		return
	var clock := fposmod(GameState.world_time_seconds, 240.0)
	var phase := int(floor(clock / 40.0))
	if phase != last_routine_phase:
		_update_family_routine(false)
		last_routine_phase = phase
	var distance := position.distance_to(routine_target)
	if distance > 0.08:
		var direction := routine_target - position
		direction.y = 0.0
		if direction.length_squared() > 0.001:
			rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), minf(1.0, delta * 4.0))
		position = position.move_toward(routine_target, delta * 1.25)
		idle_phase += delta * 7.0
		if is_instance_valid(left_arm):
			left_arm.rotation.x = sin(idle_phase) * 0.18
		if is_instance_valid(right_arm):
			right_arm.rotation.x = -sin(idle_phase) * 0.18
	else:
		idle_phase += delta
		if is_instance_valid(left_arm):
			left_arm.rotation.x = sin(idle_phase * 1.2) * 0.035
		if is_instance_valid(right_arm):
			right_arm.rotation.x = sin(idle_phase * 1.2 + 1.0) * 0.035

func _update_family_routine(initial: bool) -> void:
	var clock := fposmod(GameState.world_time_seconds, 240.0)
	var phase := int(floor(clock / 40.0))
	var mother_positions := [
		Vector3(-2.8, 0.0, -9.7), Vector3(-1.5, 0.0, -7.5),
		Vector3(2.5, 0.0, -9.7), Vector3(1.4, 0.0, -7.4),
		Vector3(-2.7, 0.0, -9.5), Vector3(0.0, 0.0, -7.2)
	]
	var father_positions := [
		Vector3(2.8, 0.0, -9.7), Vector3(-2.8, 0.0, -9.6),
		Vector3(1.5, 0.0, -7.5), Vector3(2.7, 0.0, -9.6),
		Vector3(-1.5, 0.0, -7.5), Vector3(2.8, 0.0, -9.7)
	]
	var activities := ["Chuẩn bị bữa ăn", "Dọn dẹp nhà cửa", "Nghỉ ngơi", "Xem TV", "Dùng bữa cùng gia đình", "Trò chuyện với gia đình"]
	var positions: Array = mother_positions if role == "mother" else father_positions
	var activity_index := posmod(phase + (0 if role == "mother" else 2), activities.size())
	current_activity = activities[activity_index]
	routine_target = positions[phase]
	if initial:
		position = routine_target

func _build_person() -> void:
	var skin_color := Color(0.72, 0.49, 0.36)
	var hair_color := Color(0.055, 0.045, 0.04)
	var skin := _material(skin_color)
	var hair := _material(hair_color)
	var clothes := _material(body_color)
	var trousers_color := Color(0.12, 0.16, 0.2)
	if role == "mother":
		trousers_color = Color(0.22, 0.18, 0.18)
	elif role == "father":
		trousers_color = Color(0.1, 0.14, 0.2)
	var trousers := _material(trousers_color)
	var shoes := _material(Color(0.12, 0.1, 0.09))
	var eyes := _material(Color(0.025, 0.02, 0.02))

	torso = _add_capsule("Torso", 0.27, 0.84, Vector3(0, 1.1, 0), clothes)
	left_arm = _add_capsule("LeftArm", 0.105, 0.74, Vector3(-0.36, 1.1, 0), clothes)
	left_arm.rotation.z = deg_to_rad(-8)
	right_arm = _add_capsule("RightArm", 0.105, 0.74, Vector3(0.36, 1.1, 0), clothes)
	right_arm.rotation.z = deg_to_rad(8)
	_add_capsule("LeftHand", 0.085, 0.18, Vector3(-0.37, 0.68, -0.01), skin)
	_add_capsule("RightHand", 0.085, 0.18, Vector3(0.37, 0.68, -0.01), skin)
	_add_capsule("HipsAndTrousers", 0.2, 0.4, Vector3(0, 0.62, 0), trousers)
	_add_capsule("LeftLeg", 0.125, 0.62, Vector3(-0.14, 0.32, 0.01), trousers)
	_add_capsule("RightLeg", 0.125, 0.62, Vector3(0.14, 0.32, 0.01), trousers)
	_add_box("LeftShoe", Vector3(-0.14, 0.08, -0.06), Vector3(0.24, 0.14, 0.38), shoes)
	_add_box("RightShoe", Vector3(0.14, 0.08, -0.06), Vector3(0.24, 0.14, 0.38), shoes)

	var head := MeshInstance3D.new()
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.225
	head_mesh.height = 0.45
	head.mesh = head_mesh
	head.position = Vector3(0, 1.76, 0)
	head.material_override = skin
	add_child(head)

	var hair_cap := MeshInstance3D.new()
	var hair_mesh := SphereMesh.new()
	hair_mesh.radius = 0.24
	hair_mesh.height = 0.22
	hair_cap.mesh = hair_mesh
	hair_cap.scale = Vector3(1.0, 0.55, 1.0)
	hair_cap.position = Vector3(0, 1.92, 0.015)
	hair_cap.material_override = hair
	add_child(hair_cap)
	if role == "mother":
		_add_sphere("HairBack", Vector3(0, 1.72, 0.13), Vector3(0.34, 0.42, 0.22), hair)
		_add_sphere("HairBun", Vector3(0, 1.91, 0.22), Vector3(0.15, 0.16, 0.15), hair)

	for eye_x in [-0.07, 0.07]:
		_add_sphere("Eye", Vector3(eye_x, 1.77, -0.2), Vector3(0.045, 0.05, 0.025), eyes)
	_add_sphere("Nose", Vector3(0, 1.72, -0.22), Vector3(0.055, 0.065, 0.06), skin)

	var label := Label3D.new()
	label.text = display_name
	label.position = Vector3(0, 2.18, 0)
	label.font_size = 26
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func _material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.88
	return material

func _add_capsule(part_name: String, radius: float, height: float, at: Vector3, material: StandardMaterial3D) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	part.mesh = mesh
	part.position = at
	part.material_override = material
	add_child(part)
	return part

func _add_box(part_name: String, at: Vector3, dimensions: Vector3, material: StandardMaterial3D) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	part.mesh = mesh
	part.position = at
	part.material_override = material
	add_child(part)
	return part

func _add_sphere(part_name: String, at: Vector3, dimensions: Vector3, material: StandardMaterial3D) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	part.name = part_name
	var mesh := SphereMesh.new()
	mesh.radius = 0.5
	mesh.height = 1.0
	part.mesh = mesh
	part.scale = dimensions
	part.position = at
	part.material_override = material
	add_child(part)
	return part

func interact() -> String:
	match role:
		"mother":
			if not GameState.register_family_interaction("mother", "fallback_talk"):
				return "Mẹ: Hôm nay mẹ con mình đã trò chuyện rồi. Con cứ tự nhiên khám phá nhé!"
			GameState.family_affection = mini(100, GameState.family_affection + 2)
			return "Mẹ (%s): %s" % [current_activity, _family_reply("Mẹ")]
		"father":
			if not GameState.register_family_interaction("father", "fallback_talk"):
				return "Bố: Hôm nay bố con mình đã trò chuyện rồi. Khi nào rảnh ta nói tiếp nhé!"
			GameState.family_affection = mini(100, GameState.family_affection + 2)
			return "Bố (%s): %s" % [current_activity, _family_reply("Bố")]
		"job_board":
			return "Hãy đến từng quầy tuyển dụng để chọn nghề bạn muốn làm."
		_:
			if CAREER_BY_ROLE.has(role):
				var career: String = CAREER_BY_ROLE[role]
				if GameState.selected_career != career:
					GameState.selected_career = career
					return "Bạn đã chọn nghề %s. Tương tác lần nữa tại quầy này để nhận ca làm." % career
				return GameState.complete_work_shift()
	return "Không có gì để tương tác."

func _family_reply(member: String) -> String:
	match current_activity:
		"Chuẩn bị bữa ăn":
			return "Mẹ đang chuẩn bị món ngon. Lát nữa cả nhà cùng ăn nhé!" if member == "Mẹ" else "Bố phụ mẹ chuẩn bị bữa tối, con có muốn giúp không?"
		"Dọn dẹp nhà cửa":
			return "Nhà cửa gọn gàng thì ai cũng thấy dễ chịu hơn." if member == "Mẹ" else "Bố đang sửa sang vài thứ trong nhà."
		"Nghỉ ngơi":
			return "Mẹ nghỉ một lát, con cứ tự nhiên nhé." if member == "Mẹ" else "Bố đang thư giãn một chút."
		"Xem TV":
			return "Có chương trình hay đấy, con ngồi xem cùng mẹ nhé." if member == "Mẹ" else "Con xem tin tức cùng bố một lát không?"
		"Dùng bữa cùng gia đình":
			return "Cả nhà ăn cơm thôi con!" if member == "Mẹ" else "Bữa cơm gia đình là lúc vui nhất."
		_:
			return "Đi đâu nhớ báo cho bố mẹ biết và giữ gìn sức khỏe nhé."
