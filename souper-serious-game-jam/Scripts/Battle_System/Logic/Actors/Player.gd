extends Resource
class_name Player

const RED_HEALER = preload("uid://don58r81pvpe5")
const RED_DAMAGER = preload("uid://hbkgi6sj1vkc")
const YELLOW_HEALER = preload("uid://duwt40itidqk5")

var Draw_Pile_Cards : Array[Card] = [
	RED_HEALER.duplicate_deep(), RED_HEALER.duplicate_deep(), RED_HEALER.duplicate_deep(),
	RED_DAMAGER.duplicate_deep(), RED_DAMAGER.duplicate_deep(), RED_DAMAGER.duplicate_deep(),
	YELLOW_HEALER.duplicate_deep(), YELLOW_HEALER.duplicate_deep(), YELLOW_HEALER.duplicate_deep()
]

var Hand : Array[Card] = []

func Draw_Cards(_cards_to_draw : int) -> int:
	var _cards_dawn : int = 0 
	for i in range(_cards_to_draw):
		if Draw_Pile_Cards.is_empty():
			break
		
		draw_card()
	
	return _cards_dawn

func Remove_Card(_card) -> void:
	Hand.erase(_card)

func draw_card() -> void:
	assert(Draw_Pile_Cards.is_empty() == false)
	
	var drawn_card : Card = Draw_Pile_Cards.pick_random()
	Hand.append(drawn_card)
	Draw_Pile_Cards.erase(drawn_card)
