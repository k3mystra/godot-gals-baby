extends StaticBody2D

@export var rocket_group: String = "rocket"
@onready var rockets: Array[Node] 

@export var mass: float = 10
@export var gravity_constant: float = 9

var previous_mouse_position: Vector2
var is_dragging: bool = false

func _ready() -> void:
	rockets = (get_tree().get_nodes_in_group(rocket_group))
	GlobalSignal.rocket_launched.connect(activate_everything)
	GlobalSignal.goal_reached.connect(deactivate_everything)
	#GlobalSignal.remove_current_rocket.connect(clear_rocket)
	GlobalSignal.print_rocket_amount.connect(print_rocekt_amount)
	
	update_mass_label()
	deactivate_everything()

#This is for debug why rocket doesnt work when loading new level
func print_rocekt_amount():
	print(rockets.size())

func clear_rocket():
	print("clear was called")
	rockets.clear()
	print(rockets.size())

func deactivate_everything():
	set_process_input(false)
	set_physics_process(false)
	
func activate_everything():
	set_process_input(true)
	set_physics_process(true)

func _physics_process(_delta: float) -> void:

	#This is a very ugly solution, for some reason, the old rocket will always be there even if I tried to clear the array. 
	#But if it works, it works
	var target_rocket
	if rockets.size() == 1:
		target_rocket = rockets[0]
	else:
		target_rocket = rockets[1]
	var vec_to_rocket = position - target_rocket.position
	# Gravity equation, with distance scaling
	var force_amount = (gravity_constant * target_rocket.mass * mass) / vec_to_rocket.length_squared() * 100
	var force = vec_to_rocket.normalized() * force_amount
	target_rocket.apply_force(force)


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

	if event is InputEventKey:
		if event.keycode == KEY_0 and event.is_released():
			print(rockets.size())

func update_mass_label() -> void:
	$Label.text = "%.2f" % mass
