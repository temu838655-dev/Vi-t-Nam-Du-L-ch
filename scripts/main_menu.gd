extends Control

@onready var continue_button: Button = $CenterPanel/Content/ContinueButton
@onready var start_button: Button = $CenterPanel/Content/StartButton
@onready var google_button: Button = $CenterPanel/Content/GoogleButton
@onready var status_label: Label = $CenterPanel/Content/StatusLabel

func _ready() -> void:
    var saved := SaveManager.has_save()
    continue_button.visible = saved
    start_button.text = "CHƠI MỚI" if saved else "BẮT ĐẦU"
    if SaveManager.is_google_linked():
        _continue_game()
    else:
        google_button.text = "ĐĂNG NHẬP GOOGLE • ĐỒNG BỘ ĐÁM MÂY"

func _on_start_pressed() -> void:
    SaveManager.start_new_game()
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_continue_pressed() -> void:
    _continue_game()

func _continue_game() -> void:
    SaveManager.load_progress()
    get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_google_pressed() -> void:
    status_label.text = "Đăng nhập Google sẽ được bật sau khi cấu hình OAuth và dịch vụ lưu đám mây. Tiến trình khách vẫn được lưu trên thiết bị."
