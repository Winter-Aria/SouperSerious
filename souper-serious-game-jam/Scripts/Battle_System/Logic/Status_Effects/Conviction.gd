extends StatusEffectEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	if action_data.action_type == action_data.DamageType.Damage:
		action_data.action_value += effect_stacks
	
	return action_data
