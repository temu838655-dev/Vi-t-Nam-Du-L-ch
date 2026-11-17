extends Node3D

@onready var status_label: Label = $HUD/Status
@onready var interact_button: Button = $HUD/Interact

var player_money: int = 250000
var nearby_interactable: Node3D

func _ready() -> void:
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

func _refresh_hud() -> void:
    status_label.text = "VIỆT NAM • HÀNH TRÌNH BẤT TẬN  |  %s ₫" % _format_money(player_money)

func _format_money(value: int) -> String:
    return "%s" % value
