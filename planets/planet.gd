extends StaticBody2D

@export var rocket_group: String = "rocket"
@onready var rockets: Array[Node] = get_tree().get_nodes_in_group(rocket_group)

@export var mass: float = 10
@export var gravity_constant: float = 9

var previous_mouse_position: Vector2
var is_dragging: bool = false

func _ready() -> void:
	GlobalSignal.rocket_launched.connect(activate_everything)
	GlobalSignal.goal_reached.connect(deactivate_everything)
	update_mass_label()
	deactivate_everything()

func deactivate_everything():
	set_process_input(false)
	set_physics_process(false)
	
func activate_everything():
	set_process_input(true)
	set_physics_process(true)
	var rockets: Array[Node] = get_tree().get_nodes_in_group(rocket_group)

func _physics_process(_delta: float) -> void:
	for rocket in rockets:
		var vec_to_rocket = position - rocket.position
		# Gravity equation, with distance scaling
		var force_amount = (gravity_constant * rocket.mass * mass) / vec_to_rocket.length_squared() * 100
		var force = vec_to_rocket.normalized() * force_amount

		rocket.apply_force(force)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("ui_touch"):
		# get_tree().set_input_as_handled()
		previous_mouse_position = event.position
		is_dragging = true


func _input(event: InputEvent) -> void:
	if not is_dragging:
		return

	if event.is_action_released("ui_touch"):
		previous_mouse_position = Vector2()
		is_dragging = false

	if event is InputEventMouseMotion:
		var drag_amount = -(event.position - previous_mouse_position).y
		# Avoid mass dropping to less than 0
		mass = max(mass + drag_amount / 100, 0.0)
		update_mass_label()


func update_mass_label() -> void:
	$Label.text = "%.2f" % mass
