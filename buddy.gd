extends Label

@export var planet_group: String = "planet"
@export var randomizer_chance_per_second: float = 0.1
@onready var planets: Array[Node] = []

func _ready() -> void:
	planets.clear()
	var selected_planets = get_tree().get_nodes_in_group(planet_group)
	for i in selected_planets:
		if is_instance_valid(i) and not i.is_queued_for_deletion():
			planets.append(i)
			
func _on_timer_timeout() -> void:
	var result: bool = randf() <= randomizer_chance_per_second
	if (result):
		text = "Hrmmm, lemme just tweak that planet..."
		randomize_mass()
		$CloseDialogTimer.start()


func randomize_mass() -> void:
	var amount = randf_range(0, 100)
	var selection = randi_range(0, planets.size() - 1)
	print("Planets size:" + str(planets.size()))	
	planets[selection].mass = amount
	planets[selection].update_mass_label()


func _on_close_dialog_timer_timeout() -> void:
	text = ""
