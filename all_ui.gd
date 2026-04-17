extends Node2D

@onready var endscreen = $UI/wordholder
@onready var gameover = $UI/overscreen
@onready var transparency = $UI/overscreen/Black

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	endscreen.hide()
	transparency.modulate.a = 0
	gameover.hide()
	GlobalSignal.dead.connect(deadscreen)
	GlobalSignal.goal_reached.connect(winscreen)

func deadscreen():
	gameover.show()
	var tween = create_tween()
	tween.tween_property(transparency, "modulate:a", 1.0, 0.5)

func winscreen():
	endscreen.show()
	await get_tree().create_timer(2).timeout
	GlobalSignal.emit_signal("change_level")
	endscreen.hide()
