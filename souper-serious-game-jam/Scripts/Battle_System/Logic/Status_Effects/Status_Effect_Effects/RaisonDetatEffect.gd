extends StatusEffectEffect
class_name RaisonDetatEffect

@export var ConvictionStatusEffect: StatusEffect
@export var RaisonDetatExhaustedStatusEffect: StatusEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	if action_data.target.Get_Effect_Stacks(RaisonDetatExhaustedStatusEffect) > 0:
		return
	else:
		action_data.target.Apply_Effect(ConvictionStatusEffect, effect_stacks)
		action_data.target.Apply_Effect(RaisonDetatExhaustedStatusEffect, 1)
	
	return action_data
