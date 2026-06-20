extends Button

var mapNode: MapNode
const ICONS = {
	
	MapNode.NodeType.COMBAT: preload("res://Art/MapIcon/CombatIcon.png"),
	MapNode.NodeType.START: preload("res://Art/MapIcon/StartIcon.png"),
	
}


func setup(nodeData: MapNode) -> void:
	mapNode = nodeData
	custom_minimum_size = Vector2(64, 64)
	text = ""                          
	icon = ICONS.get(nodeData.type)    
	expand_icon = true 
	position = nodeData.screenPos
	pressed.connect(OnPressed)
	

func OnPressed()-> void:
	print("Clicked node: " , mapNode.id)
			
