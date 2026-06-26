class_name Card_Visual
extends Node2D

signal Card_Being_Held(_card : Card_Visual)
signal Card_Let_Go(_card : Card_Visual)

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var desc_lable: Label = $Control/MarginContainer/Desc_Lable
@onready var cost_lable: Label = $Control/Cost_Lable
@onready var name_lable: Label = $Control/Name_lable

@onready var mouse_detector: Mouse_Detector = $MouseDetector

func Set_Visual_Based_Off_Card(_card : Card) -> void:
	if _card.Has_Attribute(Card.Atrributes.Red):
		polygon_2d.color = Color.RED
	if _card.Has_Attribute(Card.Atrributes.Green):
		polygon_2d.color = Color.GREEN
	if _card.Has_Attribute(Card.Atrributes.Blue):
		polygon_2d.color = Color.BLUE
	if _card.Has_Attribute(Card.Atrributes.Yellow):
		polygon_2d.color = Color.YELLOW
	
	desc_lable.set_text(
		_card.Description
	)
	cost_lable.set_text(
		str(_card.Cost)
	)
	name_lable.set_text(
		_card.Name
	)

var holding : bool = false
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left_Click"):
		if mouse_detector.Mouse_Within:
			holding = true
			Card_Being_Held.emit(self)
	
	if Input.is_action_just_released("Left_Click"):
		if holding:
			holding = false
			Card_Let_Go.emit(self)
