extends CanvasLayer

var player: CharacterBody3D
var joystick_origin := Vector2.ZERO
var joystick_touch := -1
var look_touch := -1
var last_look := Vector2.ZERO
var move_vector := Vector2.ZERO

func _ready() -> void:
	player = get_parent().get_node_or_null("Player")
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	var hint := Label.new()
	hint.text = "VIỆT NAM – HÀNH TRÌNH BẤT TẬN  |  BẢN THỬ NGHIỆM"
	hint.position = Vector2(24, 20)
	hint.add_theme_font_size_override("font_size", 22)
	root.add_child(hint)
	var help := Label.new()
	help.text = "Chạm bên trái để di chuyển • Vuốt bên phải để xoay camera"
	help.position = Vector2(24, 54)
	help.add_theme_font_size_override("font_size", 17)
	root.add_child(help)
	var pad := ColorRect.new()
	pad.color = Color(0.05, 0.08, 0.12, 0.28)
	pad.position = Vector2(35, -190)
	pad.size = Vector2(170, 150)
	pad.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	pad.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(pad)
	var jump_button := Button.new()
	jump_button.text = "NHẢY"
	jump_button.size = Vector2(105, 70)
	jump_button.position = Vector2(-145, -125)
	jump_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	jump_button.pressed.connect(_jump)
	root.add_child(jump_button)

func _jump() -> void:
	if player and player.is_on_floor():
		player.velocity.y = 6.0

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < get_viewport().get_visible_rect().size.x * 0.45 and joystick_touch == -1:
				joystick_touch = event.index
				joystick_origin = event.position
			elif look_touch == -1:
				look_touch = event.index
				last_look = event.position
		else:
			if event.index == joystick_touch:
				joystick_touch = -1
				move_vector = Vector2.ZERO
				if player: player.set_mobile_move(Vector2.ZERO)
			if event.index == look_touch:
				look_touch = -1
	elif event is InputEventScreenDrag:
		if event.index == joystick_touch:
			move_vector = (event.position - joystick_origin).limit_length(90.0) / 90.0
			if player: player.set_mobile_move(move_vector)
		elif event.index == look_touch:
			if player: player.add_mobile_look(event.relative)
