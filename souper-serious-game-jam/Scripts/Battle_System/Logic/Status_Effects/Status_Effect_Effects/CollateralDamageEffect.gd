extends StatusEffectEffect
class_name CollateralDamageEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	# Need code to apply 50% of action effect to all other actors.
	var halved_effect_value = action_data.action_value
	var targets = Battle_System.Current_World_State.Actors
	targets.erase(action_data.target)
	
	var new_actions: Array[ActionData] = []
	for target in targets:
		var new_action = action_data.duplicate()
		new_action.target = target
		new_actions.append(new_action)
	
	for action in new_actions:
		Battle_System.Current_World_State.Apply_Action(action)
	
	return action_data
