extends Area2D
class_name Mouse_Detector

var Mouse_Within : bool = false

func _on_mouse_entered() -> void:
	print("a")
	Mouse_Within = true

func _on_mouse_exited() -> void:
	print("b")
	Mouse_Within = false
