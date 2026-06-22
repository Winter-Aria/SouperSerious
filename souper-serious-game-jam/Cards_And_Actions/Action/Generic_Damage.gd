extends Action
class_name Generic_Damage

@export var Damage_Amount : int = 3

func Take_Action(_world_state : World_State, _card : Card) -> void:
	var Damage_Flip_Count : int = GameModifers.Get_Active_Modifer_Count_That_Affect_Card(
		_card, GameModifers.Heal_Flip
	)
	
	var Do_Damage_Flip : bool = (
		Damage_Flip_Count % 2 == 1
	)
	
	if Do_Damage_Flip:
		_world_state.Heal_Player(Damage_Amount)
	else:
		_world_state.Damage_Enemy(Damage_Amount)
