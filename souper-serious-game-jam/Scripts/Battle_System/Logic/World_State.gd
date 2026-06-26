class_name World_State
extends Resource

var World_Player : Player = null

@export var Enemies : Array[Enemy] = []

func Apply_Action(_Data : ActionData) -> void: 
	print("Action Recieved")
	#_Data.caster.Get_Effect_Stacks()
	_Data = _Data.caster.Apply_Effects_For_Step(_Data, StatusEffect.TriggerCondition.OnDeclareAction)

func End_Turn() -> void:
	print("turn ended!")

func Damage_Enemy(_amount : int) -> void:
	print("damaged enemy for " + str(_amount))

func Heal_Player(_amount : int) -> void:
	print("healed player for " + str(_amount))
