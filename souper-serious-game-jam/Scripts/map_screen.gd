extends Node2D

var mapNodes: Array[MapNode] = []
var nodeButtons: Dictionary = {}
var traveledConnections: Dictionary = {}
var currentNodeId: String = "start"
var playerMarker: Node2D

@export var MapButton: PackedScene
@export var PlayerMarkerScene: PackedScene
@export var WheelEncounterScene: PackedScene

func _ready() -> void:
	var generator = MapGenerator.new()
	mapNodes = generator.Generate()
	print("Generated ", mapNodes.size(), " Nodes")
	
	$PathLines.Setup(mapNodes)
	
	for node in mapNodes:
		SpawnNodeButton(node)
	
	RefreshAllButtons()
	
	playerMarker = PlayerMarkerScene.instantiate()
	add_child(playerMarker)
	
	var startNode = FindNodeById("start")
	var startNextRow = GetNextRowNodes(startNode)
	$MapCamera.SetTarget(startNode)
	MovePlayerMarkerTo(startNode)

func GetNextRowNodes(node: MapNode) -> Array[MapNode]:
	var nextRowNodes: Array[MapNode] = []
	for connId in node.connections:
		var target = FindNodeById(connId)
		if target:
			nextRowNodes.append(target)
	return nextRowNodes

func SpawnNodeButton(nodeData: MapNode) -> void:
	var button = MapButton.instantiate()
	$NodeContainer.add_child(button)
	button.Setup(nodeData)
	button.NodeClicked.connect(OnNodeClicked)
	nodeButtons[nodeData.id] = button

func MovePlayerMarkerTo(node: MapNode) -> void:
	var nodeCenter = node.screenPos + Vector2(32, 32)
	playerMarker.position = nodeCenter

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
	MovePlayerMarkerTo(node)
	if node.type != MapNode.NodeType.START:
		TriggerEncounter(node)
		
func TriggerEncounter(node: MapNode) -> void:
	match node.type:
		MapNode.NodeType.WHEEL:
			var wheelInstance = WheelEncounterScene.instantiate()
			get_tree().root.add_child(wheelInstance)
			wheelInstance.Setup()
			wheelInstance.tree_exited.connect(OnEncounterClosed)
			self.visible = false
			set_process_input(false)
		MapNode.NodeType.COMBAT:
			pass
		MapNode.NodeType.GLOBAL_RULE:
			pass
		MapNode.NodeType.BOSS:
			pass

func OnEncounterClosed() -> void:
	self.visible = true
	set_process_input(true)

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
