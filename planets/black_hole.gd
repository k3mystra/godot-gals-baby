class_name BlackHole extends CelestialBody

func _ready() -> void:
	rockets = (get_tree().get_nodes_in_group(rocket_group))
	GlobalSignal.rocket_launched.connect(activate_everything)
	GlobalSignal.goal_reached.connect(deactivate_everything)
	#GlobalSignal.remove_current_rocket.connect(clear_rocket)
	GlobalSignal.print_rocket_amount.connect(print_rocekt_amount)
	GlobalSignal.restart_level.connect(exit_planet_group)
	deactivate_everything()
	$AnimatedSprite.play("default")
	spawn_gravity_arrows()
	update_mass_label()
