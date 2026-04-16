extends StaticBody2D

@export var rocket_group: String = "rocket"
@onready var rockets: Array[Node] = get_tree().get_nodes_in_group(rocket_group)

@export var mass: float = 10
@export var gravity_constant: float = 9

func _physics_process(_delta: float) -> void:
	for rocket in rockets:
		var vec_to_rocket = position - rocket.position
		print(vec_to_rocket)
		# Gravity equation, with distance scaling
		var force_amount = (gravity_constant * rocket.mass * mass) / vec_to_rocket.length_squared() * 100
		print(force_amount)
		var force = vec_to_rocket.normalized() * force_amount

		rocket.apply_force(force)
