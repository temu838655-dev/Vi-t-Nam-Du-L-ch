extends Control

@export var radius: float = 82.0
@export var knob_radius: float = 34.0
var active_touch: int = -1
var knob_position: Vector2
var output_vector: Vector2 = Vector2.ZERO
var player: CharacterBody3D

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_STOP
    knob_position = size * 0.5
    player = get_tree().current_scene.get_node_or_null("Player")
    queue_redraw()

func _draw() -> void:
    var center := size * 0.5
    draw_circle(center, radius, Color(0.04, 0.07, 0.1, 0.38))
    draw_arc(center, radius, 0, TAU, 64, Color(1, 1, 1, 0.55), 3.0)
    draw_circle(knob_position, knob_radius, Color(0.9, 0.95, 1, 0.78))
    draw_arc(knob_position, knob_radius, 0, TAU, 48, Color(1, 1, 1, 0.9), 2.0)

func _gui_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed and active_touch == -1:
            active_touch = event.index
            _update_knob(make_canvas_position_local(event.position))
        elif not event.pressed and event.index == active_touch:
            active_touch = -1
            _reset_joystick()
    elif event is InputEventScreenDrag and event.index == active_touch:
        _update_knob(make_canvas_position_local(event.position))
    elif event is InputEventMouseButton:
        if event.pressed:
            _update_knob(event.position)
        else:
            _reset_joystick()
    elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
        _update_knob(event.position)

func _update_knob(point: Vector2) -> void:
    var center := size * 0.5
    var offset := (point - center).limit_length(radius)
    knob_position = center + offset
    output_vector = Vector2(offset.x / radius, offset.y / radius)
    if is_instance_valid(player):
        player.set_joystick_vector(output_vector)
    queue_redraw()

func _reset_joystick() -> void:
    knob_position = size * 0.5
    output_vector = Vector2.ZERO
    if is_instance_valid(player):
        player.set_joystick_vector(Vector2.ZERO)
    queue_redraw()
