extends CharacterBody2D

@export var speed : float
var allowDel := false
var randscale = 0.0

func _ready() -> void:
	show()
	add_to_group("stars")
	rotation_degrees += randf_range(0, 360)
	speed = randf_range(speed/3, speed)
	randscale = randf_range(-0.3, 0.3)
	scale += Vector2(randscale, randscale)
	await get_tree().create_timer(120).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()
