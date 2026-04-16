extends Node2D

@export var amplitude : float = 6
@export var frequency : float = 1
@export var angleLimit : float = 5

@onready var main = $main
@onready var playbutton = $main/playholder
@onready var quitbutton = $main/quitholder
@onready var rocket = $main/rocket
@onready var spawner = $star_spawner
@onready var select = $select

var star = preload("res://star_menu.tscn")
var clock = 0.0
var dir = 1.0
var timer = 1.0

func _ready() -> void:
	main.show()
	select.hide()

func _process(delta: float) -> void:
	clock += delta * 2
	playbutton.position.y = sin(clock * frequency) * amplitude
	playbutton.position.x = cos(clock * frequency/2) * amplitude
	_turn_anim()
	rocket.rotation_degrees += 0.5
	timer -= delta
	if timer <= 0:
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

func _on_quitbutton_pressed() -> void:
	get_tree().quit()
