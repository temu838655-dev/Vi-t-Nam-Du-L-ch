extends Node3D

@export var display_name := "Mẹ"
@export var role := "mother"
@export var body_color := Color(0.72, 0.18, 0.22)

const CAREER_BY_ROLE := {
	"career_driver": "Tài xế công nghệ",
	"career_tourism": "Nhân viên du lịch",
	"career_chef": "Đầu bếp",
	"career_photographer": "Nhiếp ảnh gia"
}

func _ready() -> void:
	add_to_group("interactable")
	_build_person()

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

	_add_capsule("Torso", 0.27, 0.84, Vector3(0, 1.1, 0), clothes)
	_add_capsule("LeftArm", 0.105, 0.74, Vector3(-0.36, 1.1, 0), clothes).rotation.z = deg_to_rad(-8)
	_add_capsule("RightArm", 0.105, 0.74, Vector3(0.36, 1.1, 0), clothes).rotation.z = deg_to_rad(8)
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
			return GameState.talk_with_family("Mẹ")
		"father":
			return GameState.talk_with_family("Bố")
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
