extends StatusEffectEffect
class_name RevolutionarySituationEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	if (action_data.action_type == action_data.DamageType.Damage 
	and action_data.caster.Health < 0.3 * action_data.caster.Max_Health):
		action_data.action_value = action_data.action_value + (action_data.action_value * effect_stacks)
	
	return action_data
