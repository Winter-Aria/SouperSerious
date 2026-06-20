extends Button

var mapNode: MapNode

func setup(nodeData:MapNode)-> void:
	mapNode = nodeData
	text = labelForNodeType(nodeData.type)
	position = nodeData.screenPos
	pressed.connect(OnPressed)
	
func labelForNodeType(type: MapNode.NodeType) -> String:
	match type:
		MapNode.NodeType.START:
			return "S"
		MapNode.NodeType.COMBAT:
			return "C"
		MapNode.NodeType.WHEEL:
			return "W"
		MapNode.NodeType.GLOBAL_RULE:
			return "G"
		MapNode.NodeType.BOSS:
			return "B"
		_:
			return "?"
func OnPressed()-> void:
	print("Clicked node: " , mapNode.id)
			
