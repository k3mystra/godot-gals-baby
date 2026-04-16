extends Node2D

@export var levels: Array[PackedScene] # Drag your .tscn files here in the Inspector

var current_level_index: int = -1
var active_level_node: Node = null

@onready var level_container = $CurrentLevel

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_1 and event.is_released():
			load_level(0)
		if event.keycode == KEY_2 and event.is_released():
			load_level(1)



func _ready():
	GlobalSignal.level_selected.connect(load_level)
	GlobalSignal.goal_reached.connect(_on_level_complete)

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
