extends Resource
class_name ActiveRule

var cause: RuleCause
var effect: RuleEffect

func GetDescription() -> String:
	return "WHEN " + cause.displayName + " THEN " + effect.displayName
