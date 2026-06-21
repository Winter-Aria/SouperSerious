extends Camera2D

@export var zoomLevel: float = 0.7
@export var bottomOffset: float = 460.0
@export var smoothingTime: float = 0.2

var targetY: float = 0.0

func _ready() -> void:
	zoom = Vector2(zoomLevel, zoomLevel)

func SetTarget(node: MapNode) -> void:
	var worldOffset = bottomOffset / zoomLevel
	targetY = node.screenPos.y - worldOffset

func _process(delta: float) -> void:
	var weight = 1.0 - exp(-delta / smoothingTime)
	position.y = lerp(position.y, targetY, weight)
