extends Label

func _ready() -> void:
	GlobalSignal.goal_reached.connect(showself)
	hide()

func showself():
	show()
