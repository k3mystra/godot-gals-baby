class_name Goal extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("rocket"):
		GlobalSignal.goal_reached.emit()
