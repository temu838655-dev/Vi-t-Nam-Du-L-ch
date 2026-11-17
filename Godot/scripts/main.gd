extends Node3D

const PLAYER_SCRIPT := preload("res://scripts/player.gd")
const HUD_SCRIPT := preload("res://scripts/mobile_hud.gd")
const DEFAULT_START := Vector3(0, 1.1, 7)

var player: CharacterBody3D
var autosave_elapsed := 0.0

func _ready() -> void:
	_build_prototype_world()
	player = CharacterBody3D.new()
	player.name = "Player"
	player.set_script(PLAYER_SCRIPT)
	add_child(player)
	if GameState.has_save:
		player.position = GameState.last_position
		player.rotation.y = GameState.last_rotation_y
	else:
		player.position = DEFAULT_START
	var hud := CanvasLayer.new()
	hud.name = "MobileHUD"
	hud.set_script(HUD_SCRIPT)
	add_child(hud)

func _process(delta: float) -> void:
	autosave_elapsed += delta
	if autosave_elapsed >= 15.0:
		autosave_elapsed = 0.0
		_save_current_game()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		_save_current_game()

func _save_current_game() -> void:
	if is_instance_valid(player):
		GameState.save_game(player.global_position, player.rotation.y)

func _build_prototype_world() -> void:
	_add_box("Ground", Vector3(0, -0.25, 0), Vector3(100, 0.5, 100), Color(0.22, 0.42, 0.25))
	# Starter family home: intentionally a greybox, to be replaced with authored Vietnamese assets.
	_add_box("FamilyHome", Vector3(0, 1.5, -8), Vector3(9, 3, 7), Color(0.82, 0.72, 0.55))
	_add_box("HomeRoof", Vector3(0, 3.5, -8), Vector3(10, 1, 8), Color(0.48, 0.18, 0.13))
	_add_box("Road", Vector3(0, 0.02, 8), Vector3(7, 0.08, 70), Color(0.12, 0.12, 0.13))
	for i in range(5):
		_add_box("StreetBuilding_%02d" % i, Vector3(-13 + i * 6.5, 2, -2 - (i % 2) * 10), Vector3(4, 4, 5), Color(0.72, 0.62, 0.48))
	var label := Label3D.new()
	label.text = "NHÀ GIA ĐÌNH"
	label.position = Vector3(0, 5.2, -8)
	label.font_size = 48
	add_child(label)

func _add_box(object_name: String, at: Vector3, dimensions: Vector3, color: Color) -> void:
	var body := StaticBody3D.new()
	body.name = object_name
	body.position = at
	var mesh := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = dimensions
	mesh.mesh = box
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	mesh.material_override = material
	body.add_child(mesh)
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = dimensions
	collision.shape = shape
	body.add_child(collision)
	add_child(body)
