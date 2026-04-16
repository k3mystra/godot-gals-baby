extends Node2D

@export var amplitude : float = 6
@export var frequency : float = 1
@export var angleLimit : float = 5
@export var levels: Array[PackedScene] # Drag your .tscn files here in the Inspector

@onready var main = $main
@onready var playbutton = $main/playholder
@onready var quitbutton = $main/quitholder
@onready var rocket = $detail/rocket
@onready var spawner = $detail/star_spawner
@onready var select = $select
@onready var level_container = $CurrentLevel
@onready var details = $detail
@onready var camera = $Camera2D
@onready var lost = $main/workholder/lost
@onready var crocket = $main/workholder/rocket

var star = preload("res://star_menu.tscn")
var clock = 0.0
var dir = 1.0
var timer = 1.0
var current_level_index: int = -1
var active_level_node: Node = null
var spawn_star = true


func _ready() -> void:
	details.show()
	main.show()
	select.hide()
	GlobalSignal.level_selected.connect(load_level)
	GlobalSignal.goal_reached.connect(_on_level_complete)
	# im not gonna connect those 10 shits myself
	for button in select.get_children():
		if button is Button:
			button.pressed.connect(_onLevelButtonPressed.bind(button.name))

func _process(delta: float) -> void:
	clock += delta * 2
	playbutton.position.y = sin(clock * frequency) * amplitude
	playbutton.position.x = cos(clock * frequency/2) * amplitude
	_turn_anim()
	_title_move(clock)
	rocket.rotation_degrees += 0.5
	timer -= delta
	if timer <= 0 and spawn_star:
		print ("do the thing")
		spawner.position.y = randf_range(-360, 360)
		timer = randf_range(0, 0.5)
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
		load_level(current_level_index)
	else:
		print("You win the whole game!")

func _title_move(clock: float):
	lost.position.y = cos(clock * frequency/2) * amplitude
	crocket.position.y = cos(clock * frequency) * amplitude
