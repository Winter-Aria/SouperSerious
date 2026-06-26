extends StatusEffectEffect
class_name RhetoricEffect

@export var ConvictionStatusEffect: StatusEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	# Need code here to apply -1 Conviction to a random enemy if dealing damage
	return action_data
