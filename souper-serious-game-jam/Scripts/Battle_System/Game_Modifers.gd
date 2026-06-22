extends Node

var Active_Modifiers : Array[Modifier] = []

@abstract class Modifier:
	@abstract func Affects_Card(_card : Card) -> bool

class Heal_Flip extends Modifier:
	var Colours_To_Flip : Array[Card.Atrributes] = []
	
	func Affects_Card(_card : Card) -> bool:
		if _card.Has_Attribute_List(Colours_To_Flip) == false:
			return false
		
		if _card.Has_Attribute_List([Card.Atrributes.Healing, Card.Atrributes.Damaging]) == false:
			return false
		
		return true

func _ready() -> void:
	Active_Modifiers.append(
		Heal_Flip.new()
	)

var flip_test : bool = false
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Test1"):
		flip_test = !flip_test 
		
		print(flip_test)
		var att : Array[Card.Atrributes] = []
		if flip_test:
			att = [Card.Atrributes.Red]
		else:
			att = []
		Active_Modifiers[0].Colours_To_Flip = att

## Returns how many active modifiers of the specified type affect the card
## [param b] is designed to be the class itself, not an instance.
func Get_Active_Modifer_Count_That_Affect_Card(_card : Card, _mod_check : Variant) -> int:
	var counter : int = 0
	for _mod : Modifier in Active_Modifiers:
		if is_instance_of(_mod, _mod_check):
			if _mod.Affects_Card(_card):
				counter += 1
	
	return counter

#func Get_Modifers_That_Affect_Card(_card : Card) -> Dictionary[Modifier, int]:
	#var Effecting_Modifiers : Array[Modifier] = []
	#
	#for _mod : Modifier in Active_Modifiers:
		#if _mod.Affects_Card(_card):
			#Effecting_Modifiers.append(_mod)
	#
	#return {}
#
#func Modifer_List_Has_Modifier(_modifier : Modifier, _list : Array[Modifier]) -> bool:
	#for _mod : Modifier in _list:
		#if is_instance_of(_mod, _modifier):
			#return true
	#
	#return false
