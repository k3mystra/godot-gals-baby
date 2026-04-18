extends Label

@export var planet_group: String = "planet"
@export var randomizer_chance_per_second: float = 0.2
@onready var planets: Array[Node] = get_tree().get_nodes_in_group(planet_group)
	
func _on_timer_timeout() -> void:
	var result: bool = randf() <= randomizer_chance_per_second
	if (result):
		text = "Hrmmm, lemme just tweak that planet..."
		randomize_mass()
		$CloseDialogTimer.start()


func randomize_mass() -> void:
	#ugly solution again
	var actual_amount = planets.size()/2
	
	#lets say there's 3 old planet, the array size will be 6, so the actual planet index would be 3, 4, 5
	var amount = randf_range(0, 100)
	var selection = (actual_amount + randi_range(0,actual_amount-1))
	planets[selection].mass = amount
	planets[selection].update_mass_label()


func _on_close_dialog_timer_timeout() -> void:
	text = ""
