extends Camera2D

@export var zoomLevel: float = 0.7
@export var startOffset: float = 400.0
@export var extraBuffer: float = 150
@export var smoothingTime: float = 0.2

const NODE_VISUAL_OFFSET = Vector2(32, 32)

var lastNodeY: float = 0.0
var initialized: bool = false
var targetY: float = 0.0

func _ready() -> void:
	zoom = Vector2(zoomLevel, zoomLevel)

func SetTarget(node: MapNode) -> void:
	var nodeCenterY = node.screenPos.y + NODE_VISUAL_OFFSET.y
	
	if not initialized:
		var worldOffset = startOffset / zoomLevel
		targetY = nodeCenterY - worldOffset
		position.y = targetY   
		initialized = true
	else:
		var deltaY = nodeCenterY - lastNodeY
		targetY += deltaY - extraBuffer
	
	lastNodeY = nodeCenterY

func _process(delta: float) -> void:
	var weight = 1.0 - exp(-delta / smoothingTime)
	position.y = lerp(position.y, targetY, weight)
