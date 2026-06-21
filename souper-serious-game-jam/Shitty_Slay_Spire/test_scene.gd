extends Node2D

const RED_CARD_UID : String = "uid://don58r81pvpe5"



var World := World_State.new()

var test_card : Card = load(RED_CARD_UID)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Test2"):
		test_card.Take_Cards_Action(World)
