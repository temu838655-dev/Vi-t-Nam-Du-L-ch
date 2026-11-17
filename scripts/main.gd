extends Node3D

@onready var status_label: Label = $HUD/Status
@onready var interact_button: Button = $HUD/Interact

var player_money: int = 5000
var player_level: int = 1
var current_location: String = "Hà Nội"
var nearby_interactable: Node3D

func _ready() -> void:
    var progress := SaveManager.load_progress()
    player_money = int(progress.get("money", 5000))
    player_level = int(progress.get("level", 1))
    current_location = str(progress.get("location", "Hà Nội"))
    _refresh_hud()
    interact_button.disabled = true
    interact_button.pressed.connect(_on_interact_pressed)

func set_nearby_interactable(target: Node3D) -> void:
    nearby_interactable = target
    interact_button.disabled = target == null
    interact_button.text = "TƯƠNG TÁC" if target == null else str(target.get("action_label"))

func _on_interact_pressed() -> void:
    if is_instance_valid(nearby_interactable):
        nearby_interactable.interact(self)
    else:
        status_label.text = "Chưa có địa điểm tương tác gần bạn."

func add_money(amount: int) -> void:
    player_money = maxi(0, player_money + amount)
    _refresh_hud()
    _save_progress()

func set_location(location_name: String) -> void:
    current_location = location_name
    _refresh_hud()
    _save_progress()

func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
        _save_progress()

func _save_progress() -> void:
    SaveManager.update_progress(player_level, player_money, current_location)

func _refresh_hud() -> void:
    status_label.text = "VIỆT NAM • %s  |  Lv.%d  |  %s ₫" % [current_location, player_level, _format_money(player_money)]

func _format_money(value: int) -> String:
    return "%s" % value
