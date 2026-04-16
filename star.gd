extends CharacterBody2D

@export var speed : float
var allowDel := false

func _ready() -> void:
	rotation_degrees += randf_range(0, 360)

func _physics_process(delta: float) -> void:
	velocity.x = -randf_range(speed/2, speed)
	move_and_slide()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	if allowDel:
		print ("deleted")
		queue_free()


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	allowDel = true
