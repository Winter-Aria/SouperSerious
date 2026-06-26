extends Action
class_name Generic_Heal

@export var Heal_Amount : int = 3

func Generate_Action_Data() -> ActionData:
	var _action := ActionData.new()
	_action.action_type = ActionData.DamageType.Heal
	_action.action_value = Heal_Amount
	
	return _action
