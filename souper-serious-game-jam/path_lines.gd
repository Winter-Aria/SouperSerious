extends Node2D

var mapNodes: Array[MapNode] = []
var traveledConnections: Dictionary = {}
const NODE_VISUAL_OFFSET = Vector2(32, 32)
const LINE_END_MARGIN = 28.0

const PAINT_COLORS = [
	Color(0.55, 0.05, 0.05, 0.9),   
	Color(0.85, 0.65, 0.05, 0.9),  
	Color(0.1, 0.4, 0.55, 0.9),    
	Color(0.6, 0.15, 0.55, 0.9),    
	Color(0.15, 0.5, 0.15, 0.9),    
	Color(0.9, 0.45, 0.05, 0.9),   
]

func Setup(nodes: Array[MapNode]) -> void:
	mapNodes = nodes
	queue_redraw()

func SetTraveled(traveled: Dictionary) -> void:
	traveledConnections = traveled
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
				
				var edgeKey = node.id + "->" + target.id
				if traveledConnections.has(edgeKey):
					var paintColor = ColorForEdge(edgeKey)
					DrawGraffitiLine(adjustedFrom, adjustedTo, paintColor)
				else:
					draw_dashed_line(adjustedFrom, adjustedTo, Color.BLACK, 4.0, 12.0)

func ColorForEdge(edgeKey: String) -> Color:
	
	var hash = 0
	for c in edgeKey:
		hash += c.unicode_at(0)
	var index = hash % PAINT_COLORS.size()
	return PAINT_COLORS[index]

func DrawGraffitiLine(from: Vector2, to: Vector2, paintColor: Color) -> void:
	var segments = 16
	var points: Array[Vector2] = []
	var seed = node_seed_offset(from)
	
	for i in range(segments + 1):
		var t = float(i) / segments
		var basePoint = from.lerp(to, t)
		var perpendicular = (to - from).normalized().rotated(PI / 2)
		
		var wobble = sin(t * PI * 5.0 + seed) * 5.0
		wobble += sin(t * PI * 11.0 + seed * 1.7) * 2.0
		
		points.append(basePoint + perpendicular * wobble)
	
	for i in range(points.size() - 1):
		var thickness = 5.0 + sin(float(i) * 2.3 + seed) * 2.5
		draw_line(points[i], points[i + 1], paintColor, thickness)
	
	for i in range(6):
		var t = randf()
		var basePoint = from.lerp(to, t)
		var perpendicular = (to - from).normalized().rotated(PI / 2)
		var offset = perpendicular * randf_range(-12, 12)
		var dotPos = basePoint + offset
		var dotSize = randf_range(1.5, 3.5)
		draw_circle(dotPos, dotSize, Color(paintColor.r, paintColor.g, paintColor.b, 0.5))

func node_seed_offset(p: Vector2) -> float:
	return fmod(p.x * 12.9898 + p.y * 78.233, 6.2831)

func FindNodeById(id: String) -> MapNode:
	for node in mapNodes:
		if node.id == id:
			return node
	return null
