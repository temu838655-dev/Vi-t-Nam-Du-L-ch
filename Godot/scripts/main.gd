extends Node3D

const PLAYER_SCRIPT := preload("res://scripts/player.gd")
const HUD_SCRIPT := preload("res://scripts/mobile_hud.gd")
const NPC_SCRIPT := preload("res://scripts/interactable_npc.gd")
const MOTORBIKE_SCRIPT := preload("res://scripts/motorbike.gd")
const SHOP_SCRIPT := preload("res://scripts/shop_interactable.gd")
const DEFAULT_START := Vector3(0, 1.1, 7)

var player: CharacterBody3D
var autosave_elapsed := 0.0
var menu_layer: CanvasLayer

func _ready() -> void:
	_build_prototype_world()
	_spawn_family_and_career_board()
	_show_main_menu()

func _process(delta: float) -> void:
	GameState.advance_world_clock(delta)
	if not is_instance_valid(player):
		return
	autosave_elapsed += delta
	if autosave_elapsed >= 15.0:
		autosave_elapsed = 0.0
		_save_current_game()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		_save_current_game()

func _show_main_menu() -> void:
	if is_instance_valid(menu_layer):
		menu_layer.queue_free()
	menu_layer = CanvasLayer.new()
	menu_layer.name = "MainMenu"
	add_child(menu_layer)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu_layer.add_child(root)

	var background := ColorRect.new()
	background.color = Color(0.035, 0.055, 0.075, 0.94)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(background)

	var panel := VBoxContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-260, -205)
	panel.size = Vector2(520, 410)
	panel.add_theme_constant_override("separation", 18)
	root.add_child(panel)

	var title := Label.new()
	title.text = "VIỆT NAM\nHÀNH TRÌNH BẤT TẬN"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34)
	panel.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Sống cuộc đời của bạn • Khám phá Việt Nam"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 18)
	panel.add_child(subtitle)

	var google_button := Button.new()
	google_button.text = "ĐĂNG NHẬP BẰNG GOOGLE"
	google_button.custom_minimum_size = Vector2(480, 64)
	google_button.pressed.connect(_show_google_sign_in_notice)
	panel.add_child(google_button)

	var guest_button := Button.new()
	guest_button.text = "CHƠI VỚI TƯ CÁCH KHÁCH"
	guest_button.custom_minimum_size = Vector2(480, 64)
	guest_button.pressed.connect(_show_guest_menu)
	panel.add_child(guest_button)

	var note := Label.new()
	note.text = "Đăng nhập khách lưu tiến trình trên thiết bị. Google Sign-In cần cấu hình OAuth và dịch vụ xác thực trước khi kích hoạt."
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.add_theme_font_size_override("font_size", 14)
	panel.add_child(note)

func _show_google_sign_in_notice() -> void:
	var dialog := AcceptDialog.new()
	dialog.title = "Đăng nhập Google"
	dialog.dialog_text = "Giao diện đăng nhập Google đã được bố trí, nhưng xác thực Google chưa thể hoạt động cho đến khi dự án được cấu hình OAuth Client ID, Android package fingerprint và dịch vụ lưu tài khoản. Bạn có thể chơi khách ngay bây giờ; dữ liệu sẽ lưu trên thiết bị."
	add_child(dialog)
	dialog.confirmed.connect(dialog.queue_free)
	dialog.popup_centered(Vector2i(560, 260))

func _show_guest_menu() -> void:
	if is_instance_valid(menu_layer):
		menu_layer.queue_free()
	menu_layer = CanvasLayer.new()
	menu_layer.name = "GuestMenu"
	add_child(menu_layer)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	menu_layer.add_child(root)
	var shade := ColorRect.new()
	shade.color = Color(0.025, 0.045, 0.07, 0.96)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(shade)
	var panel := VBoxContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-250, -150)
	panel.size = Vector2(500, 300)
	panel.add_theme_constant_override("separation", 16)
	root.add_child(panel)
	var heading := Label.new()
	heading.text = "CHẾ ĐỘ KHÁCH"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 30)
	panel.add_child(heading)
	var start_button := Button.new()
	start_button.text = "BẮT ĐẦU HÀNH TRÌNH MỚI"
	start_button.custom_minimum_size = Vector2(480, 64)
	start_button.pressed.connect(_start_new_game)
	panel.add_child(start_button)
	var continue_button := Button.new()
	continue_button.text = "TIẾP TỤC HÀNH TRÌNH"
	continue_button.custom_minimum_size = Vector2(480, 64)
	continue_button.disabled = not GameState.has_save
	continue_button.pressed.connect(_continue_game)
	panel.add_child(continue_button)
	var back_button := Button.new()
	back_button.text = "QUAY LẠI"
	back_button.pressed.connect(_show_main_menu)
	panel.add_child(back_button)

func _start_new_game() -> void:
	GameState.start_new_game()
	_enter_world(DEFAULT_START, 0.0)

func _continue_game() -> void:
	if not GameState.has_save:
		_enter_world(DEFAULT_START, 0.0)
		return
	_enter_world(GameState.last_position, GameState.last_rotation_y)

func _enter_world(start_position: Vector3, start_rotation: float) -> void:
	if is_instance_valid(menu_layer):
		menu_layer.queue_free()
	player = CharacterBody3D.new()
	player.name = "Player"
	player.set_script(PLAYER_SCRIPT)
	player.position = start_position
	player.rotation.y = start_rotation
	add_child(player)

	var hud := CanvasLayer.new()
	hud.name = "MobileHUD"
	hud.set_script(HUD_SCRIPT)
	add_child(hud)
	GameState.save_game(player.global_position, player.rotation.y)

func _save_current_game() -> void:
	if is_instance_valid(player):
		GameState.save_game(player.global_position, player.rotation.y)

func _spawn_family_and_career_board() -> void:
	_spawn_daily_residents()
	_add_npc("Mẹ", "mother", Vector3(-2.0, 0, -3.1), Color(0.72, 0.18, 0.22))
	_add_npc("Bố", "father", Vector3(2.0, 0, -3.1), Color(0.16, 0.28, 0.48))
	# Each career has its own recruiter so players can choose or change jobs directly.
	_add_npc("TÀI XẾ CÔNG NGHỆ", "career_driver", Vector3(-6.0, 0, 1.0), Color(0.12, 0.38, 0.72))
	_add_npc("NHÂN VIÊN DU LỊCH", "career_tourism", Vector3(-2.0, 0, 1.0), Color(0.12, 0.55, 0.48))
	_add_npc("ĐẦU BẾP", "career_chef", Vector3(2.0, 0, 1.0), Color(0.72, 0.34, 0.12))
	_add_npc("NHIẾP ẢNH GIA", "career_photographer", Vector3(6.0, 0, 1.0), Color(0.48, 0.28, 0.66))
	_add_motorbike(Vector3(2.8, 0, 7.0))
	_add_shop("vehicle", "ĐẠI LÝ XE MÁY", Vector3(-10.0, 0, 3.0), Color(0.78, 0.12, 0.08), PI)
	_add_shop("clothing", "THỜI TRANG VIỆT", Vector3(10.0, 0, 3.0), Color(0.12, 0.32, 0.62), PI)
	_add_shop("food", "QUÁN ĂN & ĐẶC SẢN", Vector3(0.0, 0, 17.0), Color(0.72, 0.34, 0.08), 0.0)


func _spawn_daily_residents() -> void:
	_add_daily_resident("Chú Minh", Vector3(-5.15, 0, -18), Vector3(-5.15, 0, 5), Vector3(-5.15, 0, 23), Color(0.18, 0.38, 0.68), 0.0)
	_add_daily_resident("Cô Lan", Vector3(5.15, 0, 27), Vector3(5.15, 0, 8), Vector3(5.15, 0, -12), Color(0.68, 0.24, 0.32), 80.0)

func _add_daily_resident(display_name: String, home: Vector3, workplace: Vector3, shop: Vector3, tint: Color, offset: float) -> void:
	var resident := Node3D.new()
	resident.name = "Resident_" + display_name.replace(" ", "")
	resident.set_script(load("res://scripts/civilian_routine.gd"))
	resident.set("resident_name", display_name)
	resident.set("home_position", home)
	resident.set("work_position", workplace)
	resident.set("shop_position", shop)
	resident.set("shirt_color", tint)
	resident.set("schedule_offset", offset)
	add_child(resident)

func _add_shop(shop_type: String, display_name: String, at: Vector3, tint: Color, facing: float) -> void:
	var shop := Node3D.new()
	shop.name = "Shop_" + shop_type
	shop.set_script(SHOP_SCRIPT)
	shop.set("shop_type", shop_type)
	shop.set("shop_name", display_name)
	shop.set("sign_color", tint)
	shop.position = at
	shop.rotation.y = facing
	add_child(shop)

func _add_motorbike(at: Vector3) -> void:
	var motorbike := Node3D.new()
	motorbike.name = "Motorbike_TestDrive"
	motorbike.set_script(MOTORBIKE_SCRIPT)
	motorbike.set("display_name", "Xe máy trải nghiệm")
	motorbike.position = at
	add_child(motorbike)

func _add_npc(display_name: String, role: String, at: Vector3, tint: Color) -> void:
	var npc := Node3D.new()
	npc.name = role.capitalize()
	npc.set_script(NPC_SCRIPT)
	npc.set("display_name", display_name)
	npc.set("role", role)
	npc.set("body_color", tint)
	npc.position = at
	add_child(npc)

func _add_traffic_system() -> void:
	var traffic := Node3D.new()
	traffic.name = "StreetTraffic"
	traffic.set_script(load("res://scripts/traffic_system.gd"))
	add_child(traffic)

func _build_prototype_world() -> void:
	_add_traffic_system()
	_build_ho_guom_landmark()
	_add_box("Ground", Vector3(0, -0.25, 0), Vector3(100, 0.5, 100), Color(0.22, 0.42, 0.25))
	# Starter family home and street are greybox placeholders, not final Vietnam assets.
	_add_box("FamilyHome", Vector3(0, 1.5, -8), Vector3(9, 3, 7), Color(0.82, 0.72, 0.55))
	_add_box("HomeRoof", Vector3(0, 3.5, -8), Vector3(10, 1, 8), Color(0.48, 0.18, 0.13))
	_add_box("Road", Vector3(0, 0.02, 8), Vector3(7, 0.08, 70), Color(0.12, 0.12, 0.13))
	for i in range(5):
		_add_box("StreetBuilding_%02d" % i, Vector3(-13 + i * 6.5, 2, -2 - (i % 2) * 10), Vector3(4, 4, 5), Color(0.72, 0.62, 0.48))
	var label := Label3D.new()
	label.text = "NHÀ GIA ĐÌNH"
	label.position = Vector3(0, 5.2, -8)
	label.font_size = 48
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)

func _add_box(object_name: String, at: Vector3, dimensions: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = object_name
	body.position = at
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = dimensions
	mesh.mesh = box
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	mesh.material_override = material
	body.add_child(mesh)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	body.add_child(collision)
	add_child(body)


func _build_ho_guom_landmark() -> void:
	# A distinct landmark district beside the starter neighbourhood.
	var water := MeshInstance3D.new()
	water.name = "HoanKiemLake_Water"
	var water_mesh := PlaneMesh.new()
	water_mesh.size = Vector2(30, 22)
	water.mesh = water_mesh
	water.position = Vector3(27, 0.015, -1)
	var water_mat := StandardMaterial3D.new()
	water_mat.albedo_color = Color(0.10, 0.36, 0.42, 0.88)
	water_mat.roughness = 0.22
	water_mat.metallic = 0.12
	water_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	water.material_override = water_mat
	add_child(water)

	var island := MeshInstance3D.new()
	island.name = "TurtleTower_Island"
	var island_mesh := CylinderMesh.new()
	island_mesh.top_radius = 2.3
	island_mesh.bottom_radius = 2.7
	island_mesh.height = 0.55
	island.mesh = island_mesh
	island.position = Vector3(27, 0.28, -1)
	var stone := StandardMaterial3D.new()
	stone.albedo_color = Color(0.55, 0.52, 0.42)
	stone.roughness = 0.92
	island.material_override = stone
	add_child(island)

	_add_landmark_cylinder("TurtleTower_LowerFloor", Vector3(27, 1.0, -1), 1.05, 1.35, 1.0, Color(0.78, 0.72, 0.56))
	_add_landmark_cylinder("TurtleTower_MiddleFloor", Vector3(27, 2.05, -1), 0.82, 1.05, 0.95, Color(0.82, 0.76, 0.62))
	_add_landmark_cylinder("TurtleTower_UpperFloor", Vector3(27, 3.05, -1), 0.62, 0.82, 0.85, Color(0.78, 0.72, 0.56))
	_add_landmark_cone("TurtleTower_Roof", Vector3(27, 3.95, -1), 0.78, 0.72, Color(0.48, 0.19, 0.13))
	_add_landmark_cylinder("TurtleTower_Top", Vector3(27, 4.62, -1), 0.10, 0.12, 0.55, Color(0.72, 0.62, 0.4))

	for i in range(8):
		var angle := TAU * float(i) / 8.0
		var tree_pos := Vector3(27 + cos(angle) * 11.0, 0, -1 + sin(angle) * 8.0)
		_add_landmark_cylinder("LakeTreeTrunk_%02d" % i, tree_pos + Vector3(0, 1.1, 0), 0.20, 0.24, 2.2, Color(0.30, 0.20, 0.12))
		_add_landmark_sphere("LakeTreeCanopy_%02d" % i, tree_pos + Vector3(0, 2.8, 0), Vector3(1.15, 1.2, 1.1), Color(0.12, 0.34, 0.18))

	for i in range(4):
		var bench := MeshInstance3D.new()
		bench.name = "LakesideBench_%02d" % i
		var bench_mesh := BoxMesh.new()
		bench_mesh.size = Vector3(1.5, 0.12, 0.42)
		bench.mesh = bench_mesh
		bench.position = Vector3(15 + i * 8.0, 0.58, 11.2)
		var wood := StandardMaterial3D.new()
		wood.albedo_color = Color(0.34, 0.20, 0.12)
		bench.material_override = wood
		add_child(bench)

	var landmark_label := Label3D.new()
	landmark_label.text = "HỒ GƯƠM • THÁP RÙA"
	landmark_label.position = Vector3(27, 6.2, -1)
	landmark_label.font_size = 42
	landmark_label.modulate = Color(1.0, 0.91, 0.68)
	landmark_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(landmark_label)
	_build_ho_guom_architecture()


func _build_ho_guom_architecture() -> void:
	# Cau The Huc: red pedestrian bridge linking the eastern shore to the island.
	var bridge_red := Color(0.72, 0.075, 0.055)
	_add_landmark_box("TheHucBridge_Deck", Vector3(27, 0.48, 5.1), Vector3(2.15, 0.22, 7.8), bridge_red)
	for side in [-1.0, 1.0]:
		_add_landmark_box("TheHucBridge_Rail_%s" % str(side), Vector3(27 + side * 0.94, 0.92, 5.1), Vector3(0.12, 0.72, 7.8), bridge_red)
		for post in range(9):
			_add_landmark_box("TheHucBridge_Post_%s_%02d" % [str(side), post], Vector3(27 + side * 0.94, 1.08, 1.55 + post * 0.88), Vector3(0.18, 1.05, 0.18), Color(0.82, 0.12, 0.075))

	# Ngoc Son Temple: raised timber hall, visible columns, tiled roof and sign.
	_add_landmark_box("NgocSonTemple_Platform", Vector3(30.0, 0.72, -1.0), Vector3(4.2, 0.42, 3.5), Color(0.62, 0.54, 0.40))
	_add_landmark_box("NgocSonTemple_Hall", Vector3(30.0, 1.95, -1.0), Vector3(3.45, 2.1, 2.75), Color(0.68, 0.24, 0.14))
	for x_offset in [-1.45, 1.45]:
		for z_offset in [-1.12, 1.12]:
			_add_landmark_cylinder("NgocSonTemple_Column_%s_%s" % [str(x_offset), str(z_offset)], Vector3(30.0 + x_offset, 1.95, -1.0 + z_offset), 0.10, 0.12, 2.05, Color(0.78, 0.62, 0.38))
	_add_landmark_box("NgocSonTemple_Roof", Vector3(30.0, 3.18, -1.0), Vector3(4.15, 0.28, 3.45), Color(0.30, 0.16, 0.12))
	_add_landmark_box("NgocSonTemple_Sign", Vector3(30.0, 2.12, -2.42), Vector3(1.65, 0.42, 0.08), Color(0.88, 0.72, 0.42))
	var temple_label := Label3D.new()
	temple_label.text = "ĐỀN NGỌC SƠN"
	temple_label.position = Vector3(30.0, 4.0, -1.0)
	temple_label.font_size = 30
	temple_label.modulate = Color(1.0, 0.91, 0.72)
	temple_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(temple_label)


func _add_landmark_box(object_name: String, at: Vector3, dimensions: Vector3, tint: Color) -> void:
	var node := MeshInstance3D.new()
	node.name = object_name
	var mesh := BoxMesh.new()
	mesh.size = dimensions
	node.mesh = mesh
	node.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.82
	node.material_override = material
	add_child(node)


func _add_landmark_cylinder(object_name: String, at: Vector3, top_radius: float, bottom_radius: float, height: float, tint: Color) -> void:
	var node := MeshInstance3D.new()
	node.name = object_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = top_radius
	mesh.bottom_radius = bottom_radius
	mesh.height = height
	node.mesh = mesh
	node.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.86
	node.material_override = material
	add_child(node)


func _add_landmark_cone(object_name: String, at: Vector3, radius: float, height: float, tint: Color) -> void:
	var node := MeshInstance3D.new()
	node.name = object_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.03
	mesh.bottom_radius = radius
	mesh.height = height
	node.mesh = mesh
	node.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.78
	node.material_override = material
	add_child(node)


func _add_landmark_sphere(object_name: String, at: Vector3, dimensions: Vector3, tint: Color) -> void:
	var node := MeshInstance3D.new()
	node.name = object_name
	var mesh := SphereMesh.new()
	mesh.radius = 1.0
	mesh.height = 2.0
	node.mesh = mesh
	node.scale = dimensions
	node.position = at
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.95
	node.material_override = material
	add_child(node)
