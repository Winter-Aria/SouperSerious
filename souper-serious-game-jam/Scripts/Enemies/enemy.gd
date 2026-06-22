class_name Enemy
extends Node2D

@onready var mouse_detector: Mouse_Detector = $MouseDetector

@export var max_health: int = 20
@export var current_health: int = 20
@export var deck: EnemyDeck
