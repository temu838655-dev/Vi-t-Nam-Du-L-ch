extends Node

const SAVE_PATH := "user://viet_nam_hanh_trinh_save.json"
const START_POSITION := Vector3(0, 1.1, 7)

var player_name := "Người chơi"
var selected_career := "Chưa chọn nghề"
var wallet_vnd: int = 500000
var current_location := "Nhà gia đình"
var last_position: Vector3 = START_POSITION
var last_rotation_y: float = 0.0
var has_save := false

func _ready() -> void:
	load_game()

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		has_save = false
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("Không thể mở dữ liệu lưu: %s" % FileAccess.get_open_error())
		return false
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Tệp lưu không hợp lệ; dùng trạng thái mặc định.")
		return false
	var data: Dictionary = parsed
	player_name = str(data.get("player_name", player_name))
	selected_career = str(data.get("selected_career", selected_career))
	wallet_vnd = maxi(0, int(data.get("wallet_vnd", wallet_vnd)))
	current_location = str(data.get("current_location", current_location))
	var position_data: Array = data.get("position", [START_POSITION.x, START_POSITION.y, START_POSITION.z])
	if position_data.size() == 3:
		last_position = Vector3(float(position_data[0]), float(position_data[1]), float(position_data[2]))
	last_rotation_y = float(data.get("rotation_y", 0.0))
	has_save = true
	return true

func save_game(player_position: Vector3, rotation_y: float) -> bool:
	last_position = player_position
	last_rotation_y = rotation_y
	var data := {
		"version": 1,
		"player_name": player_name,
		"selected_career": selected_career,
		"wallet_vnd": wallet_vnd,
		"current_location": current_location,
		"position": [last_position.x, last_position.y, last_position.z],
		"rotation_y": last_rotation_y,
		"saved_at_unix": int(Time.get_unix_time_from_system())
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("Không thể ghi dữ liệu lưu: %s" % FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify(data, "\t"))
	has_save = true
	return true

func earn_money(amount: int) -> void:
	if amount > 0:
		wallet_vnd += amount
