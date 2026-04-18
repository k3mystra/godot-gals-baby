extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("rocket"):
		GlobalSignal.out_of_bound.emit()
