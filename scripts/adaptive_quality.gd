extends Node

enum Quality { LOW, BALANCED, HIGH }
var current_quality: Quality = Quality.BALANCED
var _sample_time: float = 0.0

func _ready() -> void:
    _select_initial_profile()

func _process(delta: float) -> void:
    _sample_time += delta
    if _sample_time < 3.0:
        return
    _sample_time = 0.0
    _adapt_to_frame_rate()

func _select_initial_profile() -> void:
    var cores := OS.get_processor_count()
    if cores <= 4:
        current_quality = Quality.LOW
    elif cores >= 8:
        current_quality = Quality.HIGH
    else:
        current_quality = Quality.BALANCED

func _adapt_to_frame_rate() -> void:
    var fps := Engine.get_frames_per_second()
    if fps > 0 and fps < 28:
        current_quality = Quality.LOW
    elif fps >= 55 and OS.get_processor_count() >= 8:
        current_quality = Quality.HIGH

func get_profile_name() -> String:
    match current_quality:
        Quality.LOW:
            return "Tiết kiệm"
        Quality.HIGH:
            return "Chất lượng cao"
        _:
            return "Cân bằng"
