extends Action
class_name Generic_Damage

@export var Damage_Amount : int = 3

func Generate_Action_Data() -> ActionData:
	var _action := ActionData.new()
	_action.action_type = ActionData.DamageType.Damage
	_action.action_value = Damage_Amount
	
	return _action
