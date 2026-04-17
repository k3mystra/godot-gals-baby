extends CanvasLayer

@onready var endscreen = $CenterContainer/wordholder
@onready var gameover = $CenterContainer/overscreen
@onready var transparency = $CenterContainer/overscreen/Black
@onready var PressF : Control = $PressFToStart
@onready var PressSpace : Control = $PressSpaceToThrust
@onready var NextLevel : Control = $NextLevelButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	endscreen.hide()
	transparency.modulate.a = 0
	gameover.hide()
	PressSpace.hide()
	PressF.show()
	NextLevel.hide()
	GlobalSignal.dead.connect(deadscreen)
	GlobalSignal.goal_reached.connect(winscreen)
	GlobalSignal.start_level.connect(start_level)
	GlobalSignal.restart_level.connect(restart)
	GlobalSignal.rocket_launched.connect(hide_press_enter)

func start_level():
	PressF.show()

func hide_press_enter():
	PressF.hide()
	PressSpace.show()

func restart():
	PressF.show()
	gameover.hide()
	endscreen.hide()
	PressSpace.hide()


func deadscreen():
	gameover.show()
	var tween = create_tween()
	tween.tween_property(transparency, "modulate:a", 1.0, 0.5)

func winscreen():
	NextLevel.show()
	endscreen.show()
