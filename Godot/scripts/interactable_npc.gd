extends Node3D

@export var display_name := "Mẹ"
@export var role := "mother"
@export var body_color := Color(0.72, 0.18, 0.22)

func _ready() -> void:
	add_to_group("interactable")
	var body_mesh := CapsuleMesh.new()
	body_mesh.radius = 0.34
	body_mesh.height = 1.35
	var body := MeshInstance3D.new()
	body.mesh = body_mesh
	body.position.y = 0.72
	var body_material := StandardMaterial3D.new()
	body_material.albedo_color = body_color
	body.material_override = body_material
	add_child(body)

	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.23
	head_mesh.height = 0.46
	var head := MeshInstance3D.new()
	head.mesh = head_mesh
	head.position.y = 1.62
	var skin := StandardMaterial3D.new()
	skin.albedo_color = Color(0.82, 0.62, 0.48)
	head.material_override = skin
	add_child(head)

	var label := Label3D.new()
	label.text = display_name
	label.position.y = 2.05
	label.font_size = 32
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func interact() -> String:
	match role:
		"mother":
			return GameState.talk_with_family("Mẹ")
		"father":
			return GameState.talk_with_family("Bố")
		"job_board":
			if GameState.selected_career == "Chưa chọn nghề":
				var career := GameState.choose_next_career()
				return "Bạn đã chọn nghề: %s. Hãy quay lại bảng việc làm để nhận ca làm." % career
			return GameState.complete_work_shift()
	return "Không có gì để tương tác."
