extends Base_Actor
class_name Player

const PLAYER_DECK = preload("uid://d12f18aof13jm")

var Held_Deck : Deck = PLAYER_DECK

var Draw_Pile : Array[Card]

var Hand : Array[Card] = []

func _init() -> void:
	Draw_Pile = Held_Deck.Get_Deck()

func Draw_Cards(_cards_to_draw : int) -> int:
	var _cards_dawn : int = 0 
	for i in range(_cards_to_draw):
		if Draw_Pile.is_empty():
			break
		
		draw_card()
	
	return _cards_dawn

func Remove_Card(_card) -> void:
	Hand.erase(_card)

func draw_card() -> void:
	assert(Draw_Pile.is_empty() == false)
	
	var drawn_card : Card = Draw_Pile.pick_random()
	Hand.append(drawn_card.duplicate_deep())
	Draw_Pile.erase(drawn_card)
