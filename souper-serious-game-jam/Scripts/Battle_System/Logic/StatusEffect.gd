class_name StatusEffect
extends Resource

enum TriggerCondition{
	OnDeclareDamage,
	OnDeclareHeal,
	OnDealDamage,
	OnDealHeal,
	OnTurnBegin,
	OnTurnEnd
}

@export var name: String
@export_multiline var description: String
@export var trigger_condition: TriggerCondition

@export var effect: StatusEffectEffect
