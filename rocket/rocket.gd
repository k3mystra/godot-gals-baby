class_name Rocket extends RigidBody2D

@export var thrust_power: float = 1000.0
var current_state: State = State.READY
var is_thrusting: bool = false
var exhaust : Exhaust
@export var explosion : PackedScene

@onready var thrusterloop = $thrusterloop

#PRELOAD SOUNDS
var stop = preload("res://sounds/thrustersstop.ogg")
var explode1 = preload("res://sounds/explode1.ogg")
var explode2 = preload("res://sounds/explode2.ogg")
var explode3 = preload("res://sounds/explode3.ogg")
var explode4 = preload("res://sounds/explode4.ogg")
var explode5 = preload("res://sounds/explode5.ogg")


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
	GlobalSignal.out_of_bound.connect(die)

func lift_off():
	freeze = false
	GlobalSignal.rocket_launched.emit()


func _input(event):
	if current_state == State.READY:
		if event is InputEventKey:
			if event.keycode == KEY_F and event.is_released():
				lift_off()
				current_state = State.IS_LAUNCHED
	if current_state == State.IS_LAUNCHED:
		if event.is_action_pressed("SPACEBAR_KEY"):
			is_thrusting = true
			exhaust.add_power(is_thrusting)
		elif event.is_action_released("SPACEBAR_KEY"):
			is_thrusting = false
			play_sound(stop, 1.5)
			exhaust.stop_adding_power()

func _physics_process(_delta):
	if is_thrusting:
		if !thrusterloop.playing:
			thrusterloop.play()
		var forward_direction = transform.x
		apply_central_force(forward_direction * thrust_power)
	else:
		thrusterloop.stop()

func stop_gameplay():
	set_deferred("freeze", true) 
	thrusterloop.stop()
	# Do the same for anything else that messes with physics state
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	
	# These are safe to call directly
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	set_process_input(false)
	set_physics_process(false)

var explosion_position = Vector2(-6,-52)

func die():
	var randSound = randi_range(0, 4)
	thrusterloop.stop()
	match randSound:
		0: play_sound(explode1, 1)
		1: play_sound(explode2, 1)
		2: play_sound(explode3, 1)
		3: play_sound(explode4, 1)
		4: play_sound(explode5, 1)
	var new_explosion = explosion.instantiate() as Explosion
	get_parent().add_child(new_explosion)
	new_explosion.global_position = global_position + explosion_position
	new_explosion.play("3")
	hide()
	GlobalSignal.dead.emit()


func _on_body_entered(body: Node2D) -> void:
	stop_gameplay()
	die()

func play_sound (stream: AudioStream, pitch: float): # YOU CAN JUST COPY AND PASTE THIS
	var p = AudioStreamPlayer2D.new() # make new audioplayer
	p.stream = stream
	p.pitch_scale = pitch + randf_range(-0.3, 0.3)
	add_child(p) # adds to the world
	p.play() # play first
	p.finished.connect(p.queue_free) # remove itself after finished playing
