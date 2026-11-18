extends CanvasLayer

var player: CharacterBody3D
var status_label: Label
var clock_label: Label
var nearby_label: Label
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
var family_dialogue_overlay: Control

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

	var mission := _make_hud_panel(Vector2(22, 136), Vector2(310, 100))
	ui_root.add_child(mission)
	var mission_text := Label.new()
	mission_text.text = "❗ NHIỆM VỤ\nKhám phá khu phố\nTìm người dân và trò chuyện"
	mission_text.add_theme_font_size_override("font_size", 17)
	mission_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mission.add_child(mission_text)

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

	# Location card / minimap placeholder. Replace with a real map texture when map tiles are integrated.
	var map_panel := _make_hud_panel(Vector2(-178, 88), Vector2(156, 118))
	map_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	ui_root.add_child(map_panel)
	var map_label := Label.new()
	map_label.text = "🧭\nBẢN ĐỒ\nKhu dân cư"
	map_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	map_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	map_label.add_theme_font_size_override("font_size", 17)
	map_panel.add_child(map_label)

	# Bottom-left virtual joystick. It can be repositioned by touching the left half of the screen.
	joystick_base = Panel.new()
	joystick_base.name = "JoystickBase"
	joystick_base.size = Vector2(164, 164)
	joystick_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick_base.add_theme_stylebox_override("panel", _hud_style(Color(0.04, 0.14, 0.28, 0.34), Color(0.28, 0.78, 1.0, 0.85), 82))
	ui_root.add_child(joystick_base)
	var initial_viewport_size := get_viewport().get_visible_rect().size
	joystick_base.position = Vector2(34.0, maxf(8.0, initial_viewport_size.y - 198.0))

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
	jump_button.pressed.connect(_jump)
	ui_root.add_child(jump_button)

	interact_button = Button.new()
	interact_button.text = "💬\nTƯƠNG TÁC"
	interact_button.size = Vector2(132, 78)
	interact_button.position = Vector2(-278, -112)
	interact_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	interact_button.add_theme_font_size_override("font_size", 16)
	interact_button.pressed.connect(_interact)
	ui_root.add_child(interact_button)

	var inventory_button := Button.new()
	inventory_button.text = "🎒\nTÚI ĐỒ"
	inventory_button.size = Vector2(112, 78)
	inventory_button.position = Vector2(-132, -104)
	inventory_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	inventory_button.add_theme_font_size_override("font_size", 16)
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

	var panel := PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.position = Vector2(-310, -220)
	panel.size = Vector2(620, 440)
	family_dialogue_overlay.add_child(panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 14)
	panel.add_child(layout)

	var member_name := "Mẹ" if member_role == "mother" else "Bố"
	var heading := Label.new()
	heading.text = "TRÒ CHUYỆN CÙNG " + member_name.to_upper()
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heading.add_theme_font_size_override("font_size", 26)
	layout.add_child(heading)

	var context := Label.new()
	context.text = member_name + " hiện đang: " + (activity if not activity.is_empty() else "ở nhà cùng gia đình") + "."
	context.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	context.add_theme_font_size_override("font_size", 18)
	layout.add_child(context)

	var prompt := Label.new()
	prompt.text = "Bạn muốn nói gì?"
	prompt.add_theme_font_size_override("font_size", 19)
	layout.add_child(prompt)

	var greeting := Button.new()
	greeting.text = "HỎI THĂM SỨC KHỎE"
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
	help.custom_minimum_size = Vector2(0, 58)
	help.pressed.connect(_choose_family_dialogue.bind(member_role, "help", activity))
	layout.add_child(help)

	var advice := Button.new()
	advice.text = "XIN LỜI KHUYÊN CHO CHUYẾN ĐI"
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
					response = "Cảm ơn con đã phụ chuẩn bị bữa ăn. Cả nhà sắp có một bữa cơm ngon rồi!"
				"Dọn dẹp nhà cửa":
					response = "Hai mẹ con/bố con cùng làm nên nhà cửa gọn gàng nhanh hơn nhiều!"
				"Xem TV":
					response = "Ngồi xem cùng gia đình nhé. Có thời gian bên nhau mới quý."
				"Dùng bữa cùng gia đình":
					GameState.satiety = mini(100, GameState.satiety + 12)
					response = "Cả nhà cùng ăn nhé! Bữa cơm hôm nay thật ấm cúng."
				_:
					response = "Cảm ơn con đã quan tâm và giúp đỡ gia đình."
		"advice":
			response = "Con hãy tìm hiểu đường đi, chuẩn bị đủ tiền và luôn đội mũ bảo hiểm khi đi xe máy nhé."
	GameState.family_affection = mini(100, GameState.family_affection + affection_gain)
	if player:
		GameState.save_game(player.global_position, player.rotation.y)
	_close_family_dialogue()
	_show_message("%s: %s  •  Tình cảm gia đình +%d (hiện %d/100)" % [member_name, response, affection_gain, GameState.family_affection])


func _close_family_dialogue() -> void:
	if is_instance_valid(family_dialogue_overlay):
		family_dialogue_overlay.queue_free()
	family_dialogue_overlay = null
