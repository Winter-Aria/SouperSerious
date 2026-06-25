extends Resource
class_name Base_Actor

enum ActorTeam{
	Enemy,
	Player
}

@export var Team: ActorTeam
@export var Max_Health : int = 20
@export var Health : int = 20
@export var Block : int = 0
@export var Max_Energy: int = 3
@export var Energy: int = 3
@export var status_manager: ActorStatusManager = ActorStatusManager.new()

func Take_Damage(_damage : int) -> void:
	var damage_to_deal: int = clampi(_damage - Block, 0, _damage + abs(Block)) # Accounting for making sure you dont heal by dealing less damage than they have block
	Health -= damage_to_deal
	Health = clampi(Health, 0, 10000)

func Apply_Effect(effect: StatusEffect, stacks: int, permanent: bool = false, immediate: bool = true) -> void:
	status_manager.add_effect(effect, stacks, permanent, immediate)

func Get_Effect_Stacks(effect: StatusEffect) -> int:
	return status_manager.get_active_stacks_of_effect(effect)

func End_Of_Turn() -> void:
	Block = 0
	
	status_manager.clear_temporary_effects()

func End_Of_Battle() -> void:
	status_manager.clear_active_effects()

func Beginning_Of_Turn():
	Energy = Max_Energy

func Beginning_Of_Battle() -> void:
	Block = 0
	Energy = Max_Energy
	status_manager.initialise_effects_for_battle()
