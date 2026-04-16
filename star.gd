extends CharacterBody2D

@export var speed : float
var allowDel := false

func _ready() -> void:
	show()
	rotation_degrees += randf_range(0, 360)
	speed = -randf_range(speed/3, speed)
	GlobalSignal.level_selected.connect(remove_stars)
	await get_tree().create_timer(120).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.x = speed
	move_and_slide()

func remove_stars():
	queue_free()
