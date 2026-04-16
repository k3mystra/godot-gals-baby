class_name Rocket extends RigidBody2D

@export var thrust_power: float = 1000.0
var current_state: State = State.READY
var is_thrusting: bool = false
var exhaust : Exhaust
@export var explosion : PackedScene
@onready var gameover = $overscreen

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

func stop_gameplay():
	set_deferred("freeze", true) 
	
	# Do the same for anything else that messes with physics state
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	
	# These are safe to call directly
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	set_process_input(false)
	set_physics_process(false)

var explosion_position = Vector2(-6,-52)

func _on_body_entered(body: Node2D) -> void:
	stop_gameplay()
	var new_explosion = explosion.instantiate() as Explosion
	get_parent().add_child(new_explosion)
	new_explosion.global_position = global_position + explosion_position
	new_explosion.play("3")
	hide()
