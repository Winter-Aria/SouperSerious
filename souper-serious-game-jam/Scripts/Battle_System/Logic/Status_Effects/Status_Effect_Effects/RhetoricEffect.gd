extends StatusEffectEffect
class_name RhetoricEffect

@export var ConvictionStatusEffect: StatusEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	# Need code here to apply -1 Conviction to a random enemy if dealing damage
	var target_team = action_data.target.Team
	var targets = Battle_System.Current_World_State.Get_Actors_On_Team(target_team)
	
	for i in range(effect_stacks):
		var rand_num = randf()
		if rand_num < 0.6:
			var target = targets.pick_random()
			target.Apply_Effect(ConvictionStatusEffect, 1)
	
	return action_data
