class_name ActionData
extends Resource

enum DamageType{
	Damage,
	Heal
}

@export var target: Base_Actor
@export var caster: Base_Actor
@export var action_type: DamageType
@export var action_value: int
@export var procced_status_effects: Array[StatusEffect]
