extends Node2D

@export var amplitude : float = 6
@export var frequency : float = 1
@export var angleLimit : float = 5

@onready var main = $main
@onready var playbutton = $main/playholder
@onready var quitbutton = $main/quitholder
@onready var rocket = $details/rocket
@onready var spawner = $details/star_spawner
@onready var select = $select
@onready var details = $details
@onready var lost = $main/wordholder/lost
@onready var crocket = $main/wordholder/rocket
@onready var camera = $Camera2D

var star = preload("res://star_menu.tscn")
var clock = 0.0
var dir = 1.0
var timer = 1.0
var spawn_star = true

@export var levels: Array[PackedScene] # Drag your .tscn files here in the Inspector

var current_level_index: int = -1
var active_level_node: Node = null

@onready var level_container = $CurrentLevel

#PRELOAD SOUNDS HERE
var click1 = preload("res://sounds/button1.ogg")
var click2 = preload("res://sounds/button2.ogg")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_R and event.is_released():
			load_level(current_level_index)
			
	if event is InputEventKey:
		if event.keycode == KEY_0 and event.is_released():
			GlobalSignal.print_rocket_amount.emit()


func _ready() -> void:
	main.show()
	select.hide()
	GlobalSignal.change_level.connect(_on_level_complete)
	for button in select.get_children():
		if button is Button:
			button.pressed.connect(_onLevelButtonPressed.bind(button.name))

func _process(delta: float) -> void:
	clock += delta * 2
	playbutton.position.y = sin(clock * frequency) * amplitude
	playbutton.position.x = cos(clock * frequency/2) * amplitude
	_turn_anim()
	rocket.rotation_degrees += 0.5
	timer -= delta
	_title_move(clock)
	if timer <= 0 and spawn_star:
		print ("do the thing")
		spawner.position.y = randf_range(-360, 360)
		timer = randf_range(0.06, 1.2)
		var stars = star.instantiate()
		stars.global_position = spawner.global_position
		get_parent().add_child(stars)

func _turn_anim():
	if playbutton.position.x < 0:
		dir = 0.03
	elif playbutton.position.x > 0:
		dir = -0.03
	playbutton.rotation_degrees = clamp(playbutton.rotation_degrees + dir, -angleLimit, angleLimit)

func _on_playbutton_pressed() -> void:
	main.hide()
	select.show()
	var randSound = randi_range(0, 1)
	match randSound:
		0: play_sound(click1, 1)
		1: play_sound(click2, 1)

func _on_quitbutton_pressed() -> void:
	get_tree().quit()

func _onLevelButtonPressed(level_name: String):
	spawn_star = false
	details.hide()
	camera.enabled = false
	get_tree().call_group("stars", "queue_free")
	print ("load level ", level_name)
	var index = level_name.to_int() - 1 
	load_level(index)
	main.hide()
	select.hide()

func load_level(index: int):
	# 1. Clean up the old level
	GlobalSignal.remove_current_rocket.emit()
	if active_level_node:
		active_level_node.queue_free()
	
	current_level_index = index
	# 2. Instance the new level
	var level_resource = levels[index]
	active_level_node = level_resource.instantiate()
	
	# 3. Add it to the container
	level_container.add_child(active_level_node)
	print("Loaded Level: ", str(index + 1))
	
func _on_level_complete():
	current_level_index += 1
	
	if current_level_index < levels.size():
		call_deferred("load_level", current_level_index)
	else:
		print("You win the whole game!")

func _title_move(clock: float):
	lost.position.y = cos(clock * frequency/2) * amplitude
	crocket.position.y = cos(clock * frequency) * amplitude

func play_sound (stream: AudioStream, pitch: float): # YOU CAN JUST COPY AND PASTE THIS
	var p = AudioStreamPlayer2D.new() # make new audioplayer
	p.stream = stream
	p.pitch_scale = pitch
	add_child(p) # adds to the world
	p.play() # play first
	p.finished.connect(p.queue_free) # remove itself after finished playing
