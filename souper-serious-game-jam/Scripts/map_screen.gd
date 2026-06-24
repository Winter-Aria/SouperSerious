extends Node2D

var mapNodes: Array[MapNode] = []
var nodeButtons: Dictionary = {}
var traveledConnections: Dictionary = {}
var currentNodeId: String = "start"
var playerMarker: Node2D

var collectedCauses: Array[RuleCause] = []
var collectedEffects: Array[RuleEffect] = []
var activeRules: Array[ActiveRule] = []

@export var MapButton: PackedScene
@export var PlayerMarkerScene: PackedScene
@export var WheelEncounterScene: PackedScene
@export var GlobalRuleEncounterScene: PackedScene

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
	$MapCamera.SetTarget(startNode)
	MovePlayerMarkerTo(startNode)

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
		MapNode.NodeType.GLOBAL_RULE:
			var ruleInstance = GlobalRuleEncounterScene.instantiate()
			get_tree().root.add_child(ruleInstance)
			ruleInstance.Setup(self)
			ruleInstance.tree_exited.connect(OnEncounterClosed)
			self.visible = false
			set_process_input(false)
		MapNode.NodeType.COMBAT:
			pass
		MapNode.NodeType.BOSS:
			pass

func OnEncounterClosed() -> void:
	self.visible = true
	set_process_input(true)
	$MapCamera.make_current()

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
