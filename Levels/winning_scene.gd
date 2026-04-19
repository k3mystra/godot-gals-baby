extends Node2D

@onready var lost = $wordholder/lost
@onready var crocket = $wordholder/rocket
@onready var YOU = $wordholder2/YOU
@onready var WON = $wordholder2/WON
@export var amplitude : float = 6
@export var frequency : float = 1
@export var angleLimit : float = 5
var clock = 0.0

func _title_move(clock: float):
	lost.position.y = cos(clock * frequency/2) * amplitude
	crocket.position.y = cos(clock * frequency) * amplitude
	WON.position.y = cos(clock * frequency/2) * amplitude
	YOU.position.y = cos(clock * frequency) * amplitude	
	
func _process(delta: float) -> void:
	clock += delta * 2
	_title_move(clock)
