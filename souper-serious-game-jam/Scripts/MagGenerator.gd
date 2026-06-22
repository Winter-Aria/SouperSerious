extends Node2D
class_name MapGenerator

const ROWS = 9
const MIN_NODES_PER_ROW = 2
const MAX_NODES_PER_ROW = 4
const COLUMN_SPACING = 120
const ROW_SPACING = 150
const MIN_NODE_DISTANCE = 90.0

func Generate() -> Array[MapNode]:
	var allNodes: Array[MapNode] = []
	var rows: Array[Array] = []
	
	var start := MakeNode("start", MapNode.NodeType.START, Vector2i(0,0))
	start.visited = true
	start.available = false
	rows.append([start])
	allNodes.append(start)
	
	for row_i in range(1, ROWS):
		var count = randi_range(MIN_NODES_PER_ROW, MAX_NODES_PER_ROW)
		var rowNodes: Array[MapNode] = []
		for col_i in range(count):
			var type = RandomType()
			var node := MakeNode("r%d_c%d" % [row_i, col_i], type, Vector2i(col_i, row_i))
			rowNodes.append(node)
			allNodes.append(node)
		rows.append(rowNodes)
	
	var boss := MakeNode("boss", MapNode.NodeType.BOSS, Vector2i(0, ROWS))
	rows.append([boss])
	allNodes.append(boss)
	
	for row_i in range(rows.size() - 1):
		ConnectRows(rows[row_i], rows[row_i + 1])
	
	# Player starts already at 'start' -- unlock its direct connections immediately
	for connId in start.connections:
		var target = FindNodeByIdInList(connId, allNodes)
		if target:
			target.available = true
	
	CalculateScreenPositions(rows)
	return allNodes


func FindNodeByIdInList(id: String, nodeList: Array) -> MapNode:
	for node in nodeList:
		if node.id == id:
			return node
	return null


func MakeNode(id: String, type: MapNode.NodeType, gridPos: Vector2i) -> MapNode:
	var node := MapNode.new()
	node.id = id
	node.type = type
	node.gridPos = gridPos
	return node


func RandomType() -> MapNode.NodeType:
	var choices = [
		MapNode.NodeType.COMBAT,
		MapNode.NodeType.WHEEL,
		MapNode.NodeType.GLOBAL_RULE,
	]
	return choices[randi() % choices.size()]


func ConnectRows(lower: Array, upper: Array) -> void:
	var sortedLower = lower.duplicate()
	sortedLower.sort_custom(func(a, b): return a.gridPos.x < b.gridPos.x)
	
	var sortedUpper = upper.duplicate()
	sortedUpper.sort_custom(func(a, b): return a.gridPos.x < b.gridPos.x)
	
	var connectedUpper = {}
	var lastIndex = 0
	
	for i in range(sortedLower.size()):
		var lowerNode = sortedLower[i]
		
		var primaryIndex = clampi(lastIndex, 0, sortedUpper.size() - 1)
		var primaryTarget = sortedUpper[primaryIndex]
		lowerNode.connections.append(primaryTarget.id)
		connectedUpper[primaryTarget.id] = true
		
		var branched = false
		if randf() < 0.3 and primaryIndex + 1 < sortedUpper.size():
			var secondTarget = sortedUpper[primaryIndex + 1]
			lowerNode.connections.append(secondTarget.id)
			connectedUpper[secondTarget.id] = true
			branched = true
		
		if branched:
			lastIndex = primaryIndex + 1
		else:
			var remainingLower = sortedLower.size() - (i + 1)
			var remainingUpper = sortedUpper.size() - (primaryIndex + 1)
			if remainingLower > 0 and remainingUpper > 0 and randf() < 0.6:
				lastIndex = primaryIndex + 1
	
	for upperNode in sortedUpper:
		if not connectedUpper.has(upperNode.id):
			var closestLower = sortedLower[0]
			var bestDist = abs(closestLower.gridPos.x - upperNode.gridPos.x)
			for lowerNode in sortedLower:
				var dist = abs(lowerNode.gridPos.x - upperNode.gridPos.x)
				if dist < bestDist:
					bestDist = dist
					closestLower = lowerNode
			closestLower.connections.append(upperNode.id)


func CalculateScreenPositions(rows: Array) -> void:
	var drift = 0.0
	for row_i in range(rows.size()):
		var rowNodes = rows[row_i]
		var rowWidth = (rowNodes.size() - 1) * COLUMN_SPACING
		var startX = -rowWidth / 2.0 + drift
		for col_i in range(rowNodes.size()):
			var node: MapNode = rowNodes[col_i]
			var x = startX + col_i * COLUMN_SPACING
			var y = -row_i * ROW_SPACING
			x += randf_range(-40, 40)
			y += randf_range(-30, 30)
			node.screenPos = Vector2(x, y)
		drift += randf_range(-60, 60)
		drift = clamp(drift, -150, 150)
		drift *= 0.7
		ResolveOverlaps(rowNodes)


func ResolveOverlaps(rowNodes: Array) -> void:
	rowNodes.sort_custom(func(a, b): return a.screenPos.x < b.screenPos.x)
	
	for i in range(1, rowNodes.size()):
		var prev: MapNode = rowNodes[i - 1]
		var current: MapNode = rowNodes[i]
		var dist = current.screenPos.distance_to(prev.screenPos)
		
		if dist < MIN_NODE_DISTANCE:
			var pushAmount = MIN_NODE_DISTANCE - dist
			current.screenPos.x += pushAmount
