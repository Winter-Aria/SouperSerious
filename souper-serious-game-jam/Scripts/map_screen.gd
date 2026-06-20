extends Node2D
var mapNodes: Array[MapNode]=[]
@export var MapButton: PackedScene

func _ready() -> void:
	var generator = MapGenerator.new()
	mapNodes = generator.Generate()
	print("Generated ", mapNodes.size(), " Nodes")
	$PathLines.Setup(mapNodes)
	for node in mapNodes:
		SpawnNodeButton(node)
		
func SpawnNodeButton(nodeData:MapNode)-> void:
	var button = MapButton.instantiate()
	$NodeContainer.add_child(button)
	button.setup(nodeData)
