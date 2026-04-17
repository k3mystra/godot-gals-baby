class_name pause_button extends Control

func _ready() -> void:
	$PlayButton.hide()

func _on_pause_button_button_up() -> void:
	get_tree().paused = true
	$PauseButton.hide()
	$PlayButton.show()

func _on_play_button_button_up() -> void:
	get_tree().paused = false
	$PauseButton.show()
	$PlayButton.hide()
	
