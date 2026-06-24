class_name Card_Visual
extends Node2D

signal Card_Being_Held(_card : Card_Visual)
signal Card_Let_Go(_card : Card_Visual)

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var desc_lable: Label = $Control/MarginContainer/Desc_Lable
@onready var cost_lable: Label = $Control/Cost_Lable

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

func _on_control_button_down() -> void:
	Card_Being_Held.emit(self)

func _on_control_button_up() -> void:
	Card_Let_Go.emit(self)
