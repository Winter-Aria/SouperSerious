extends Resource
class_name MapNode

enum NodeType{START, COMBAT, WHEEL, GLOBAL_RULE, BOSS}

var id: String
var type: NodeType
var gridPos: Vector2i
var screenPos: Vector2
var connections: Array[String] =[]
var visited : bool = false
var available: bool = false
