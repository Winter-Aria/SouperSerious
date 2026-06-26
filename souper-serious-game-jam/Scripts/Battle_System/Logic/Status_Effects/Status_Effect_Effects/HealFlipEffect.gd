extends StatusEffectEffect
class_name HealFlipEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	if effect_stacks % 2 != 0:
		if action_data.action_type == action_data.DamageType.Damage:
			action_data.action_type = action_data.DamageType.Heal
		elif action_data.action_type == action_data.DamageType.Heal:
			action_data.action_type = action_data.DamageType.Damage
	
	return action_data
