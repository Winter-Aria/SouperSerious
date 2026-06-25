class_name ActorStatusManager
extends Resource

class StatusEffectInstance:
	var effect: StatusEffect
	var stacks: int
	
	func _init(i_effect: StatusEffect, i_stacks: int) -> void:
		effect = i_effect
		stacks = i_stacks

var initialising_effects: Array[StatusEffectInstance]
var active_effects: Array[StatusEffectInstance]

func add_effect(new_effect: StatusEffect, stacks_to_add: int, permanent: bool = false, immediate: bool = true) -> void:
	if not (permanent or immediate):
		return
	
	# Add to active effects
	if immediate:
		var effect_applied: bool = false
		for effect_instance in active_effects:
			if effect_instance.effect.name == new_effect.name:
				effect_instance.stacks += stacks_to_add
				effect_applied = true
				break
		if not effect_applied:
			active_effects.append(StatusEffectInstance.new(new_effect, stacks_to_add))
	
	# Add to permanent effects
	if permanent:
		var effect_applied: bool = false
		for effect_instance in initialising_effects:
			if effect_instance.effect.name == new_effect.name:
				effect_instance.stacks += stacks_to_add
				effect_applied = true
				break
		if not effect_applied:
			initialising_effects.append(StatusEffectInstance.new(new_effect, stacks_to_add))
	
	# Clear zeroed effects
	var i: int = 0
	while i < active_effects.size():
		if active_effects[i].stacks == 0:
			active_effects.remove_at(i)
		else:
			i += 1
	
	i = 0
	while i < initialising_effects.size():
		if initialising_effects[i].stacks == 0:
			initialising_effects.remove_at(i)
		else:
			i += 1


func get_active_stacks_of_effect(effect: StatusEffect) -> int:
	for active_effect in active_effects:
		if active_effect.name == effect.name:
			return active_effect.stacks
	return 0


func clear_active_effects() -> void:
	active_effects.clear()

# Clear any effects with the clear_on_turn_end variable set to true
func clear_temporary_effects() -> void:
	var i: int = 0
	while i < active_effects.size():
		if active_effects[i].effect.clear_on_turn_end:
			active_effects.remove_at(i)
		else:
			i += 1


func initialise_effects_for_battle() -> void:
	active_effects = initialising_effects.duplicate_deep()
