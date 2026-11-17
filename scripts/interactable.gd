extends Area3D
class_name WorldInteractable

@export var action_label: String = "TƯƠNG TÁC"
@export_multiline var description: String = "Địa điểm tương tác trong thế giới game."

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
    if body.name == "Player":
        get_tree().current_scene.set_nearby_interactable(self)

func _on_body_exited(body: Node3D) -> void:
    if body.name == "Player":
        get_tree().current_scene.set_nearby_interactable(null)

func interact(game: Node) -> void:
    game.get_node("HUD/Status").text = description
