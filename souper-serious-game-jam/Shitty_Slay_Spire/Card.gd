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

@export var Held_Attributes : Array[Atrributes] = []
@export var Cost : int 
@export var Base_Action : Action

func Take_Cards_Action(_world_state : World_State) -> void:
	Base_Action.Take_Action(_world_state, self)

func Has_Attribute_List(_attributes : Array[Atrributes]) -> bool:
	for _att : Atrributes in _attributes:
		if Has_Attribute(_att):
			return true
	
	return false

func Has_Attribute(_attribute : Atrributes):
	return Held_Attributes.has(_attribute)
