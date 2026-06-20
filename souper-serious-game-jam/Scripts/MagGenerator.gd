extends Node2D
class_name MapGenerator


const ROWS = 5
const MIN_NODES_PER_ROW = 2
const MAX_NODES_PER_ROW = 4
const COLUMN_SPACING =120
const ROW_SPACING = 150


func Generate() -> Array[MapNode]:
	var allNodes: Array[MapNode] = []
	var rows: Array[Array] = []
	var start  :=MakeNode("start", MapNode.NodeType.START, Vector2i(0,0))
	rows.append([start])
	allNodes.append(start)
	
	for row_i in range(1, ROWS):
		var count= randi_range(MIN_NODES_PER_ROW, MAX_NODES_PER_ROW)
		var rowNodes:Array[MapNode] = []
		for col_i in range(count):
			var type = RandomType()
			var node := MakeNode("r%d_c%d" % [row_i, col_i], type, Vector2i(col_i, row_i))
			rowNodes.append(node)
			allNodes.append(node)
		rows.append(rowNodes)
	var boss := MakeNode("boss", MapNode.NodeType.BOSS, Vector2i(0,ROWS))
	rows.append([boss])
	allNodes.append(boss)
	
	for row_i in range(rows.size()-1):
		ConnectRows(rows[row_i], rows[row_i+1])
		
	CalculateScreenPositions(rows)
	return allNodes
	
	
	
func MakeNode(id: String, type: MapNode.NodeType, gridPos: Vector2i)-> MapNode:
	var node:=MapNode.new()
	node.id = id
	node.type = type
	node.gridPos = gridPos
	return node
	
func RandomType()-> MapNode.NodeType:
	var choices= [
		
		MapNode.NodeType.COMBAT,
		MapNode.NodeType.WHEEL,
		MapNode.NodeType.GLOBAL_RULE,
		]
	return choices[randi()%choices.size()]
	
func ConnectRows(lower: Array, upper: Array)->void:
	for lowerNode in lower:
		var targetCount = 1 if upper.size()==1 else randi_range(1, 2)
		var possibleTargets = upper.duplicate()
		possibleTargets.shuffle()
		for i in range(min(targetCount, possibleTargets.size())):
			lowerNode.connections.append(possibleTargets[i].id)
		
func CalculateScreenPositions(rows: Array) -> void:
	for row_i in range(rows.size()):
		var rowNodes = rows[row_i]
		var rowWidth = (rowNodes.size() - 1) * COLUMN_SPACING
		var startX = -rowWidth / 2.0   

		for col_i in range(rowNodes.size()):
			var node: MapNode = rowNodes[col_i]
			var x = startX + col_i * COLUMN_SPACING
			var y = -row_i * ROW_SPACING   
			x += randf_range(-15, 15)    
			y += randf_range(-10, 10)
			node.screenPos = Vector2(x, y)
	
	
