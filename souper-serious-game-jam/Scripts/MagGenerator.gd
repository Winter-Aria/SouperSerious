extends Node2D
class_name MapGenerator

const ROWS = 15
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
	
	EnsureBriefcasePairs(allNodes)
	
	
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
	var roll = randf()
	if roll < 0.65:
		return MapNode.NodeType.COMBAT
	elif roll < 0.85:
		return MapNode.NodeType.WHEEL
	else:
		return MapNode.NodeType.GLOBAL_RULE


func EnsureBriefcasePairs(allNodes: Array[MapNode]) -> void:
	for node in allNodes:
		if node.type == MapNode.NodeType.GLOBAL_RULE:
			if not BranchHasAnotherBriefcase(node, allNodes):
				ForceBriefcaseAhead(node, allNodes)


func BranchHasAnotherBriefcase(startNode: MapNode, allNodes: Array[MapNode]) -> bool:
	var toVisit: Array[String] = startNode.connections.duplicate()
	var visited: Dictionary = {}
	
	while toVisit.size() > 0:
		var currentId = toVisit.pop_back()
		if visited.has(currentId):
			continue
		visited[currentId] = true
		
		var current = FindNodeByIdInList(currentId, allNodes)
		if current == null:
			continue
		
		if current.type == MapNode.NodeType.GLOBAL_RULE:
			return true
		
		for connId in current.connections:
			toVisit.append(connId)
	
	return false


func ForceBriefcaseAhead(startNode: MapNode, allNodes: Array[MapNode]) -> void:
	if startNode.connections.size() > 0:
		var nextId = startNode.connections[0]
		var nextNode = FindNodeByIdInList(nextId, allNodes)
		if nextNode and nextNode.type != MapNode.NodeType.BOSS and nextNode.type != MapNode.NodeType.START:
			nextNode.type = MapNode.NodeType.GLOBAL_RULE


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
