class_name World_State
extends Resource

@export var Actors : Array[Base_Actor] = []

func Apply_Action(_Data : ActionData) -> void: 
	print("Action Recieved")
	#_Data.caster.Get_Effect_Stacks()
	_Data = _Data.caster.Apply_Effects_For_Step(_Data, StatusEffect.TriggerCondition.OnDeclareAction)

func End_Turn(_Ender : Base_Actor.ActorTeam) -> void:
	print("turn ended!")

func Get_Player() -> Player:
	for _actor : Base_Actor in Actors:
		if _actor.Team == Base_Actor.ActorTeam.Player:
			return _actor
	
	return null

func Get_Enemies() -> Array[Enemy]:
	var Enemies : Array[Enemy] = []
	for _actor : Base_Actor in Actors:
		if _actor.Team == Base_Actor.ActorTeam.Enemy:
			Enemies.append(_actor)
	
	return Enemies


func Damage_Enemy(_amount : int) -> void:
	print("damaged enemy for " + str(_amount))

func Heal_Player(_amount : int) -> void:
	print("healed player for " + str(_amount))
