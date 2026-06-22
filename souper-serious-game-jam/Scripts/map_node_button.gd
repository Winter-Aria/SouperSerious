extends Button
signal NodeClicked(node: MapNode)
var mapNode: MapNode

const ICONS = {
	
	MapNode.NodeType.COMBAT: preload("res://Art/MapIcon/CombatIcon.png"),
	MapNode.NodeType.START: preload("res://Art/MapIcon/StartIcon.png"),
	MapNode.NodeType.WHEEL:preload("res://Art/MapIcon/WheelIcon.png"),
	MapNode.NodeType.GLOBAL_RULE:preload("res://Art/MapIcon/RulePrinter.png"),
	
	
}


func Setup(nodeData: MapNode) -> void:
	mapNode = nodeData
	custom_minimum_size = Vector2(64, 64)
	text = ""                          
	icon = ICONS.get(nodeData.type)    
	expand_icon = true 
	position = nodeData.screenPos
	pressed.connect(OnPressed)
	UpdateVisualState()
	

func OnPressed() -> void:
	print("Button OnPressed fired for: ", mapNode.id)
	NodeClicked.emit(mapNode)

func UpdateVisualState() -> void:
	if mapNode.visited:
		modulate = Color(0.5, 0.5, 0.5, 1.0)
		disabled = false
	elif mapNode.available:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		disabled = false
	else:
		modulate = Color(0.3, 0.3, 0.3, 0.6)
		disabled = true
