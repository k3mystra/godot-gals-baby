class_name MainMenuButton extends Control


func _on_button_button_up() -> void:
	GlobalSignal.return_to_main_menu.emit()
