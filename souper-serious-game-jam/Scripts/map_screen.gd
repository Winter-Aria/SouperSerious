extends Node2D

var mapNodes: Array[MapNode] = []
var nodeButtons: Dictionary = {}
var traveledConnections: Dictionary = {}
@export var MapButton: PackedScene
var currentNodeId: String = "start"

func _ready() -> void:
	var generator = MapGenerator.new()
	mapNodes = generator.Generate()
	print("Generated ", mapNodes.size(), " Nodes")
	
	$PathLines.Setup(mapNodes)
	
	for node in mapNodes:
		SpawnNodeButton(node)
	
	RefreshAllButtons()
	
	var startNode = FindNodeById("start")
	$MapCamera.SetTarget(startNode)

func SpawnNodeButton(nodeData: MapNode) -> void:
	var button = MapButton.instantiate()
	$NodeContainer.add_child(button)
	button.Setup(nodeData)
	button.NodeClicked.connect(OnNodeClicked)
	nodeButtons[nodeData.id] = button

func OnNodeClicked(node: MapNode) -> void:
	if not node.available:
		return
	

	if currentNodeId != "":
		var edgeKey = currentNodeId + "->" + node.id
		traveledConnections[edgeKey] = true
	
	currentNodeId = node.id
	
	node.visited = true
	node.available = false
	
	for connId in node.connections:
		var target = FindNodeById(connId)
		if target:
			target.available = true
	
	LockSiblingsInSameRow(node)
	RefreshAllButtons()
	$PathLines.SetTraveled(traveledConnections)  
	$MapCamera.SetTarget(node)

func LockSiblingsInSameRow(chosenNode: MapNode) -> void:
	for node in mapNodes:
		if node.gridPos.y == chosenNode.gridPos.y and node.id != chosenNode.id:
			if node.available and not node.visited:
				node.available = false

func FindNodeById(id: String) -> MapNode:
	for node in mapNodes:
		if node.id == id:
			return node
	return null

func RefreshAllButtons() -> void:
	for node in mapNodes:
		var button = nodeButtons[node.id]
		button.UpdateVisualState()
