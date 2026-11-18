extends CanvasLayer

class LocalMapCanvas:
	extends Control

	signal waypoint_selected(world_position: Vector3)

	var player_position := Vector3.ZERO
	var player_rotation_y := 0.0
	var waypoint_position := Vector3.ZERO
	var has_waypoint := false

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		custom_minimum_size = Vector2(0, 300)

	func _world_to_canvas(world: Vector3) -> Vector2:
		var usable := size - Vector2(28, 28)
		return Vector2(14.0 + (world.x + 25.0) / 70.0 * usable.x, 14.0 + (world.z + 32.0) / 74.0 * usable.y)

	func _canvas_to_world(point: Vector2) -> Vector3:
		var usable := size - Vector2(28, 28)
		return Vector3(clampf((point.x - 14.0) / maxf(1.0, usable.x) * 70.0 - 25.0, -25.0, 45.0), 0.0, clampf((point.y - 14.0) / maxf(1.0, usable.y) * 74.0 - 32.0, -32.0, 42.0))

	func _draw() -> void:
		draw_rect(Rect2(Vector2.ZERO, size), Color(0.035, 0.12, 0.15, 1.0))
		# Park and green-space patches.
		draw_rect(Rect2(_world_to_canvas(Vector3(-18, 0, -18)), Vector2(size.x * 0.13, size.y * 0.12)), Color(0.08, 0.22, 0.16, 0.9))
		# Local street network, scaled from the playable prototype coordinates.
		var road_color := Color(0.19, 0.23, 0.25, 1.0)
		draw_line(_world_to_canvas(Vector3(0, 0, -32)), _world_to_canvas(Vector3(0, 0, 42)), road_color, 18.0, true)
		draw_line(_world_to_canvas(Vector3(-25, 0, 8)), _world_to_canvas(Vector3(45, 0, 8)), road_color, 13.0, true)
		draw_line(_world_to_canvas(Vector3(-25, 0, -18)), _world_to_canvas(Vector3(17, 0, -18)), road_color, 8.0, true)
		draw_line(_world_to_canvas(Vector3(-18, 0, -32)), _world_to_canvas(Vector3(-18, 0, 42)), road_color, 7.0, true)
		draw_line(_world_to_canvas(Vector3(15, 0, -32)), _world_to_canvas(Vector3(15, 0, 42)), road_color, 7.0, true)
		# Lane markings.
		for z in range(-28, 40, 5):
			var p := _world_to_canvas(Vector3(0, 0, float(z)))
			draw_line(p - Vector2(0, 5), p + Vector2(0, 5), Color(0.86, 0.82, 0.67, 0.9), 1.6, true)
		# Hoan Kiem Lake, island and Turtle Tower.
		var lake_center := _world_to_canvas(Vector3(27, 0, -1))
		var lake_radius := Vector2(size.x * 0.19, size.y * 0.16)
		var lake_points := PackedVector2Array()
		for i in range(40):
			var angle := TAU * float(i) / 40.0
			lake_points.append(lake_center + Vector2(cos(angle) * lake_radius.x, sin(angle) * lake_radius.y))
		draw_colored_polygon(lake_points, Color(0.08, 0.43, 0.55, 1.0))
		draw_arc(lake_center, lake_radius.x, 0.0, TAU, 48, Color(0.34, 0.76, 0.79, 0.9), 2.0, true)
		draw_circle(_world_to_canvas(Vector3(27, 0, -1)), 5.0, Color(0.82, 0.72, 0.48, 1.0))
		# Building and service markers.
		_draw_marker(Vector3(0, 0, -8), Color(0.95, 0.72, 0.35), "NHÀ")
		_draw_marker(Vector3(-10, 0, 3), Color(0.3, 0.72, 1.0), "XE")
		_draw_marker(Vector3(10, 0, 3), Color(0.3, 0.72, 1.0), "SHOP")
		_draw_marker(Vector3(0, 0, 17), Color(1.0, 0.56, 0.28), "ĂN")
		_draw_marker(Vector3(30, 0, -1), Color(1.0, 0.84, 0.45), "ĐỀN")
		# Waypoint line and destination.
		if has_waypoint:
			var target := _world_to_canvas(waypoint_position)
			var current := _world_to_canvas(player_position)
			draw_line(current, target, Color(1.0, 0.76, 0.22, 0.95), 2.5, true)
			draw_circle(target, 8.0, Color(1.0, 0.75, 0.16, 1.0))
			draw_arc(target, 12.0, 0.0, TAU, 32, Color(1.0, 0.9, 0.55, 1.0), 2.0, true)
		# Player arrow always reflects the live world position.
		var player_point := _world_to_canvas(player_position)
		var direction := Vector2(sin(player_rotation_y), -cos(player_rotation_y))
		var side := Vector2(-direction.y, direction.x)
		var triangle := PackedVector2Array([
			player_point + direction * 10.0,
			player_point - direction * 7.0 + side * 6.0,
			player_point - direction * 7.0 - side * 6.0
		])
		draw_colored_polygon(triangle, Color(0.24, 0.95, 0.62, 1.0))
		draw_arc(player_point, 11.0, 0.0, TAU, 32, Color(0.24, 0.95, 0.62, 0.9), 2.0, true)
		var font := ThemeDB.fallback_font
		if font:
			draw_string(font, Vector2(12, size.y - 10), "BẮC ↑  •  CHẠM BẢN ĐỒ ĐỂ ĐẶT ĐIỂM ĐẾN", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color(0.9, 0.94, 0.9))

	func _draw_marker(world: Vector3, tint: Color, label: String) -> void:
		var point := _world_to_canvas(world)
		draw_circle(point, 5.0, tint)
		draw_arc(point, 7.0, 0.0, TAU, 24, Color(0.03, 0.07, 0.08, 1.0), 1.5, true)
		var font := ThemeDB.fallback_font
		if font:
			draw_string(font, point + Vector2(8, 4), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.95, 0.95, 0.88))

	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			waypoint_selected.emit(_canvas_to_world(event.position))
			accept_event()
		elif event is InputEventScreenTouch and event.pressed:
			waypoint_selected.emit(_canvas_to_world(event.position))
			accept_event()


var player: CharacterBody3D
var status_label: Label
var clock_label: Label
var nearby_label: Label
var message_label: Label
var navigation_label: Label
var mission_label: Label
var joystick_origin := Vector2.ZERO
var joystick_touch := -1
var look_touch := -1
var move_vector := Vector2.ZERO
var joystick_base: Panel
var joystick_knob: Panel
var interact_button: Button
var ui_root: Control
var shop_overlay: Control
var shop_items_container: VBoxContainer
var current_shop_type := ""
var current_shop_name := ""
var inventory_overlay: Control
var inventory_items_container: VBoxContainer
var current_inventory_tab := "vehicle"
var family_dialogue_overlay: Control
var map_overlay: Control
var map_canvas: LocalMapCanvas
var active_waypoint := Vector3.ZERO
var has_active_waypoint := false

func _ready() -> void:
	add_to_group("shop_ui")
	player = get_parent().get_node_or_null("Player")
	ui_root = Control.new()
	ui_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ui_root)

	# Top-left player profile and primary objective, styled as translucent game HUD.
	var profile := _make_hud_panel(Vector2(22, 18), Vector2(310, 104))
	ui_root.add_child(profile)
	var profile_layout := HBoxContainer.new()
	profile_layout.add_theme_constant_override("separation", 12)
	profile.add_child(profile_layout)
	var avatar := Label.new()
	avatar.text = "🧑🏻"
	avatar.add_theme_font_size_override("font_size", 42)
	profile_layout.add_child(avatar)
	var profile_text := VBoxContainer.new()
	profile_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	profile_layout.add_child(profile_text)
	var player_name := Label.new()
	player_name.text = "Du Khách"
	player_name.add_theme_font_size_override("font_size", 21)
	profile_text.add_child(player_name)
	var level := Label.new()
	level.text = "★  Lv.1"
	level.add_theme_font_size_override("font_size", 17)
	profile_text.add_child(level)
	var xp := ProgressBar.new()
	xp.custom_minimum_size = Vector2(150, 10)
	xp.max_value = 100
	xp.value = 28
	xp.show_percentage = false
	profile_text.add_child(xp)

	var mission := _make_hud_panel(Vector2(22, 136), Vector2(310, 116))
	ui_root.add_child(mission)
	var mission_layout := VBoxContainer.new()
	mission_layout.add_theme_constant_override("separation", 4)
	mission.add_child(mission_layout)
	mission_label = Label.new()
	mission_label.add_theme_font_size_override("font_size", 15)
	mission_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mission_layout.add_child(mission_label)
	var guide_button := Button.new()
	guide_button.text = "DẪN ĐƯỜNG ĐẾN NHIỆM VỤ"
	guide_button.custom_minimum_size = Vector2(0, 34)
	guide_button.add_theme_font_size_override("font_size", 12)
	_style_game_button(guide_button, Color(0.10, 0.34, 0.34, 0.96))
	guide_button.pressed.connect(_guide_current_mission)
	mission_layout.add_child(guide_button)

	var navigation_panel := _make_hud_panel(Vector2(22, 260), Vector2(310, 66))
	navigation_panel.add_theme_stylebox_override("panel", _hud_style(Color(0.02, 0.10, 0.13, 0.84), Color(0.25, 0.82, 0.69, 0.88)))
	ui_root.add_child(navigation_panel)
	var navigation_row := HBoxContainer.new()
	navigation_row.add_theme_constant_override("separation", 8)
	navigation_panel.add_child(navigation_row)
	navigation_label = Label.new()
	navigation_label.text = "🧭 Chưa đặt điểm đến\nMở bản đồ để chọn nơi muốn đến"
	navigation_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	navigation_label.add_theme_font_size_override("font_size", 14)
	navigation_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	navigation_row.add_child(navigation_label)
	var clear_route_button := Button.new()
	clear_route_button.text = "XÓA"
	clear_route_button.custom_minimum_size = Vector2(58, 42)
	clear_route_button.pressed.connect(_clear_waypoint)
	navigation_row.add_child(clear_route_button)

	# Currency counters at the top center.
	var currency := _make_hud_panel(Vector2(350, 18), Vector2(340, 54))
	currency.add_theme_stylebox_override("panel", _hud_style(Color(0.015, 0.07, 0.16, 0.72), Color(0.35, 0.72, 1.0, 0.8)))
	ui_root.add_child(currency)
	var currency_row := HBoxContainer.new()
	currency_row.alignment = BoxContainer.ALIGNMENT_CENTER
	currency_row.add_theme_constant_override("separation", 18)
	currency.add_child(currency_row)
	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 19)
	currency_row.add_child(status_label)

	clock_label = Label.new()
	clock_label.position = Vector2(360, 78)
	clock_label.add_theme_font_size_override("font_size", 18)
	clock_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.62))
	ui_root.add_child(clock_label)

	# Top-right quick actions.
	var top_actions := HBoxContainer.new()
	top_actions.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	top_actions.position = Vector2(-350, 18)
	top_actions.add_theme_constant_override("separation", 8)
	ui_root.add_child(top_actions)
	for action in ["🎁\nQuà", "🏆\nThành tựu", "⚙\nCài đặt"]:
		var action_button := Button.new()
		action_button.text = action
		action_button.custom_minimum_size = Vector2(100, 58)
		action_button.add_theme_font_size_override("font_size", 14)
		action_button.pressed.connect(_show_hud_notice.bind(action.replace("\n", " ")))
		top_actions.add_child(action_button)

	# A tappable local map replaces the old decorative placeholder.
	var map_panel := _make_hud_panel(Vector2(-178, 88), Vector2(156, 118))
	map_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	ui_root.add_child(map_panel)
	var map_button := Button.new()
	map_button.text = "🧭\nBẢN ĐỒ\nXEM VỊ TRÍ"
	map_button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_button.add_theme_font_size_override("font_size", 16)
	_style_game_button(map_button, Color(0.04, 0.16, 0.25, 0.94))
	map_button.pressed.connect(_open_local_map)
	map_panel.add_child(map_button)

	# Fixed bottom-left joystick: the base never follows the finger.
	joystick_base = Panel.new()
	joystick_base.name = "JoystickBase"
	joystick_base.size = Vector2(164, 164)
	joystick_base.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	joystick_base.position = Vector2(28.0, -190.0)
	joystick_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick_base.add_theme_stylebox_override("panel", _hud_style(Color(0.025, 0.10, 0.20, 0.62), Color(0.28, 0.78, 1.0, 0.95), 82))
	ui_root.add_child(joystick_base)

	joystick_knob = Panel.new()
	joystick_knob.name = "JoystickKnob"
	joystick_knob.size = Vector2(68, 68)
	joystick_knob.position = Vector2(48, 48)
	joystick_knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick_knob.add_theme_stylebox_override("panel", _hud_style(Color(0.18, 0.62, 1.0, 0.86), Color(0.85, 0.96, 1.0, 0.95), 34))
	joystick_base.add_child(joystick_knob)

	# Bottom-right action cluster.
	var jump_button := Button.new()
	jump_button.text = "🏃\nNHẢY"
	jump_button.size = Vector2(104, 78)
	jump_button.position = Vector2(-128, -196)
	jump_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	jump_button.add_theme_font_size_override("font_size", 17)
	_style_game_button(jump_button, Color(0.05, 0.28, 0.48, 0.96))
	jump_button.pressed.connect(_jump)
	ui_root.add_child(jump_button)

	interact_button = Button.new()
	interact_button.text = "💬\nTƯƠNG TÁC"
	interact_button.size = Vector2(132, 78)
	interact_button.position = Vector2(-278, -112)
	interact_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	interact_button.add_theme_font_size_override("font_size", 16)
	_style_game_button(interact_button, Color(0.55, 0.22, 0.06, 0.98))
	interact_button.pressed.connect(_interact)
	ui_root.add_child(interact_button)

	var inventory_button := Button.new()
	inventory_button.text = "🎒\nTÚI ĐỒ"
	inventory_button.size = Vector2(112, 78)
	inventory_button.position = Vector2(-132, -104)
	inventory_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	inventory_button.add_theme_font_size_override("font_size", 16)
	_style_game_button(inventory_button, Color(0.12, 0.22, 0.42, 0.98))
	inventory_button.pressed.connect(open_inventory)
	ui_root.add_child(inventory_button)

	message_label = Label.new()
	message_label.position = Vector2(-300, -205)
	message_label.size = Vector2(600, 64)
	message_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.add_theme_font_size_override("font_size", 17)
	message_label.add_theme_color_override("font_color", Color(1, 1, 1))
	message_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.95))
	message_label.add_theme_constant_override("shadow_offset_x", 2)
	message_label.add_theme_constant_override("shadow_offset_y", 2)
	ui_root.add_child(message_label)

	nearby_label = Label.new()
	nearby_label.position = Vector2(-250, -278)
	nearby_label.size = Vector2(500, 44)
	nearby_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	nearby_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nearby_label.add_theme_font_size_override("font_size", 18)
	nearby_label.add_theme_color_override("font_color", Color(1.0, 0.92, 0.68))
	ui_root.add_child(nearby_label)

	if player and player.has_signal("interaction_message"):
		player.interaction_message.connect(_show_message)
	_update_status()

func _hud_style(fill: Color, outline: Color, corner_radius: int = 14) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = outline
	style.set_border_width_all(2)
	style.set_corner_radius_all(corner_radius)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _make_hud_panel(at: Vector2, dimensions: Vector2) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.position = at
	panel.size = dimensions
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.add_theme_stylebox_override("panel", _hud_style(Color(0.015, 0.055, 0.12, 0.78), Color(0.32, 0.68, 0.96, 0.82)))
	return panel

func _show_hud_notice(action_name: String) -> void:
	if action_name.contains("Cài đặt"):
		var dialog := AcceptDialog.new()
		dialog.title = "Cài đặt"
		dialog.dialog_text = "Cài đặt đồ họa, âm thanh và điều khiển sẽ được mở rộng ở bản tiếp theo."
		add_child(dialog)
		dialog.confirmed.connect(dialog.queue_free)
		dialog.popup_centered(Vector2i(480, 220))
	else:
		_show_message(action_name + " sẽ được mở khi hệ thống phần thưởng và thành tựu hoàn thiện.")

func _process(_delta: float) -> void:
	_update_status()
	_update_mission_ui()
	if is_instance_valid(map_canvas) and is_instance_valid(player):
		map_canvas.player_position = player.global_position
		map_canvas.player_rotation_y = player.rotation.y
		map_canvas.queue_redraw()
	_update_navigation_guidance()

func _update_mission_ui() -> void:
	if not is_instance_valid(mission_label):
		return
	var mission: Dictionary = GameState.get_tutorial_mission()
	mission_label.text = "❗ NHIỆM VỤ %d/5\\n%s\\n%s" % [mini(GameState.tutorial_stage + 1, 5), str(mission.get("title", "")), str(mission.get("description", ""))]

func _guide_current_mission() -> void:
	var mission: Dictionary = GameState.get_tutorial_mission()
	var target_type := str(mission.get("target", "none"))
	var target_position := Vector3.ZERO
	match target_type:
		"family":
			for candidate in get_tree().get_nodes_in_group("interactable"):
				if candidate is Node3D and (str(candidate.get("role")) == "mother" or str(candidate.get("role")) == "father"):
					target_position = candidate.global_position
					break
		"ho_guom":
			target_position = Vector3(27, 0, 5.1)
		"food_shop":
			target_position = Vector3(0, 0, 17)
		"career":
			var desired_role := "career_driver"
			match GameState.selected_career:
				"Tài xế công nghệ": desired_role = "career_driver"
				"Nhân viên du lịch": desired_role = "career_tourism"
				"Đầu bếp": desired_role = "career_chef"
				"Nhiếp ảnh gia": desired_role = "career_photographer"
			var found := false
			for candidate in get_tree().get_nodes_in_group("interactable"):
				if candidate is Node3D and str(candidate.get("role")) == desired_role:
					target_position = candidate.global_position
					found = true
					break
			if not found:
				target_position = Vector3(6, 0, 1)
		_:
			_show_message("Bạn đã hoàn thành phần hướng dẫn nhập môn. Hãy tự do khám phá!")
			return
	_set_map_waypoint(target_position)
	_show_message("Đã đặt đường dẫn cho nhiệm vụ: " + str(mission.get("title", "")))

func _update_navigation_guidance() -> void:
	if not is_instance_valid(navigation_label):
		return
	if not has_active_waypoint or not is_instance_valid(player):
		navigation_label.text = "🧭 Chưa đặt điểm đến\nMở bản đồ để chọn nơi muốn đến"
		return
	var offset := active_waypoint - player.global_position
	var flat_offset := Vector2(offset.x, offset.z)
	var distance := flat_offset.length()
	if distance <= 2.5:
		_clear_waypoint()
		_show_message("Bạn đã đến điểm đánh dấu!")
		return
	var direction := flat_offset / maxf(distance, 0.001)
	var world_angle := atan2(direction.x, -direction.y)
	var relative_angle := wrapf(world_angle - player.rotation.y, -PI, PI)
	var arrows := ["↑", "↗", "→", "↘", "↓", "↙", "←", "↖"]
	var arrow_index := posmod(int(round(relative_angle / (PI / 4.0))), 8)
	navigation_label.text = "🧭 ĐIỂM ĐẾN\n%s  Còn %.0f m" % [arrows[arrow_index], distance]

func _clear_waypoint() -> void:
	has_active_waypoint = false
	active_waypoint = Vector3.ZERO
	if is_instance_valid(map_canvas):
		map_canvas.has_waypoint = false
		map_canvas.queue_redraw()
	if is_instance_valid(navigation_label):
		navigation_label.text = "🧭 Chưa đặt điểm đến\nMở bản đồ để chọn nơi muốn đến"

func _update_status() -> void:
	if status_label:
		status_label.text = "🪙 %s VNĐ   💎 0" % _format_money(GameState.wallet_vnd)
	if clock_label:
		clock_label.text = "🕒 " + GameState.get_world_clock_text() + "  •  Ngày mới"
	if interact_button and player and player.has_method("is_riding_vehicle"):
		if player.is_riding_vehicle():
			interact_button.text = "XUỐNG XE"
			nearby_label.text = "Bạn đang điều khiển phương tiện"
		else:
			var nearby_name := str(player.call("get_nearby_interactable_name"))
			interact_button.text = "NÓI CHUYỆN" if not nearby_name.is_empty() else "TƯƠNG TÁC"
			nearby_label.text = "Nhấn TƯƠNG TÁC: " + nearby_name if not nearby_name.is_empty() else "Di chuyển đến gần người dân, cửa hàng hoặc xe để tương tác"

func _format_money(amount: int) -> String:
	var raw := str(amount)
	var result := ""
	for i in range(raw.length()):
		result += raw[i]
		var remaining := raw.length() - i - 1
		if remaining > 0 and remaining % 3 == 0:
			result += "."
	return result

func _show_message(message: String) -> void:
	if message_label:
		message_label.text = message
	_update_status()

func _jump() -> void:
	if player and player.is_on_floor() and not player.is_riding_vehicle():
		player.velocity.y = 6.0

func _interact() -> void:
	if player:
		player.interact_nearby()

func open_shop(shop_type: String, shop_name: String) -> void:
	current_shop_type = shop_type
	current_shop_name = shop_name
	if is_instance_valid(shop_overlay):
		shop_overlay.queue_free()
	shop_overlay = Control.new()
	shop_overlay.name = "ShopOverlay"
	shop_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shop_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	ui_root.add_child(shop_overlay)

	var shade := ColorRect.new()
	shade.color = Color(0.015, 0.025, 0.04, 0.88)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shop_overlay.add_child(shade)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-440, -300)
	panel.size = Vector2(880, 600)
	shop_overlay.add_child(panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 12)
	panel.add_child(layout)

	var header := HBoxContainer.new()
	layout.add_child(header)
	var heading := Label.new()
	heading.text = current_shop_name
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	heading.add_theme_font_size_override("font_size", 28)
	header.add_child(heading)
	var close_button := Button.new()
	close_button.text = "ĐÓNG"
	close_button.custom_minimum_size = Vector2(110, 48)
	close_button.pressed.connect(_close_shop)
	header.add_child(close_button)

	var balance := Label.new()
	balance.name = "ShopBalance"
	balance.text = "Số dư: %s VNĐ" % _format_money(GameState.wallet_vnd)
	balance.add_theme_font_size_override("font_size", 19)
	layout.add_child(balance)

	var note := Label.new()
	note.text = _shop_description(shop_type)
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(note)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)
	shop_items_container = VBoxContainer.new()
	shop_items_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shop_items_container.add_theme_constant_override("separation", 8)
	scroll.add_child(shop_items_container)
	_refresh_shop_items()

func _shop_description(shop_type: String) -> String:
	match shop_type:
		"vehicle":
			return "Chọn xe máy phổ biến tại Việt Nam. Giá là giá mô phỏng trong game; mua xe sẽ thêm phương tiện gần nhân vật."
		"clothing":
			return "Thử phong cách đời thường Việt Nam. Trang phục mua được sẽ lưu vào tủ đồ và mặc ngay."
		"food":
			return "Thưởng thức món ăn và đặc sản từ nhiều vùng miền. Mỗi món giúp nhân vật no hơn."
	return ""

func _refresh_shop_items() -> void:
	if not is_instance_valid(shop_items_container):
		return
	for child in shop_items_container.get_children():
		child.queue_free()
	for item in GameState.get_catalog(current_shop_type):
		var item_id := str(item.get("id", ""))
		var row := HBoxContainer.new()
		row.custom_minimum_size = Vector2(0, 78)
		shop_items_container.add_child(row)

		var details := VBoxContainer.new()
		details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(details)
		var item_title := Label.new()
		item_title.text = str(item.get("name", "Sản phẩm"))
		item_title.add_theme_font_size_override("font_size", 19)
		details.add_child(item_title)
		var description := Label.new()
		description.text = "%s  •  %s VNĐ" % [str(item.get("description", "")), _format_money(int(item.get("price", 0)))]
		description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		description.add_theme_font_size_override("font_size", 14)
		details.add_child(description)

		var action := Button.new()
		action.custom_minimum_size = Vector2(150, 56)
		var owned := GameState.is_item_owned(current_shop_type, item_id)
		match current_shop_type:
			"vehicle":
				action.text = "LẤY XE" if owned else "MUA XE"
			"clothing":
				action.text = "MẶC" if owned else "MUA & MẶC"
			"food":
				action.text = "ĐÃ CÓ" if owned and bool(item.get("packaged", false)) else ("MUA ĐẶC SẢN" if bool(item.get("packaged", false)) else "MUA & ĂN")
		action.disabled = owned and current_shop_type == "food" and bool(item.get("packaged", false))
		action.pressed.connect(_purchase_shop_item.bind(current_shop_type, item_id))
		row.add_child(action)

func _purchase_shop_item(shop_type: String, item_id: String) -> void:
	var result: Dictionary = GameState.purchase_item(shop_type, item_id)
	_show_message(str(result.get("message", "Giao dịch hoàn tất.")))
	if bool(result.get("ok", false)):
		if shop_type == "food" and not bool(result.get("already_owned", false)):
			GameState.advance_tutorial("buy_food")
			_update_mission_ui()
		var item: Dictionary = result.get("item", {})
		if shop_type == "vehicle" and player and player.has_method("spawn_owned_vehicle"):
			player.spawn_owned_vehicle(str(item.get("name", "Xe máy")), item.get("color", Color(0.8, 0.1, 0.1)))
		elif shop_type == "clothing" and player and player.has_method("apply_outfit"):
			player.apply_outfit(GameState.equipped_clothes)
		_refresh_shop_items()
		var balance := shop_overlay.find_child("ShopBalance", true, false)
		if balance is Label:
			balance.text = "Số dư: %s VNĐ" % _format_money(GameState.wallet_vnd)
		GameState.save_game(player.global_position, player.rotation.y)

func _close_shop() -> void:
	if is_instance_valid(shop_overlay):
		shop_overlay.queue_free()
	shop_overlay = null



func open_inventory() -> void:
	if is_instance_valid(inventory_overlay):
		inventory_overlay.queue_free()
	inventory_overlay = Control.new()
	inventory_overlay.name = "InventoryOverlay"
	inventory_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inventory_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	ui_root.add_child(inventory_overlay)

	var shade := ColorRect.new()
	shade.color = Color(0.015, 0.025, 0.04, 0.9)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	inventory_overlay.add_child(shade)

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-430, -285)
	panel.size = Vector2(860, 570)
	inventory_overlay.add_child(panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 10)
	panel.add_child(layout)

	var header := HBoxContainer.new()
	layout.add_child(header)
	var heading := Label.new()
	heading.text = "TÀI SẢN & HÀNH TRANG"
	heading.add_theme_font_size_override("font_size", 26)
	heading.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(heading)
	var close := Button.new()
	close.text = "ĐÓNG"
	close.custom_minimum_size = Vector2(100, 46)
	close.pressed.connect(_close_inventory)
	header.add_child(close)

	var balance := Label.new()
	balance.text = "Ví tiền: %s VNĐ" % _format_money(GameState.wallet_vnd)
	balance.add_theme_font_size_override("font_size", 18)
	layout.add_child(balance)

	var tabs := HBoxContainer.new()
	layout.add_child(tabs)
	for tab in ["vehicle", "clothing", "food"]:
		var tab_button := Button.new()
		match tab:
			"vehicle": tab_button.text = "PHƯƠNG TIỆN"
			"clothing": tab_button.text = "TỦ ĐỒ"
			"food": tab_button.text = "ĐẶC SẢN"
		tab_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab_button.pressed.connect(_set_inventory_tab.bind(tab))
		tabs.add_child(tab_button)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)
	inventory_items_container = VBoxContainer.new()
	inventory_items_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inventory_items_container.add_theme_constant_override("separation", 8)
	scroll.add_child(inventory_items_container)
	_refresh_inventory()

func _set_inventory_tab(tab: String) -> void:
	current_inventory_tab = tab
	_refresh_inventory()

func _refresh_inventory() -> void:
	if not is_instance_valid(inventory_items_container):
		return
	for child in inventory_items_container.get_children():
		child.queue_free()

	var owned_ids: Array = []
	match current_inventory_tab:
		"vehicle":
			owned_ids = GameState.owned_vehicles
		"clothing":
			owned_ids = GameState.owned_clothes
		"food":
			owned_ids = GameState.owned_specialties

	var catalog := GameState.get_catalog(current_inventory_tab)
	var found := 0
	for item in catalog:
		var item_id := str(item.get("id", ""))
		if not owned_ids.has(item_id):
			continue
		found += 1
		var row := HBoxContainer.new()
		row.custom_minimum_size = Vector2(0, 68)
		inventory_items_container.add_child(row)
		var details := VBoxContainer.new()
		details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(details)
		var item_label := Label.new()
		item_label.text = str(item.get("name", "Vật phẩm"))
		item_label.add_theme_font_size_override("font_size", 18)
		details.add_child(item_label)
		var sub_label := Label.new()
		match current_inventory_tab:
			"vehicle":
				sub_label.text = "Phương tiện đã mua" + (" • Đang chọn" if GameState.selected_vehicle == item_id else "")
			"clothing":
				var slot := str(item.get("slot", "top"))
				sub_label.text = "Trang phục • " + ("Đang mặc" if str(GameState.equipped_clothes.get(slot, "")) == item_id else "Đã sở hữu")
			"food":
				sub_label.text = "Đặc sản • %s" % str(item.get("region", "Việt Nam"))
		details.add_child(sub_label)

		if current_inventory_tab == "clothing":
			var wear := Button.new()
			wear.text = "MẶC"
			wear.custom_minimum_size = Vector2(110, 48)
			wear.pressed.connect(_wear_owned_clothing.bind(item_id))
			row.add_child(wear)
		elif current_inventory_tab == "vehicle":
			var select_button := Button.new()
			select_button.text = "ĐANG CHỌN" if GameState.selected_vehicle == item_id else "CHỌN XE"
			select_button.disabled = GameState.selected_vehicle == item_id
			select_button.custom_minimum_size = Vector2(120, 48)
			select_button.pressed.connect(_select_owned_vehicle.bind(item_id))
			row.add_child(select_button)

	if found == 0:
		var empty := Label.new()
		match current_inventory_tab:
			"vehicle": empty.text = "Bạn chưa sở hữu xe máy. Hãy ghé đại lý xe máy."
			"clothing": empty.text = "Tủ đồ đang trống."
			"food": empty.text = "Bạn chưa mua đặc sản mang về."
		empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		inventory_items_container.add_child(empty)

func _wear_owned_clothing(item_id: String) -> void:
	var result: Dictionary = GameState.purchase_item("clothing", item_id)
	if bool(result.get("ok", false)) and player and player.has_method("apply_outfit"):
		player.apply_outfit(GameState.equipped_clothes)
	_show_message(str(result.get("message", "Không thể mặc trang phục.")))
	_refresh_inventory()

func _select_owned_vehicle(item_id: String) -> void:
	GameState.selected_vehicle = item_id
	if player:
		GameState.save_game(player.global_position, player.rotation.y)
	_show_message("Đã chọn %s. Hãy đến xe trong thế giới để lái." % str(GameState.get_item("vehicle", item_id).get("name", "phương tiện")))
	_refresh_inventory()

func _close_inventory() -> void:
	if is_instance_valid(inventory_overlay):
		inventory_overlay.queue_free()
	inventory_overlay = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			var base_rect := joystick_base.get_global_rect().grow(22.0)
			if base_rect.has_point(event.position) and joystick_touch == -1:
				joystick_touch = event.index
				joystick_origin = joystick_base.global_position + joystick_base.size * 0.5
				_update_joystick_from_position(event.position)
			elif event.position.x > get_viewport().get_visible_rect().size.x * 0.48 and look_touch == -1:
				look_touch = event.index
		else:
			if event.index == joystick_touch:
				joystick_touch = -1
				move_vector = Vector2.ZERO
				if player:
					player.set_mobile_move(Vector2.ZERO)
				if is_instance_valid(joystick_knob):
					joystick_knob.position = (joystick_base.size - joystick_knob.size) * 0.5
			if event.index == look_touch:
				look_touch = -1
	elif event is InputEventScreenDrag:
		if event.index == joystick_touch:
			_update_joystick_from_position(event.position)
		elif event.index == look_touch:
			if player:
				player.add_mobile_look(event.relative)

func _update_joystick_from_position(touch_position: Vector2) -> void:
	move_vector = ((touch_position - joystick_origin) / 58.0).limit_length(1.0)
	if is_instance_valid(joystick_knob):
		joystick_knob.position = (joystick_base.size - joystick_knob.size) * 0.5 + move_vector * 46.0
	if player:
		player.set_mobile_move(move_vector)

func _style_game_button(button: Button, fill: Color) -> void:
	var normal := _hud_style(fill, Color(0.58, 0.84, 1.0, 0.95), 20)
	normal.set_border_width_all(2)
	button.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate()
	hover.bg_color = fill.lightened(0.16)
	button.add_theme_stylebox_override("hover", hover)
	var pressed := normal.duplicate()
	pressed.bg_color = fill.darkened(0.18)
	pressed.border_color = Color(1.0, 0.82, 0.38, 1.0)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_color_override("font_color", Color(1, 1, 1))
	button.add_theme_color_override("font_hover_color", Color(1, 1, 1))
	button.add_theme_color_override("font_pressed_color", Color(1, 0.94, 0.78))
	button.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	button.add_theme_constant_override("outline_size", 2)

func _open_local_map() -> void:
	if is_instance_valid(map_overlay):
		map_overlay.queue_free()
	map_overlay = Control.new()
	map_overlay.name = "LocalMapOverlay"
	map_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	ui_root.add_child(map_overlay)

	var shade := ColorRect.new()
	shade.color = Color(0.008, 0.025, 0.045, 0.94)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map_overlay.add_child(shade)

	var viewport_size := get_viewport().get_visible_rect().size
	var panel_width := minf(350.0, viewport_size.x - 24.0)
	var panel_height := minf(570.0, viewport_size.y - 32.0)
	var panel := _make_hud_panel(Vector2.ZERO, Vector2(panel_width, panel_height))
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -panel_width * 0.5
	panel.offset_right = panel_width * 0.5
	panel.offset_top = -panel_height * 0.5
	panel.offset_bottom = panel_height * 0.5
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	map_overlay.add_child(panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 9)
	panel.add_child(layout)

	var heading := Label.new()
	heading.text = "BẢN ĐỒ KHU VỰC HỒ GƯƠM"
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 20)
	layout.add_child(heading)

	map_canvas = LocalMapCanvas.new()
	map_canvas.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_canvas.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_canvas.custom_minimum_size = Vector2(0, minf(360.0, viewport_size.y * 0.43))
	map_canvas.player_position = player.global_position if is_instance_valid(player) else Vector3.ZERO
	map_canvas.player_rotation_y = player.rotation.y if is_instance_valid(player) else 0.0
	map_canvas.has_waypoint = has_active_waypoint
	map_canvas.waypoint_position = active_waypoint
	map_canvas.waypoint_selected.connect(_set_map_waypoint)
	layout.add_child(map_canvas)

	var legend := Label.new()
	legend.text = "● Bạn  •  ● Nhà  •  ● Cửa hàng  •  ● Địa danh"
	legend.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	legend.add_theme_font_size_override("font_size", 12)
	legend.add_theme_color_override("font_color", Color(0.82, 0.9, 0.92))
	layout.add_child(legend)

	var close := Button.new()
	close.text = "ĐÓNG BẢN ĐỒ"
	close.custom_minimum_size = Vector2(0, 50)
	_style_game_button(close, Color(0.06, 0.30, 0.48, 1.0))
	close.pressed.connect(_close_local_map)
	layout.add_child(close)

func _set_map_waypoint(world_position: Vector3) -> void:
	active_waypoint = world_position
	has_active_waypoint = true
	if is_instance_valid(map_canvas):
		map_canvas.waypoint_position = active_waypoint
		map_canvas.has_waypoint = true
		map_canvas.queue_redraw()
	var distance_text := ""
	if is_instance_valid(player):
		var distance := Vector2(player.global_position.x, player.global_position.z).distance_to(Vector2(world_position.x, world_position.z))
		distance_text = " • Cách bạn %.0f m" % distance
	_show_message("Đã đặt điểm đến%s. Mũi tên và khoảng cách sẽ cập nhật khi bạn di chuyển." % distance_text)
	_update_navigation_guidance()

func _close_local_map() -> void:
	if is_instance_valid(map_overlay):
		map_overlay.queue_free()
	map_overlay = null
	map_canvas = null


func open_family_dialogue(member_role: String, activity: String) -> void:
	if is_instance_valid(family_dialogue_overlay):
		family_dialogue_overlay.queue_free()
	family_dialogue_overlay = Control.new()
	family_dialogue_overlay.name = "FamilyDialogue"
	family_dialogue_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	family_dialogue_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	ui_root.add_child(family_dialogue_overlay)

	var shade := ColorRect.new()
	shade.color = Color(0.01, 0.025, 0.045, 0.82)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	family_dialogue_overlay.add_child(shade)

	var viewport_size := get_viewport().get_visible_rect().size
	var panel_width := minf(620.0, maxf(280.0, viewport_size.x - 28.0))
	var panel_height := minf(440.0, maxf(250.0, viewport_size.y - 28.0))
	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -panel_width * 0.5
	panel.offset_top = -panel_height * 0.5
	panel.offset_right = panel_width * 0.5
	panel.offset_bottom = panel_height * 0.5
	family_dialogue_overlay.add_child(panel)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(scroll)
	var layout := VBoxContainer.new()
	layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	layout.add_theme_constant_override("separation", 10)
	scroll.add_child(layout)

	var member_name := "Mẹ" if member_role == "mother" else "Bố"
	var heading := Label.new()
	heading.text = "TRÒ CHUYỆN CÙNG " + member_name.to_upper()
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", clampi(int(panel_width * 0.042), 18, 26))
	layout.add_child(heading)

	var context := Label.new()
	context.text = member_name + " hiện đang: " + (activity if not activity.is_empty() else "ở nhà cùng gia đình") + "."
	context.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	context.add_theme_font_size_override("font_size", 18)
	layout.add_child(context)

	var relationship := Label.new()
	relationship.text = "TÌNH CẢM GIA ĐÌNH: %s  •  %d/100" % [GameState.get_family_relationship_title(), GameState.family_affection]
	relationship.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	relationship.add_theme_font_size_override("font_size", 16)
	layout.add_child(relationship)
	var affection_bar := ProgressBar.new()
	affection_bar.max_value = 100
	affection_bar.value = GameState.family_affection
	affection_bar.show_percentage = false
	affection_bar.custom_minimum_size = Vector2(0, 12)
	layout.add_child(affection_bar)

	var family_progress := Label.new()
	family_progress.text = GameState.get_family_progress_text()
	family_progress.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	family_progress.add_theme_font_size_override("font_size", 14)
	layout.add_child(family_progress)
	var picnic_status := Label.new()
	picnic_status.text = "ĐỦ ĐIỀU KIỆN SỰ KIỆN DÃ NGOẠI (nội dung sự kiện đang phát triển)" if GameState.is_family_picnic_unlocked() else "Mục tiêu: thân thiết 50/100 và cùng ăn 3 bữa để mở sự kiện dã ngoại."
	picnic_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	picnic_status.add_theme_font_size_override("font_size", 13)
	layout.add_child(picnic_status)

	var prompt := Label.new()
	prompt.text = "Bạn muốn nói gì?"
	prompt.add_theme_font_size_override("font_size", 19)
	layout.add_child(prompt)

	var greeting := Button.new()
	greeting.text = "HỎI THĂM SỨC KHỎE" + ("  •  ĐÃ HỎI HÔM NAY" if GameState.has_family_interaction(member_role, "greeting") else "")
	greeting.disabled = GameState.has_family_interaction(member_role, "greeting")
	greeting.custom_minimum_size = Vector2(0, 58)
	greeting.pressed.connect(_choose_family_dialogue.bind(member_role, "greeting", activity))
	layout.add_child(greeting)

	var help := Button.new()
	if activity == "Chuẩn bị bữa ăn":
		help.text = "PHỤ CHUẨN BỊ BỮA ĂN"
	elif activity == "Dọn dẹp nhà cửa":
		help.text = "CÙNG DỌN DẸP NHÀ CỬA"
	elif activity == "Xem TV":
		help.text = "NGỒI XEM TV CÙNG GIA ĐÌNH"
	elif activity == "Dùng bữa cùng gia đình":
		help.text = "MỜI CẢ NHÀ DÙNG BỮA"
	else:
		help.text = "GIÚP ĐỠ BỐ MẸ"
	if GameState.has_family_interaction(member_role, "help"):
		help.text += "  •  ĐÃ GIÚP HÔM NAY"
	help.disabled = GameState.has_family_interaction(member_role, "help")
	help.custom_minimum_size = Vector2(0, 58)
	help.pressed.connect(_choose_family_dialogue.bind(member_role, "help", activity))
	layout.add_child(help)

	var advice := Button.new()
	advice.text = "XIN LỜI KHUYÊN CHO CHUYẾN ĐI" + ("  •  ĐÃ HỎI HÔM NAY" if GameState.has_family_interaction(member_role, "advice") else "")
	advice.disabled = GameState.has_family_interaction(member_role, "advice")
	advice.custom_minimum_size = Vector2(0, 58)
	advice.pressed.connect(_choose_family_dialogue.bind(member_role, "advice", activity))
	layout.add_child(advice)

	var close := Button.new()
	close.text = "ĐỂ LÁT NÓI CHUYỆN TIẾP"
	close.custom_minimum_size = Vector2(0, 48)
	close.pressed.connect(_close_family_dialogue)
	layout.add_child(close)


func _choose_family_dialogue(member_role: String, choice: String, activity: String = "") -> void:
	var member_name := "Mẹ" if member_role == "mother" else "Bố"
	if not GameState.register_family_interaction(member_role, choice):
		_close_family_dialogue()
		_show_message("Hôm nay bạn đã thực hiện lựa chọn này với %s rồi. Hãy quay lại vào ngày mai để tiếp tục gắn kết nhé." % member_name)
		return
	var affection_gain := 5
	var response := ""
	match choice:
		"greeting":
			response = "Mẹ vui vì con vẫn quan tâm đến gia đình." if member_role == "mother" else "Bố khỏe, cảm ơn con đã hỏi thăm. Nhớ giữ an toàn khi đi đường nhé."
		"help":
			affection_gain = 8
			match activity:
				"Chuẩn bị bữa ăn":
					GameState.satiety = mini(100, GameState.satiety + 5)
					GameState.family_cooking_sessions += 1
					response = "Con đã phụ chuẩn bị bữa ăn. Cả nhà sắp có một bữa cơm ngon rồi! Số lần cùng nấu: %d." % GameState.family_cooking_sessions
				"Dọn dẹp nhà cửa":
					GameState.home_cleanliness = mini(100, GameState.home_cleanliness + 20)
					response = "Hai mẹ con cùng làm nên nhà cửa gọn gàng hơn!" if member_role == "mother" else "Hai bố con cùng làm nên nhà cửa gọn gàng hơn!"
					response += " Độ sạch sẽ: %d/100." % GameState.home_cleanliness
				"Xem TV":
					GameState.family_tv_sessions += 1
					response = "Ngồi xem cùng gia đình nhé. Đây là buổi xem TV chung thứ %d." % GameState.family_tv_sessions
				"Dùng bữa cùng gia đình":
					GameState.satiety = mini(100, GameState.satiety + 12)
					GameState.family_meals_shared += 1
					response = "Cả nhà cùng ăn nhé! Bữa cơm chung thứ %d thật ấm cúng." % GameState.family_meals_shared
				_:
					response = "Cảm ơn con đã quan tâm và giúp đỡ gia đình."
		"advice":
			response = "Con hãy tìm hiểu đường đi, chuẩn bị đủ tiền và luôn đội mũ bảo hiểm khi đi xe máy nhé."
	GameState.family_affection = mini(100, GameState.family_affection + affection_gain)
	if player:
		GameState.save_game(player.global_position, player.rotation.y)
	_close_family_dialogue()
	var milestone_text := "  •  ĐÃ ĐẠT ĐIỀU KIỆN SỰ KIỆN DÃ NGOẠI!" if GameState.is_family_picnic_unlocked() else ""
	_show_message("%s: %s  •  Tình cảm gia đình +%d (hiện %d/100)%s" % [member_name, response, affection_gain, GameState.family_affection, milestone_text])


func _close_family_dialogue() -> void:
	if is_instance_valid(family_dialogue_overlay):
		family_dialogue_overlay.queue_free()
	family_dialogue_overlay = null
