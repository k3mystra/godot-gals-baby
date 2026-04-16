extends CharacterBody2D

@export var speed : float
@onready var enable = $VisibleOnScreenEnabler2D
var allowDel := false

func _ready() -> void:
	show()
	rotation_degrees += randf_range(0, 360)
	await get_tree().create_timer(120).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.x = -randf_range(speed/3, speed)
	move_and_slide()
