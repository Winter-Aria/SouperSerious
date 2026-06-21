class_name World_State
extends Resource

func Damage_Enemy(_amount : int) -> void:
	print("damaged enemy for " + str(_amount))

func Heal_Player(_amount : int) -> void:
	print("healed player for " + str(_amount))
