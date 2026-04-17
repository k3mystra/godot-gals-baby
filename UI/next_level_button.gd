extends Control


func _on_button_pressed() -> void:
 GlobalSignal.change_level.emit()
