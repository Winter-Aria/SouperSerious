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

@export var MapDecorationTextures: Array[Texture2D]

func _ready() -> void:
	var generator = MapGenerator.new()
	mapNodes = generator.Generate()
	print("Generated ", mapNodes.size(), " Nodes")
	
	$PathLines.Setup(mapNodes)
	
	for node in mapNodes:
		SpawnNodeButton(node)
	
	SpawnMapDecorations(mapNodes)
	
	RefreshAllButtons()
	
	playerMarker = PlayerMarkerScene.instantiate()
	$NodeContainer.add_child(playerMarker)
	
	var startNode = FindNodeById("start")
	$MapCamera.SetTarget(startNode)
	MovePlayerMarkerTo(startNode)

func SpawnNodeButton(nodeData: MapNode) -> void:
	var button = MapButton.instantiate()
	$NodeContainer.add_child(button)
	button.Setup(nodeData)
	button.NodeClicked.connect(OnNodeClicked)
	nodeButtons[nodeData.id] = button

func SpawnMapDecorations(nodes: Array[MapNode]):
	var things_to_avoid = nodes.map(func(x): return x.screenPos)
	const BUFFER_SPACE = 400
	var bg_size = $Background.texture.get_size() * $Background.scale * 0.8
	var bg_pos = $Background.position
	for y in range(100):
		var pos = Vector2(randf_range(0, bg_size.x), randf_range(0, bg_size.y)) - bg_size / 2 + bg_pos
		pos /= $NodeContainer.scale
		if SpawnMapDecoration(pos, DistToClosest(things_to_avoid, pos)):
			things_to_avoid.append(pos)
			
func DistToClosest(positions, target: Vector2):
	var closest = INF
	for pos in positions:
		var distance_to_pos = target.distance_squared_to(pos)
		if distance_to_pos < closest:
			closest = distance_to_pos
	return sqrt(closest)

func SpawnMapDecoration(pos, distance) -> bool:
	var texture = MapDecorationTextures.pick_random()
	var texSize = texture.get_size().length()
	if texSize * 0.8 > distance:  
		return false
	
	var decoration = Sprite2D.new()
	decoration.texture = texture
	decoration.position = pos
	decoration.rotation_degrees = randf_range(-10, 10)
	$NodeContainer.add_child(decoration)
	return true

func MovePlayerMarkerTo(node: MapNode) -> void:
	playerMarker.position = node.screenPos + Vector2(32, 32)

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
