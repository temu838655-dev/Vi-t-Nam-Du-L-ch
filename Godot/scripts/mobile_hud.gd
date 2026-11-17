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
var ui_root: Control
var shop_overlay: Control
var shop_items_container: VBoxContainer
var current_shop_type := ""
var current_shop_name := ""
var inventory_overlay: Control
var inventory_items_container: VBoxContainer
var current_inventory_tab := "vehicle"

func _ready() -> void:
	add_to_group("shop_ui")
	player = get_parent().get_node_or_null("Player")
	ui_root = Control.new()
	ui_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(ui_root)

	var title := Label.new()
	title.text = "VIỆT NAM – HÀNH TRÌNH BẤT TẬN"
	title.position = Vector2(24, 16)
	title.add_theme_font_size_override("font_size", 22)
	ui_root.add_child(title)

	status_label = Label.new()
	status_label.position = Vector2(24, 48)
	status_label.add_theme_font_size_override("font_size", 18)
	ui_root.add_child(status_label)

	var help := Label.new()
	help.text = "Cần trái: đi bộ / lái xe • Vuốt phải: camera • Cửa hàng: xe máy, thời trang, đặc sản"
	help.position = Vector2(24, 78)
	help.add_theme_font_size_override("font_size", 15)
	ui_root.add_child(help)

	var inventory_button := Button.new()
	inventory_button.text = "TÀI SẢN"
	inventory_button.size = Vector2(136, 52)
	inventory_button.position = Vector2(-154, 18)
	inventory_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	inventory_button.pressed.connect(open_inventory)
	ui_root.add_child(inventory_button)

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
	ui_root.add_child(joystick_base)
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
	ui_root.add_child(jump_button)

	interact_button = Button.new()
	interact_button.text = "TƯƠNG TÁC"
	interact_button.size = Vector2(130, 66)
	interact_button.position = Vector2(-270, -110)
	interact_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	interact_button.pressed.connect(_interact)
	ui_root.add_child(interact_button)

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
	ui_root.add_child(message_label)

	if player and player.has_signal("interaction_message"):
		player.interaction_message.connect(_show_message)
	_update_status()

func _process(_delta: float) -> void:
	_update_status()

func _update_status() -> void:
	if status_label:
		status_label.text = "Ví: %s VNĐ   |   Nghề: %s   |   Ca làm: %d   |   No: %d/100   |   Gia đình: %d/100" % [
			_format_money(GameState.wallet_vnd),
			GameState.selected_career,
			GameState.completed_work_shifts,
			GameState.satiety,
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
