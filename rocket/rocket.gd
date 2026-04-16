class_name Rocket extends RigidBody2D

@export var thrust_power: float = 1000.0
var current_state: State = State.READY
var is_thrusting: bool = false
var exhaust : Exhaust

enum State {
	READY,
	IS_LAUNCHED,
	ARRIVED,
	EXPLODE
}

func _ready() -> void:
	freeze = true
	exhaust = $Exhaust
	exhaust.play("empty vroom vroom")
	GlobalSignal.goal_reached.connect(stop_gameplay)

func lift_off():
	freeze = false
	GlobalSignal.rocket_launched.emit()

func stop_gameplay():
	freeze == true
	set_process_input(false)
	set_physics_process(false)	

func _input(event):
	if current_state == State.READY:
		if event.is_action_pressed("ENTER_KEY"):
			lift_off()
			current_state = State.IS_LAUNCHED
	if current_state == State.IS_LAUNCHED:
		if event.is_action_pressed("SPACEBAR_KEY"):
			is_thrusting = true
			exhaust.add_power(is_thrusting)
		elif event.is_action_released("SPACEBAR_KEY"):
			is_thrusting = false
			exhaust.stop_adding_power()

	
func _physics_process(_delta):
	if is_thrusting:
		var forward_direction = transform.x
		apply_central_force(forward_direction * thrust_power)
