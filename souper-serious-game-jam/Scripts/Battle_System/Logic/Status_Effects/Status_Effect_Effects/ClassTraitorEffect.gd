extends StatusEffectEffect
class_name ClassTraitorEffect

func apply_effect_to_action(action_data: ActionData, effect_stacks: int) -> ActionData:
	if (action_data.caster.Team == Base_Actor.ActorTeam.Player 
	and action_data.target == action_data.caster 
	and action_data.action_type == action_data.DamageType.Damage):
		action_data.target.Energy += int(action_data.action_value * 0.5 * effect_stacks)
	return action_data
