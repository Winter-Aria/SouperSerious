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

func Apply_Action_To_Actor(action_data: ActionData) -> ActionData:
	if action_data.action_type == action_data.DamageType.Damage:
		var damage_to_deal: int = clampi(action_data.action_value - Block, 0, action_data.action_value + abs(Block)) # Accounting for making sure you dont heal by dealing less damage than they have block
		Health -= damage_to_deal
		var health_after_damage_dealt = Health
		Health = clampi(Health, 0, Max_Health)
		var total_damage_dealt = damage_to_deal - (Health - health_after_damage_dealt)
		var damaging_action_data = action_data.duplicate()
		damaging_action_data.action_value = total_damage_dealt
		return damaging_action_data
	elif action_data.action_type == action_data.DamageType.Heal:
		Health += action_data.action_value
		var health_after_heal = Health
		Health = clampi(Health, 0, Max_Health)
		var total_heal_done = action_data.action_value - (health_after_heal - Health)
		var healing_action_data = action_data.duplicate()
		healing_action_data.action_value = total_heal_done
		return healing_action_data
	else:
		print("How did you reach this branch?")
		action_data.action_value = 0
		return action_data

func Apply_Effect(effect: StatusEffect, stacks: int, permanent: bool = false, immediate: bool = true) -> void:
	status_manager.add_effect(effect, stacks, permanent, immediate)

func Apply_Effects_For_Step(action_data: ActionData, step: StatusEffect.TriggerCondition) -> ActionData:
	return status_manager.apply_effects_for_step(action_data, step)

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
