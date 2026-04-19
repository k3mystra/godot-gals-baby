class_name CelestialBody extends StaticBody2D

@export var rocket_group: String = "rocket"
@onready var rockets: Array[Node]

@onready var GravityLight = $PointLight2D
@onready var LightSize = $PointLight2D.scale

@export var mass: float = 10
@export var gravity_constant: float = 9
@export var is_mass_adjustable: bool = true

@export var planet_anims: Array[SpriteFrames]

@export var GravityArrow : PackedScene
@export var arrow_count: int = 12
@export var orbit_radius: float = 60.0

@export var scroll_multiplier: float = 0.5

@onready var sound = $sound
var is_selected: bool = false

func _ready() -> void:
	rockets = (get_tree().get_nodes_in_group(rocket_group))
	GlobalSignal.rocket_launched.connect(activate_everything)
	GlobalSignal.goal_reached.connect(deactivate_everything)
	#GlobalSignal.remove_current_rocket.connect(clear_rocket)
	GlobalSignal.print_rocket_amount.connect(print_rocekt_amount)
	GlobalSignal.restart_level.connect(exit_planet_group)
	deactivate_everything()
	#$AnimatedSprite.sprite_frames = planet_anims[0]
	$AnimatedSprite.sprite_frames = planet_anims[randi() % planet_anims.size()]
	$AnimatedSprite.play("default")
	spawn_gravity_arrows()
	update_mass_label()

func exit_planet_group():
	remove_from_group("planet")

func spawn_gravity_arrows():
	for i in range(arrow_count):
		# 1. Calculate the angle for this specific arrow
		var angle = i * (PI * 2 / arrow_count)
		
		# 2. Calculate the position using polar coordinates
		var x = cos(angle) * orbit_radius
		var y = sin(angle) * orbit_radius
		var pos = Vector2(x, y)
		
		# 3. Instantiate the arrow
		var arrow = GravityArrow.instantiate()
		add_child(arrow)
		
		# 4. Set position and rotation
		arrow.position = pos
		
		arrow.rotation = angle + PI # PI (180 deg) points them inward toward center

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
	var target_rocket
	if rockets.size() == 1:
		target_rocket = rockets[0]
	else:
		push_error("FUACKKKK")
	var vec_to_rocket = position - target_rocket.position
	# Gravity equation, with distance scaling
	var force_amount = (gravity_constant * target_rocket.mass * mass) / vec_to_rocket.length_squared() * 100
	var force = vec_to_rocket.normalized() * force_amount
	target_rocket.apply_force(force)


func _input(event: InputEvent) -> void:
	if not is_mass_adjustable:
		return

	if event is InputEventMouseButton and is_selected:
		print(event.position, get_global_mouse_position(), position)
		var drag_amount
		if (event.button_index == MOUSE_BUTTON_WHEEL_UP):
			drag_amount = scroll_multiplier
		elif (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			drag_amount = -scroll_multiplier
		else:
			return
		print ("drag amount is ", drag_amount)
		
		# SFX code on drag
		#var motion_strength = event.relative.length()
		#var target_pitch = remap(motion_strength, 0, 50, 0.8, 2.0)
		#sound.pitch_scale = clamp(target_pitch, 0.5, 3.0)
		
		# Avoid mass dropping to less than 0
		mass = max(mass + drag_amount, 0.0)
		update_mass_label()

	if event is InputEventKey:
		if event.keycode == KEY_0 and event.is_released():
			print(rockets.size())

func update_mass_label() -> void:
	var original_arrow_scale = Vector2(0.25,0.25)
	$Label.text = "%.2f" % mass
	var ratio = 1.0 + (mass/10)
	GravityLight.scale = LightSize * (ratio)
	var speed_ratio = 1.0 + (mass/10)
	if speed_ratio == 1.0:
		for i in get_children():
			if i is GravityArrows:
				i.scale = original_arrow_scale
				i.hide()
	else:
		for i in get_children():
			if i is GravityArrows:
				i.show()	
				i.speed = speed_ratio
				i.scale = original_arrow_scale * ratio


func _on_mouse_entered() -> void:
	is_selected = true


func _on_mouse_exited() -> void:
	is_selected = false
