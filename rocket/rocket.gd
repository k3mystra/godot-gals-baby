class_name Rocket extends RigidBody2D

@export var thrust_power: float = 1000.0
var current_state: State
var is_thrusting: bool = false

enum State {
	READY,
	IS_LAUNCHED,
	ARRIVED,
	EXPLODE
}

func _input(event):
	# Toggle thrust when pressing Enter
	if event.is_action_pressed("SPACEBAR_KEY"):
		is_thrusting = true
	elif event.is_action_released("SPACEBAR_KEY"):
		is_thrusting = false
	
func _physics_process(_delta):
	if is_thrusting:
		var forward_direction = transform.x
		apply_central_force(forward_direction * thrust_power)
