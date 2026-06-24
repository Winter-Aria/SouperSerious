extends RefCounted
class_name WheelRuleList

static func GetAllRules() -> Array[WheelRule]:
	var rules: Array[WheelRule] = []
	rules.append(MakeRule("double_damage", "Double Damage", "All damage dealt is doubled this round."))
	rules.append(MakeRule("no_healing", "No Healing", "Healing effects are disabled this round."))
	return rules

static func MakeRule(id: String, displayName: String, description: String) -> WheelRule:
	var rule = WheelRule.new()
	rule.id = id
	rule.displayName = displayName
	rule.description = description
	return rule
