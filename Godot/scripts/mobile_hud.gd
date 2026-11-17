extends CanvasLayer

var player: CharacterBody3D
var status_label: Label
var message_label: Label
var joystick_origin := Vector2.ZERO
var joystick_touch := -1
var look_touch := -1
var move_vector := Vector2.ZERO
var joystick_base: Panel
var joystick_knob: Panel
var interact_button: Button

func _ready() -> void:
	player = get_parent().get_node_or_null("Player")
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	var title := Label.new()
	title.text = "VIỆT NAM – HÀNH TRÌNH BẤT TẬN"
	title.position = Vector2(24, 16)
	title.add_theme_font_size_override("font_size", 22)
	root.add_child(title)

	status_label = Label.new()
	status_label.position = Vector2(24, 48)
	status_label.add_theme_font_size_override("font_size", 18)
	root.add_child(status_label)

	var help := Label.new()
	help.text = "Cần trái: đi bộ / lái xe • Vuốt phải: camera • Đến gần xe máy để sử dụng"
	help.position = Vector2(24, 78)
	help.add_theme_font_size_override("font_size", 15)
	root.add_child(help)

	# A visible, movable virtual joystick follows the first touch on the left side.
	joystick_base = Panel.new()
	joystick_base.name = "JoystickBase"
	joystick_base.size = Vector2(160, 160)
	joystick_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var base_style := StyleBoxFlat.new()
	base_style.bg_color = Color(0.05, 0.08, 0.12, 0.34)
	base_style.border_color = Color(0.82, 0.9, 1.0, 0.48)
	base_style.set_border_width_all(2)
	base_style.set_corner_radius_all(80)
	joystick_base.add_theme_stylebox_override("panel", base_style)
	root.add_child(joystick_base)
	var initial_viewport_size := get_viewport().get_visible_rect().size
	joystick_base.position = Vector2(42.0, maxf(8.0, initial_viewport_size.y - 202.0))

	joystick_knob = Panel.new()
	joystick_knob.name = "JoystickKnob"
	joystick_knob.size = Vector2(66, 66)
	joystick_knob.position = Vector2(47, 47)
	joystick_knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var knob_style := StyleBoxFlat.new()
	knob_style.bg_color = Color(0.72, 0.84, 1.0, 0.78)
	knob_style.border_color = Color(1.0, 1.0, 1.0, 0.85)
	knob_style.set_border_width_all(2)
	knob_style.set_corner_radius_all(33)
	joystick_knob.add_theme_stylebox_override("panel", knob_style)
	joystick_base.add_child(joystick_knob)

	var jump_button := Button.new()
	jump_button.text = "NHẢY"
	jump_button.size = Vector2(105, 66)
	jump_button.position = Vector2(-125, -110)
	jump_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	jump_button.pressed.connect(_jump)
	root.add_child(jump_button)

	interact_button = Button.new()
	interact_button.text = "TƯƠNG TÁC"
	interact_button.size = Vector2(130, 66)
	interact_button.position = Vector2(-270, -110)
	interact_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	interact_button.pressed.connect(_interact)
	root.add_child(interact_button)

	message_label = Label.new()
	message_label.position = Vector2(-280, -205)
	message_label.size = Vector2(560, 72)
	message_label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message_label.add_theme_font_size_override("font_size", 17)
	message_label.add_theme_color_override("font_color", Color(1, 1, 1))
	message_label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	message_label.add_theme_constant_override("shadow_offset_x", 2)
	message_label.add_theme_constant_override("shadow_offset_y", 2)
	root.add_child(message_label)

	if player and player.has_signal("interaction_message"):
		player.interaction_message.connect(_show_message)
	_update_status()

func _process(_delta: float) -> void:
	_update_status()

func _update_status() -> void:
	if status_label:
		status_label.text = "Ví: %s VNĐ   |   Nghề: %s   |   Ca làm: %d   |   Gia đình: %d/100" % [
			_format_money(GameState.wallet_vnd),
			GameState.selected_career,
			GameState.completed_work_shifts,
			GameState.family_affection
		]
	if interact_button and player and player.has_method("is_riding_vehicle"):
		interact_button.text = "XUỐNG XE" if player.is_riding_vehicle() else "TƯƠNG TÁC"

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
	if player and player.is_on_floor():
		player.velocity.y = 6.0

func _interact() -> void:
	if player:
		player.interact_nearby()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < get_viewport().get_visible_rect().size.x * 0.45 and joystick_touch == -1:
				joystick_touch = event.index
				var viewport_size := get_viewport().get_visible_rect().size
				var base_position: Vector2 = event.position - joystick_base.size * 0.5
				base_position.x = clampf(base_position.x, 8.0, viewport_size.x - joystick_base.size.x - 8.0)
				base_position.y = clampf(base_position.y, 8.0, viewport_size.y - joystick_base.size.y - 8.0)
				joystick_base.position = base_position
				joystick_origin = event.position
				joystick_knob.position = (joystick_base.size - joystick_knob.size) * 0.5
			elif look_touch == -1:
				look_touch = event.index
		else:
			if event.index == joystick_touch:
				joystick_touch = -1
				if player:
					player.set_mobile_move(Vector2.ZERO)
				move_vector = Vector2.ZERO
				if is_instance_valid(joystick_knob):
					joystick_knob.position = (joystick_base.size - joystick_knob.size) * 0.5
			if event.index == look_touch:
				look_touch = -1
	elif event is InputEventScreenDrag:
		if event.index == joystick_touch:
			move_vector = (event.position - joystick_origin).limit_length(58.0) / 58.0
			joystick_knob.position = (joystick_base.size - joystick_knob.size) * 0.5 + move_vector * 46.0
			if player:
				player.set_mobile_move(move_vector)
		elif event.index == look_touch:
			if player:
				player.add_mobile_look(event.relative)
