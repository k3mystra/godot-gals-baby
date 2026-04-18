extends CharacterBody2D

@export var speed : float

@onready var staranim = $AnimatedSprite2D

var allowDel := false
var randscale = 0.0
var startype : int

func _ready() -> void:
	var rarity = randi_range(0, 20)
	if rarity != 0:
		startype = randi_range(0, 1)
	else:
		startype = randi_range(2, 6)
	match startype:
		0: staranim.play("star1")
		1: staranim.play("star2")
		2: staranim.play("planet1")
		3: staranim.play("planet2")
		4: staranim.play("planet3")
		5:staranim.play("planet4")
		6: staranim.play("hole")
	show()
	add_to_group("stars")
	if staranim.animation == "hole":
		rotation_degrees = 0
	else:
		rotation_degrees += randf_range(0, 360)
	staranim.speed_scale += randf_range(-1, 6)
	speed = randf_range(speed/45, speed)
	randscale = randf_range(-0.5, 1)
	scale += Vector2(randscale, randscale)
	await get_tree().create_timer(120).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.x = -speed
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if global_position.x < 0:
			queue_free()
