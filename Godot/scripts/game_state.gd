extends Node

const SAVE_PATH := "user://viet_nam_hanh_trinh_save.json"
const START_POSITION := Vector3(0, 1.1, 7)
const CAREERS := ["Tài xế công nghệ", "Nhân viên du lịch", "Đầu bếp", "Nhiếp ảnh gia"]

# Giá trong game là giá mô phỏng để cân bằng trải nghiệm, không phải báo giá đại lý.
const VEHICLE_CATALOG := [
	{"id":"wave_alpha","name":"Honda Wave Alpha 110","price":18939000,"description":"Xe số phổ thông, gọn nhẹ cho phố và đường quê.","color":Color(0.82,0.08,0.06)},
	{"id":"vision","name":"Honda Vision","price":31310000,"description":"Xe tay ga đô thị nhỏ gọn, cốp rộng.","color":Color(0.12,0.14,0.18)},
	{"id":"air_blade","name":"Honda Air Blade 125","price":42012000,"description":"Xe tay ga thể thao cho di chuyển hằng ngày.","color":Color(0.08,0.12,0.2)},
	{"id":"sh160i","name":"Honda SH160i","price":102190000,"description":"Xe tay ga cao cấp, dáng lớn.","color":Color(0.72,0.74,0.76)},
	{"id":"sirius_fi","name":"Yamaha Sirius FI","price":21208000,"description":"Xe số tiết kiệm, quen thuộc ở nhiều tỉnh thành.","color":Color(0.08,0.2,0.68)},
	{"id":"exciter_155","name":"Yamaha Exciter 155 VVA","price":55000000,"description":"Xe côn tay phong cách thể thao.","color":Color(0.08,0.25,0.78)},
	{"id":"lead_125","name":"Honda LEAD 125","price":39557000,"description":"Xe tay ga tiện dụng, nhiều không gian chứa đồ.","color":Color(0.62,0.42,0.28)},
	{"id":"janus","name":"Yamaha Janus","price":29151000,"description":"Xe tay ga nhỏ gọn, thiết kế trẻ trung.","color":Color(0.76,0.32,0.48)},
	{"id":"future_125","name":"Honda Future 125 FI","price":32000000,"description":"Xe số phổ thông dáng thanh lịch, phù hợp đi xa.","color":Color(0.12,0.18,0.32)},
	{"id":"winner_x","name":"Honda Winner X","price":46000000,"description":"Xe côn tay thể thao cho người thích lái chủ động.","color":Color(0.78,0.08,0.06)},
	{"id":"grande","name":"Yamaha Grande","price":46000000,"description":"Xe tay ga thanh lịch, kiểu dáng đô thị.","color":Color(0.68,0.58,0.42)}
]

const CLOTHING_CATALOG := [
	{"id":"ao_thun_basic","name":"Áo thun basic","price":0,"description":"Áo thun mặc thường ngày.","slot":"top","color":Color(0.12,0.32,0.72)},
	{"id":"ao_so_mi","name":"Áo sơ mi trắng","price":220000,"description":"Sơ mi sáng màu, phù hợp đi làm và đi chơi.","slot":"top","color":Color(0.88,0.88,0.82)},
	{"id":"hoodie","name":"Áo hoodie","price":350000,"description":"Áo nỉ có mũ cho ngày mát trời.","slot":"top","color":Color(0.28,0.3,0.34)},
	{"id":"ao_khoac_chong_nang","name":"Áo khoác chống nắng","price":280000,"description":"Áo khoác nhẹ thường dùng khi đi xe máy.","slot":"top","color":Color(0.45,0.62,0.68)},
	{"id":"ao_polo","name":"Áo polo","price":260000,"description":"Áo polo gọn gàng, mặc đi làm hoặc đi chơi.","slot":"top","color":Color(0.12,0.48,0.38)},
	{"id":"ao_khoac_jean","name":"Áo khoác jean","price":480000,"description":"Áo khoác denim phong cách đường phố.","slot":"top","color":Color(0.16,0.28,0.52)},
	{"id":"quan_short","name":"Quần short kaki","price":240000,"description":"Quần short mặc thường ngày.","slot":"bottom","color":Color(0.52,0.42,0.28)},
	{"id":"quan_jeans","name":"Quần jeans xanh","price":0,"description":"Quần jeans cơ bản.","slot":"bottom","color":Color(0.12,0.22,0.48)},
	{"id":"quan_tay","name":"Quần tây đen","price":280000,"description":"Quần dài lịch sự.","slot":"bottom","color":Color(0.08,0.09,0.12)},
	{"id":"sneakers","name":"Giày sneaker trắng","price":550000,"description":"Giày thể thao dùng hằng ngày.","slot":"shoes","color":Color(0.9,0.9,0.86)},
	{"id":"dep_sandal","name":"Dép sandal","price":150000,"description":"Dép thoải mái khi đi gần nhà.","slot":"shoes","color":Color(0.28,0.2,0.14)},
	{"id":"non_bao_hiem","name":"Nón bảo hiểm 3/4","price":180000,"description":"Phụ kiện đi xe máy; bản game mô phỏng.","slot":"headwear","color":Color(0.86,0.12,0.08)},
	{"id":"ao_dai","name":"Áo dài truyền thống","price":650000,"description":"Trang phục truyền thống Việt Nam.","slot":"fullbody","color":Color(0.72,0.12,0.2)},
	{"id":"ao_ba_ba","name":"Áo bà ba","price":420000,"description":"Trang phục gợi nét đời sống Nam Bộ.","slot":"fullbody","color":Color(0.16,0.42,0.3)}
]

const FOOD_CATALOG := [
	{"id":"pho_bo","name":"Phở bò","price":55000,"description":"Món phở nước quen thuộc của miền Bắc.","region":"Miền Bắc","satiety":28},
	{"id":"banh_mi","name":"Bánh mì thịt","price":25000,"description":"Bánh mì giòn với nhân thịt và rau.","region":"Khắp Việt Nam","satiety":18},
	{"id":"bun_bo_hue","name":"Bún bò Huế","price":60000,"description":"Món bún đậm vị đặc trưng xứ Huế.","region":"Miền Trung","satiety":30},
	{"id":"com_tam","name":"Cơm tấm sườn","price":55000,"description":"Cơm tấm ăn cùng sườn nướng và đồ chua.","region":"Nam Bộ","satiety":32},
	{"id":"banh_xeo","name":"Bánh xèo","price":50000,"description":"Bánh vàng giòn, ăn kèm rau sống.","region":"Miền Trung / Nam Bộ","satiety":25},
	{"id":"goi_cuon","name":"Gỏi cuốn","price":40000,"description":"Cuốn tươi với rau, bún và nước chấm.","region":"Nam Bộ","satiety":20},
	{"id":"cao_lau","name":"Cao lầu Hội An","price":60000,"description":"Món mì đặc trưng phố cổ Hội An.","region":"Quảng Nam","satiety":28},
	{"id":"bun_cha","name":"Bún chả Hà Nội","price":55000,"description":"Bún ăn với chả nướng và nước chấm.","region":"Hà Nội","satiety":28},
	{"id":"ca_phe_sua_da","name":"Cà phê sữa đá","price":25000,"description":"Cà phê phin cùng sữa đặc và đá.","region":"Khắp Việt Nam","satiety":8},
	{"id":"che_ba_mau","name":"Chè ba màu","price":30000,"description":"Món chè mát với đậu và thạch.","region":"Nam Bộ","satiety":12},
	{"id":"banh_pia","name":"Bánh pía Sóc Trăng","price":60000,"description":"Đặc sản bánh pía nhân đậu xanh, sầu riêng.","region":"Sóc Trăng","satiety":0,"packaged":true},
	{"id":"nem_chua","name":"Nem chua Thanh Hóa","price":50000,"description":"Đặc sản lên men truyền thống.","region":"Thanh Hóa","satiety":0,"packaged":true},
	{"id":"cha_muc","name":"Chả mực Hạ Long","price":85000,"description":"Đặc sản chả mực giã tay vùng biển.","region":"Quảng Ninh","satiety":24},
	{"id":"banh_dau_xanh","name":"Bánh đậu xanh","price":40000,"description":"Bánh ngọt truyền thống dùng cùng trà.","region":"Hải Dương","satiety":0,"packaged":true},
	{"id":"me_xung","name":"Mè xửng","price":45000,"description":"Kẹo mè xửng dẻo thơm.","region":"Huế","satiety":0,"packaged":true},
	{"id":"keo_cu_do","name":"Kẹo cu đơ","price":35000,"description":"Kẹo lạc mạch nha giòn thơm.","region":"Hà Tĩnh","satiety":0,"packaged":true},
	{"id":"nuoc_mam_phu_quoc","name":"Nước mắm Phú Quốc","price":95000,"description":"Đặc sản nước mắm truyền thống đóng chai.","region":"Phú Quốc, Kiên Giang","satiety":0,"packaged":true},
	{"id":"banh_trang_tay_ninh","name":"Bánh tráng phơi sương","price":45000,"description":"Đặc sản bánh tráng dùng cuốn rau và thịt.","region":"Tây Ninh","satiety":0,"packaged":true},
	{"id":"ca_phe_buon_ma_thuot","name":"Cà phê Buôn Ma Thuột","price":65000,"description":"Cà phê rang xay đặc trưng Tây Nguyên.","region":"Đắk Lắk","satiety":0,"packaged":true},
	{"id":"dua_sap_tra_vinh","name":"Dừa sáp","price":75000,"description":"Trái cây đặc sản có cơm dừa dẻo.","region":"Trà Vinh","satiety":18},
	{"id":"hat_dieu_binh_phuoc","name":"Hạt điều rang","price":60000,"description":"Hạt điều rang giòn, đóng gói mang đi.","region":"Bình Phước","satiety":0,"packaged":true},
	{"id":"sau_rieng_cai_mon","name":"Sầu riêng Cái Mơn","price":90000,"description":"Trái cây đặc sản miền sông nước.","region":"Bến Tre","satiety":22}
]

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
var owned_vehicles: Array = []
var selected_vehicle := ""
var owned_clothes: Array = ["ao_thun_basic", "quan_jeans"]
var equipped_clothes: Dictionary = {"top":"ao_thun_basic","bottom":"quan_jeans","shoes":"","headwear":"","fullbody":""}
var satiety: int = 100
var food_history: Array = []
var owned_specialties: Array = []
var world_time_seconds: float = 8.0 * 60.0
var family_interaction_log: Dictionary = {}

func advance_world_clock(delta: float) -> void:
	world_time_seconds = fposmod(world_time_seconds + delta, 240.0)

func get_world_clock_text() -> String:
	var game_minutes := int(fposmod(world_time_seconds, 240.0) * 6.0)
	var hour := int(floor(float(game_minutes) / 60.0))
	var minute := game_minutes % 60
	return "%02d:%02d" % [hour, minute]

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
	owned_vehicles = []
	selected_vehicle = ""
	owned_clothes = ["ao_thun_basic", "quan_jeans"]
	equipped_clothes = {"top":"ao_thun_basic","bottom":"quan_jeans","shoes":"","headwear":"","fullbody":""}
	satiety = 100
	food_history = []
	owned_specialties = []
	world_time_seconds = 8.0 * 60.0
	family_interaction_log = {}
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
	var vehicles_value: Variant = data.get("owned_vehicles", [])
	if vehicles_value is Array:
		owned_vehicles = vehicles_value.duplicate()
	selected_vehicle = str(data.get("selected_vehicle", ""))
	var clothes_value: Variant = data.get("owned_clothes", owned_clothes)
	if clothes_value is Array:
		owned_clothes = clothes_value.duplicate()
	var equipped_value: Variant = data.get("equipped_clothes", equipped_clothes)
	if equipped_value is Dictionary:
		equipped_clothes = equipped_value.duplicate(true)
	for slot in ["top", "bottom", "shoes", "headwear", "fullbody"]:
		if not equipped_clothes.has(slot):
			equipped_clothes[slot] = ""
	satiety = clampi(int(data.get("satiety", 100)), 0, 100)
	var history_value: Variant = data.get("food_history", [])
	if history_value is Array:
		food_history = history_value.duplicate()
	var specialties_value: Variant = data.get("owned_specialties", [])
	if specialties_value is Array:
		owned_specialties = specialties_value.duplicate()
	world_time_seconds = fposmod(float(data.get("world_time_seconds", 8.0 * 60.0)), 240.0)
	var family_log_value: Variant = data.get("family_interaction_log", {})
	family_interaction_log = family_log_value.duplicate(true) if family_log_value is Dictionary else {}
	has_save = true
	return true

func save_game(player_position: Vector3, rotation_y: float) -> bool:
	last_position = player_position if _is_valid_saved_position(player_position) else START_POSITION
	last_rotation_y = rotation_y if is_finite(rotation_y) else 0.0
	var data := {
		"version": 3,
		"player_name": player_name,
		"selected_career": selected_career,
		"wallet_vnd": wallet_vnd,
		"current_location": current_location,
		"family_affection": family_affection,
		"completed_work_shifts": completed_work_shifts,
		"last_work_day": last_work_day,
		"owned_vehicles": owned_vehicles,
		"selected_vehicle": selected_vehicle,
		"owned_clothes": owned_clothes,
		"equipped_clothes": equipped_clothes,
		"satiety": satiety,
		"food_history": food_history,
		"owned_specialties": owned_specialties,
		"world_time_seconds": world_time_seconds,
		"family_interaction_log": family_interaction_log,
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

func get_catalog(shop_type: String) -> Array:
	match shop_type:
		"vehicle":
			return VEHICLE_CATALOG.duplicate(true)
		"clothing":
			return CLOTHING_CATALOG.duplicate(true)
		"food":
			return FOOD_CATALOG.duplicate(true)
	return []

func get_item(shop_type: String, item_id: String) -> Dictionary:
	for item in get_catalog(shop_type):
		if str(item.get("id", "")) == item_id:
			return item
	return {}

func is_item_owned(shop_type: String, item_id: String) -> bool:
	match shop_type:
		"vehicle":
			return owned_vehicles.has(item_id)
		"clothing":
			return owned_clothes.has(item_id)
		"food":
			return owned_specialties.has(item_id)
	return false

func purchase_item(shop_type: String, item_id: String) -> Dictionary:
	var item := get_item(shop_type, item_id)
	if item.is_empty():
		return {"ok":false,"message":"Không tìm thấy sản phẩm này.","item":{}}
	if shop_type == "vehicle" and owned_vehicles.has(item_id):
		selected_vehicle = item_id
		return {"ok":true,"message":"Bạn đã sở hữu %s. Xe đã được chọn." % item.name,"item":item,"already_owned":true}
	if shop_type == "clothing" and owned_clothes.has(item_id):
		_equip_clothing(item)
		return {"ok":true,"message":"Đã mặc %s." % item.name,"item":item,"already_owned":true}
	if shop_type == "food" and bool(item.get("packaged", false)) and owned_specialties.has(item_id):
		return {"ok":true,"message":"Bạn đã có đặc sản %s trong hành trang." % item.name,"item":item,"already_owned":true}
	var price := int(item.get("price", 0))
	if wallet_vnd < price:
		return {"ok":false,"message":"Bạn chưa đủ tiền. Cần %s VNĐ, hiện có %s VNĐ." % [_format_money(price), _format_money(wallet_vnd)],"item":item}
	wallet_vnd -= price
	match shop_type:
		"vehicle":
			owned_vehicles.append(item_id)
			selected_vehicle = item_id
			return {"ok":true,"message":"Đã mua %s. Xe mới đã được thêm vào tài sản." % item.name,"item":item}
		"clothing":
			owned_clothes.append(item_id)
			_equip_clothing(item)
			return {"ok":true,"message":"Đã mua và mặc %s." % item.name,"item":item}
		"food":
			if bool(item.get("packaged", false)):
				owned_specialties.append(item_id)
				return {"ok":true,"message":"Đã mua đặc sản %s (%s) và cất vào hành trang." % [item.name, item.get("region", "Việt Nam")],"item":item}
			satiety = mini(100, satiety + int(item.get("satiety", 15)))
			food_history.append(item_id)
			return {"ok":true,"message":"Bạn đã thưởng thức %s (%s). Độ no: %d/100." % [item.name, item.get("region", "Việt Nam"), satiety],"item":item}
	return {"ok":false,"message":"Giao dịch không hợp lệ.","item":item}

func _equip_clothing(item: Dictionary) -> void:
	var slot := str(item.get("slot", "top"))
	equipped_clothes[slot] = str(item.get("id", ""))

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

func has_family_interaction(member_role: String, choice: String) -> bool:
	var key := Time.get_date_string_from_system() + "|" + member_role + "|" + choice
	return bool(family_interaction_log.get(key, false))

func get_family_relationship_title() -> String:
	if family_affection >= 75:
		return "Gia đình gắn bó"
	if family_affection >= 50:
		return "Thân thiết"
	if family_affection >= 25:
		return "Ấm áp"
	return "Mới bắt đầu gắn kết"

func register_family_interaction(member_role: String, choice: String) -> bool:
	var today := Time.get_date_string_from_system()
	var key := today + "|" + member_role + "|" + choice
	if bool(family_interaction_log.get(key, false)):
		return false
	# Keep only today's entries so the save file does not grow forever.
	for old_key in family_interaction_log.keys():
		if not str(old_key).begins_with(today + "|"):
			family_interaction_log.erase(old_key)
	family_interaction_log[key] = true
	return true

func talk_with_family(member_name: String) -> String:
	family_affection = mini(100, family_affection + 5)
	if member_name == "Mẹ":
		return "Mẹ: Con đi đâu cũng nhớ ăn uống đầy đủ nhé. Mẹ luôn chờ con về nhà!"
	return "Bố: Cứ mạnh dạn khám phá, nhưng nhớ giữ an toàn và quản lý tiền bạc nhé!"

func _format_money(amount: int) -> String:
	return _format_grouped_money(amount)

func _format_grouped_money(amount: int) -> String:
	var raw := str(amount)
	var result := ""
	for i in range(raw.length()):
		result += raw[i]
		var remaining := raw.length() - i - 1
		if remaining > 0 and remaining % 3 == 0:
			result += "."
	return result

func _is_valid_saved_position(value: Vector3) -> bool:
	return is_finite(value.x) and is_finite(value.y) and is_finite(value.z) and absf(value.x) <= 45.0 and absf(value.z) <= 45.0 and value.y >= -0.5 and value.y <= 20.0
