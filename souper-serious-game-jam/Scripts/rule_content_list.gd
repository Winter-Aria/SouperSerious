extends RefCounted
class_name RuleContentList

static func GetAllCauses() -> Array[RuleCause]:
	var causes: Array[RuleCause] = []
	causes.append(MakeCause("on_damage_taken", "When you take damage"))
	causes.append(MakeCause("on_turn_start", "At the start of your turn"))
	causes.append(MakeCause("on_card_play", "When you play a card"))
	causes.append(MakeCause("on_enemy_death", "When an enemy dies"))
	return causes

static func GetAllEffects() -> Array[RuleEffect]:
	var effects: Array[RuleEffect] = []
	effects.append(MakeEffect("draw_card", "Draw a card"))
	effects.append(MakeEffect("heal_small", "Heal a small amount"))
	effects.append(MakeEffect("deal_damage", "Deal damage to a random enemy"))
	effects.append(MakeEffect("gain_block", "Gain a small amount of block"))
	return effects

static func MakeCause(id: String, name: String) -> RuleCause:
	var c = RuleCause.new()
	c.id = id
	c.displayName = name
	return c

static func MakeEffect(id: String, name: String) -> RuleEffect:
	var e = RuleEffect.new()
	e.id = id
	e.displayName = name
	return e
