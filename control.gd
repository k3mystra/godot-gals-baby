extends Control

@export var amplitude : float
@export var frequency : float
@export var angleLimit : float
@onready var playbutton = $playholder
@onready var quitbutton = $quitbutton
var clock = 0.0
var dir = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	clock += delta * 2
	playbutton.position.y = sin(clock * frequency) * amplitude
	playbutton.position.x = cos(clock * frequency/2) * amplitude
	_turn_anim()


func _turn_anim():
	if playbutton.position.x < 0:
		dir = 0.05
	elif playbutton.position.x > 0:
		dir = -0.05
	playbutton.rotation_degrees = clamp(playbutton.rotation_degrees + dir, -angleLimit, angleLimit)


func _on_playbutton_pressed() -> void:
	pass # Replace with function body.
