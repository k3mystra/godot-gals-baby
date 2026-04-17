extends Control

func _on_texture_button_button_up() -> void:
	GlobalSignal.call_restart.emit()
