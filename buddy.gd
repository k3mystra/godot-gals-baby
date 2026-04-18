extends Node2D

@export var planet_group: String = "planet"
@export var randomizer_chance_per_second: float = 0.9
@onready var planets: Array[Node] = []
@onready var eye1 = $face/anchor/eye1
@onready var eye2 = $face/anchor/eye2
@onready var mouth = $face/mouth
@onready var face = $face
@onready var label = $Label
@onready var anchor = $face/anchor
@onready var vectorzero = $pos0
var dir : float
@export var angleLimit : float
var clock = 0.0
var frequency : float
@export var amplitude : float

func _ready() -> void:
	frequency = randf_range(1, 4)
	amplitude += randf_range(-2, 2)
	planets.clear()
	var selected_planets = get_tree().get_nodes_in_group(planet_group)
	for i in selected_planets:
		if is_instance_valid(i) and not i.is_queued_for_deletion():
			planets.append(i)
	randEye(randi_range(0, 1), randi_range(0, 1))
	randMouth(randi_range(0, 2))

func _process(delta: float) -> void:
	clock += delta
	_eye_move(clock)
	_turn_anim()
	face.position.y = sin(clock * frequency) * amplitude * 2
	face.position.x = cos(clock * frequency/2) * amplitude * 2
	

func _on_timer_timeout() -> void:
	var result: bool = randf() <= randomizer_chance_per_second
	if (result):
		label.text = "I'll change that for you"
		randomize_mass()
		$CloseDialogTimer.start()

func randomize_mass() -> void:
	var amount = randf_range(0, 55)
	var selection = randi_range(0, planets.size() - 1)
	print("Planets size:" + str(planets.size()))
	planets[selection].mass = amount
	planets[selection].update_mass_label()

func _on_close_dialog_timer_timeout() -> void:
	label.text = ""

func _eye_move(clock: float):
	eye1.position.y = cos(clock * frequency/2) * amplitude
	eye2.position.y = cos(clock * frequency) * amplitude

func randEye(type: int, type2: int):
	match type:
		0: eye1.play("eye1")
		1: eye1.play("eye2")

	match type2:
		0: eye2.play("eye1")
		1: eye2.play("eye2")
	
	if eye1.animation == "eye2":
		eye1.scale *= [ -1, 1 ].pick_random()
	
	if eye2.animation == "eye2":
		eye2.scale *= [ -1, 1 ].pick_random()

func randMouth(type: int):
	match type:
		0: mouth.play("mouth1")
		1: mouth.play("mouth2")
		2: mouth.play("mouth3")

func _turn_anim():
	if face.position.x > vectorzero.position.x:
		dir = 0.1
	elif face.position.x < vectorzero.position.x:
		dir = -0.1
	face.rotation_degrees = clamp(face.rotation_degrees + dir, -angleLimit, angleLimit)
