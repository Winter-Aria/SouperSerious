extends Node2D

var mapNodes: Array[MapNode] = []
const NODE_VISUAL_OFFSET = Vector2(32, 32)  
const LINE_END_MARGIN = 28.0

func Setup(nodes: Array[MapNode]) -> void:
	mapNodes = nodes
	queue_redraw()



func _draw() -> void:
	for node in mapNodes:
		for connId in node.connections:
			var target = FindNodeById(connId)
			if target:
				var from = node.screenPos + NODE_VISUAL_OFFSET
				var to = target.screenPos + NODE_VISUAL_OFFSET
				var direction = (to - from).normalized()
				var adjustedFrom = from + direction * LINE_END_MARGIN
				var adjustedTo = to - direction * LINE_END_MARGIN
				draw_dashed_line(adjustedFrom, adjustedTo, Color.BLACK, 4.0, 12.0)

func FindNodeById(id: String) -> MapNode:
	for node in mapNodes:
		if node.id == id:
			return node
	return null
