extends Action
class_name Generic_Heal

@export var Heal_Amount : int = 3

func Take_Action(_world_state : World_State, _card : Card) -> void:
	var Heal_Flip_Count : int = GameModifers.Get_Active_Modifer_Count_That_Affect_Card(
		_card, GameModifers.Heal_Flip
	)
	
	var Do_Heal_Flip : bool = (
		Heal_Flip_Count % 2 == 1
	)
	
	if Do_Heal_Flip:
		_world_state.Damage_Enemy(Heal_Amount)
	else:
		_world_state.Heal_Player(Heal_Amount)
