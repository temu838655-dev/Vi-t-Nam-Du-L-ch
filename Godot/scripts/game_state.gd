extends Node

const SAVE_PATH := "user://viet_nam_hanh_trinh_save.json"
const START_POSITION := Vector3(0, 1.1, 7)
const CAREERS := ["Tài xế công nghệ", "Nhân viên du lịch", "Đầu bếp", "Nhiếp ảnh gia"]

var player_name := "Người chơi"
var selected_career := "Chưa chọn nghề"
var wallet_vnd: int = 500000
var current_location := "Nhà gia đình"
var family_affection: int = 0
var completed_work_shifts: int = 0
var last_work_day := ""
var last_position: Vector3 = START_POSITION
var last_rotation_y: float = 0.0
var has_save := false

func _ready() -> void:
	load_game()

func start_new_game() -> void:
	player_name = "Người chơi"
	selected_career = "Chưa chọn nghề"
	wallet_vnd = 500000
	current_location = "Nhà gia đình"
	family_affection = 0
	completed_work_shifts = 0
	last_work_day = ""
	last_position = START_POSITION
	last_rotation_y = 0.0
	has_save = false

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
	family_affection = clampi(int(data.get("family_affection", 0)), 0, 100)
	completed_work_shifts = maxi(0, int(data.get("completed_work_shifts", 0)))
	last_work_day = str(data.get("last_work_day", ""))
	var position_value: Variant = data.get("position", [START_POSITION.x, START_POSITION.y, START_POSITION.z])
	last_position = START_POSITION
	if position_value is Array and position_value.size() == 3:
		var candidate := Vector3(float(position_value[0]), float(position_value[1]), float(position_value[2]))
		if _is_valid_saved_position(candidate):
			last_position = candidate
	last_rotation_y = float(data.get("rotation_y", 0.0))
	if not is_finite(last_rotation_y):
		last_rotation_y = 0.0
	has_save = true
	return true

func save_game(player_position: Vector3, rotation_y: float) -> bool:
	last_position = player_position if _is_valid_saved_position(player_position) else START_POSITION
	last_rotation_y = rotation_y if is_finite(rotation_y) else 0.0
	var data := {
		"version": 2,
		"player_name": player_name,
		"selected_career": selected_career,
		"wallet_vnd": wallet_vnd,
		"current_location": current_location,
		"family_affection": family_affection,
		"completed_work_shifts": completed_work_shifts,
		"last_work_day": last_work_day,
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

func choose_next_career() -> String:
	var index := CAREERS.find(selected_career)
	index = (index + 1) % CAREERS.size()
	selected_career = CAREERS[index]
	return selected_career

func complete_work_shift() -> String:
	if selected_career == "Chưa chọn nghề":
		return "Bạn cần chọn nghề trước khi đi làm."
	var today := Time.get_date_string_from_system()
	if last_work_day == today:
		return "Hôm nay bạn đã hoàn thành một ca làm rồi. Hãy nghỉ ngơi và khám phá thêm nhé."
	var salary := 250000
	match selected_career:
		"Tài xế công nghệ":
			salary = 320000
		"Nhân viên du lịch":
			salary = 280000
		"Đầu bếp":
			salary = 300000
		"Nhiếp ảnh gia":
			salary = 350000
	earn_money(salary)
	last_work_day = today
	completed_work_shifts += 1
	return "Bạn hoàn thành ca làm nghề %s và nhận %s VNĐ." % [selected_career, _format_money(salary)]

func talk_with_family(member_name: String) -> String:
	family_affection = mini(100, family_affection + 5)
	if member_name == "Mẹ":
		return "Mẹ: Con đi đâu cũng nhớ ăn uống đầy đủ nhé. Mẹ luôn chờ con về nhà!"
	return "Bố: Cứ mạnh dạn khám phá, nhưng nhớ giữ an toàn và quản lý tiền bạc nhé!"

func _format_money(amount: int) -> String:
	return str(amount)

func _is_valid_saved_position(value: Vector3) -> bool:
	return is_finite(value.x) and is_finite(value.y) and is_finite(value.z) and absf(value.x) <= 45.0 and absf(value.z) <= 45.0 and value.y >= -0.5 and value.y <= 20.0
