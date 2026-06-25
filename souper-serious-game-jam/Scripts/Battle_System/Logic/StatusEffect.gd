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
@export var trigger_condition: TriggerCondition
@export var clear_on_turn_end: bool = false

@export var effect: StatusEffectEffect

# Lower number means it will proc earlier when multiple effects need to proc
@export var priority: int
