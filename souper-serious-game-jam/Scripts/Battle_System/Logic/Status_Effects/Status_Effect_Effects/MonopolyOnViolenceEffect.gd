extends StatusEffectEffect
class_name MonopolyOnViolenceEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	if action_data.action_type == action_data.DamageType.Damage:
		action_data.action_value = int(action_data.action_value * (0.8**effect_stacks))
	elif action_data.action_type == action_data.DamageType.Heal:
		action_data.action_value = int(action_data.action_value * (1 + (0.2 * effect_stacks)))
	
	return action_data
