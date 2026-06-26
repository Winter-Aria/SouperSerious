class_name Actor_Visual
extends Node2D

enum Visual_Types
{
	Player,
	Enemy
}

@onready var mouse_detector: Mouse_Detector = $MouseDetector

@export var Visual_Type : Visual_Types = Visual_Types.Player
