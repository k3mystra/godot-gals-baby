class_name Goal extends Node2D

@onready var endscreen = $wordholder
@onready var gameover = $overscreen
@onready var transparency = $overscreen/Black

func _ready() -> void:
	endscreen.hide()
	transparency.modulate.a = 0
	gameover.hide()
	GlobalSignal.dead.connect(deadscreen)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("rocket"):
		GlobalSignal.goal_reached.emit()
		endscreen.global_position = Vector2.ZERO
		endscreen.show()

func deadscreen():
	gameover.show()
	var tween = create_tween()
	tween.tween_property(transparency, "modulate:a", 1.0, 0.5)
