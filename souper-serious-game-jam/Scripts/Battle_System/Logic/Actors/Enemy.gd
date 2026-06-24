extends Base_Actor
class_name Enemy

enum Card_Choosing_Behaviour_Type
{
	Random,
	Ordered
}

@export var deck: EnemyDeck

@export var Card_Choosing_Behaviour : Card_Choosing_Behaviour_Type

@export var Enemy_Health : int = 20

var Card_To_Play : Card

# For randomised moves
var current_hand: Array[Card]
var chosen_card_index: int = 0

func _init() -> void:
	Max_Health = Enemy_Health
	Health = Enemy_Health

func End_Of_Turn_Reset() -> void:
	super.End_Of_Turn_Reset()

func choose_next_card() -> void:
	if Card_Choosing_Behaviour == Card_Choosing_Behaviour_Type.Ordered:
		chosen_card_index = wrapi(chosen_card_index + 1, 0, deck.cards.size())
		Card_To_Play = deck.cards[chosen_card_index]

	elif Card_Choosing_Behaviour == Card_Choosing_Behaviour_Type.Random:
		if current_hand.size() == 0:
			draw_hand()
		
		chosen_card_index = randi_range(0, current_hand.size()-1)
		Card_To_Play = current_hand[chosen_card_index]
		current_hand.remove_at(chosen_card_index)

func draw_hand() -> void:
	current_hand = deck.Get_Deck()
