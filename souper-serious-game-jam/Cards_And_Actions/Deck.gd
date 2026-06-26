class_name Deck
extends Resource

@export var cards: Array[Card]

func Get_Deck() -> Array[Card]:
	return cards.duplicate_deep()
