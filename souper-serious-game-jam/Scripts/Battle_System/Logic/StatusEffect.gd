class_name StatusEffect
extends Resource

enum TriggerCondition{
	None,
	OnDeclareDamage,
	OnDeclareHeal,
	OnDeclareAction,
	OnDealDamage,
	OnDealHeal,
	OnDealAction,
	OnTurnBegin,
	OnTurnEnd
}

@export var name: String
@export_multiline var description: String
@export var icon: Image
@export var trigger_condition: TriggerCondition
@export var clear_on_turn_end: bool = false

@export var effect: StatusEffectEffect

# Lower number means it will proc earlier when multiple effects need to proc
@export var priority: int

func proc_effect_on_action(action_data: ActionData, stacks: int) -> ActionData:
	if self in action_data.procced_status_effects: # Cancel proc if it has already occurred in this proc chain
		return action_data
	
	action_data.procced_status_effects.append(self)
	if effect != null:
		action_data = effect.apply_effect_to_action(action_data, stacks)
	return action_data
