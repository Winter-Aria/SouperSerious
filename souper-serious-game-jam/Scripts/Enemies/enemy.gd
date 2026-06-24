#class_name Enemy
#extends Node2D
#
#@onready var mouse_detector: Mouse_Detector = $MouseDetector
#
#@export var max_health: int = 20
#@export var current_health: int = 20
#@export var deck: EnemyDeck
#@export var randomised_moves: bool = false
#
#var selected_card_index: int = 0
#var selected_card: Card
#
## For randomised moves
#var current_hand: Array[Card]
#
#func draw_next_card() -> Card:
	#if not randomised_moves:
		#selected_card_index = wrapi(selected_card_index + 1, 0, deck.cards.size())
		#selected_card = deck.cards[selected_card_index]
		#
		#return selected_card
	#else:
		#if current_hand.size() == 0:
			#draw_hand()
		#
		#selected_card_index = randi_range(0, current_hand.size()-1)
		#selected_card = current_hand[selected_card_index]
		#current_hand.remove_at(selected_card_index)
		#
		#return selected_card
#
#
#func draw_hand() -> void:
	#current_hand = deck.cards
