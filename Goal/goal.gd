class_name Goal extends Node2D

@onready var endscreen = $wordholder

func _ready() -> void:
	endscreen.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("rocket"):
		GlobalSignal.goal_reached.emit()
		endscreen.global_position = Vector2.ZERO
		endscreen.show()
