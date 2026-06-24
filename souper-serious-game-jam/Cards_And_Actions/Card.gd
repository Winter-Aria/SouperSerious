class_name Card
extends Resource

enum Atrributes 
{
	Red,
	Blue,
	Green,
	Yellow,
	Damaging,
	Healing,
}

enum Casting_Type
{
	Self  = 1 << 0, 
	Friendlies = 1 << 1,
	Hostiles = 1 << 2,
}

@export var Held_Attributes : Array[Atrributes] = []
@export var Cost : int 
@export var Base_Action : Action

@export_multiline var Description : String = ""

@export_flags("Self", "Friendlies", "Hostiles") var Applicability_Flags : int = 0

func Take_Cards_Action(_world_state : World_State) -> void:
	Base_Action.Take_Action(_world_state, self)

func Has_Attribute_List(_attributes : Array[Atrributes]) -> bool:
	for _att : Atrributes in _attributes:
		if Has_Attribute(_att):
			return true
	
	return false

func Has_Attribute(_attribute : Atrributes):
	return Held_Attributes.has(_attribute)

func Applicable_To_Target(_target_flags : int) -> bool:
	return _target_flags & Applicability_Flags == _target_flags
