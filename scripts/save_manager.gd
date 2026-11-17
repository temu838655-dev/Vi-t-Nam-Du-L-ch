extends Node

const SAVE_PATH := "user://player_progress.cfg"
const SAVE_VERSION := 2

var profile: Dictionary = {
    "level": 1,
    "money": 5000,
    "gems": 100,
    "location": "Hà Nội",
    "last_scene": "res://scenes/main.tscn",
    "google_linked": false,
    "inventory": {"nuoc_suoi": 1, "ban_do_du_lich": 1},
    "save_version": SAVE_VERSION
}

func has_save() -> bool:
    var config := ConfigFile.new()
    return config.load(SAVE_PATH) == OK and config.has_section("player")

func load_progress() -> Dictionary:
    var config := ConfigFile.new()
    if config.load(SAVE_PATH) != OK:
        return profile.duplicate(true)
    for key in profile.keys():
        profile[key] = config.get_value("player", key, profile[key])
    return profile.duplicate(true)

func save_progress() -> void:
    profile["save_version"] = SAVE_VERSION
    var config := ConfigFile.new()
    for key in profile.keys():
        config.set_value("player", key, profile[key])
    config.save(SAVE_PATH)

func start_new_game() -> void:
    profile = {
        "level": 1,
        "money": 5000,
        "gems": 100,
        "location": "Hà Nội",
        "last_scene": "res://scenes/main.tscn",
        "google_linked": false,
        "inventory": {"nuoc_suoi": 1, "ban_do_du_lich": 1},
        "save_version": SAVE_VERSION
    }
    save_progress()

func update_progress(level: int, money: int, location: String) -> void:
    profile["level"] = level
    profile["money"] = money
    profile["location"] = location
    save_progress()

func is_google_linked() -> bool:
    return bool(profile.get("google_linked", false))
