extends Area2D
class_name Mouse_Detector

var Mouse_Within : bool = false

func _on_mouse_entered() -> void:
	Mouse_Within = true

func _on_mouse_exited() -> void:
	Mouse_Within = false
