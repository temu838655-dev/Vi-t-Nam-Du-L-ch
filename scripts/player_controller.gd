extends CharacterBody3D

@export var walk_speed: float = 4.2
@export var acceleration: float = 14.0
@export var gravity: float = 18.0
@export var jump_velocity: float = 6.0
@export var camera_sensitivity: float = 0.006

@onready var camera_pivot: Node3D = $CameraPivot
var joystick_vector: Vector2 = Vector2.ZERO
var touch_look_id: int = -1

func _physics_process(delta: float) -> void:
    var keyboard := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    var input_vector := joystick_vector if joystick_vector.length() > 0.08 else keyboard
    var direction := Vector3(input_vector.x, 0.0, input_vector.y)
    direction = direction.rotated(Vector3.UP, camera_pivot.global_rotation.y)
    direction.y = 0.0
    direction = direction.normalized()
    velocity.x = move_toward(velocity.x, direction.x * walk_speed, acceleration * delta)
    velocity.z = move_toward(velocity.z, direction.z * walk_speed, acceleration * delta)
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0.0
    move_and_slide()
    if direction.length() > 0.1:
        var target_yaw := atan2(-direction.x, -direction.z)
        rotation.y = lerp_angle(rotation.y, target_yaw, 8.0 * delta)

func jump() -> void:
    if is_on_floor():
        velocity.y = jump_velocity

func set_joystick_vector(value: Vector2) -> void:
    joystick_vector = value.limit_length(1.0)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed and event.position.x > get_viewport().size.x * 0.45:
            touch_look_id = event.index
        elif not event.pressed and event.index == touch_look_id:
            touch_look_id = -1
    elif event is InputEventScreenDrag and event.index == touch_look_id:
        camera_pivot.rotate_y(-event.relative.x * camera_sensitivity)
        camera_pivot.rotation.x = clampf(camera_pivot.rotation.x - event.relative.y * camera_sensitivity, -0.65, 0.25)
    elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
        camera_pivot.rotate_y(-event.relative.x * camera_sensitivity)
        camera_pivot.rotation.x = clampf(camera_pivot.rotation.x - event.relative.y * camera_sensitivity, -0.65, 0.25)
