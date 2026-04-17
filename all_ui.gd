extends Node2D

@onready var endscreen = $UI/wordholder
@onready var gameover = $UI/overscreen
@onready var transparency = $UI/overscreen/Black
@onready var PressEnter :Control = $UI/PressEnterToStart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	endscreen.hide()
	transparency.modulate.a = 0
	gameover.hide()
	PressEnter.hide()
	GlobalSignal.dead.connect(deadscreen)
	GlobalSignal.goal_reached.connect(winscreen)
	GlobalSignal.start_level.connect(start_level)
	GlobalSignal.restart_level.connect(restart)
	GlobalSignal.rocket_launched.connect(hide_press_enter)
	
func start_level():
	PressEnter.show()

func hide_press_enter():
	PressEnter.hide()

func restart():
	PressEnter.show()
	gameover.hide()
	endscreen.hide()

func deadscreen():
	gameover.show()
	var tween = create_tween()
	tween.tween_property(transparency, "modulate:a", 1.0, 0.5)

func winscreen():
	endscreen.show()
	await get_tree().create_timer(2).timeout
	GlobalSignal.emit_signal("change_level")
	endscreen.hide()
