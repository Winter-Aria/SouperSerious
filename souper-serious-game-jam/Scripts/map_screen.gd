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

@export var MapDecorations: Array[mapDecoration]

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

class avoidable_map_obj:
	var position: Vector2
	var size: float
	func _init(position_, size_) -> void:
		position = position_
		size = size_

func SpawnMapDecorations(nodes: Array[MapNode]):
	var things_to_avoid = nodes.map(func(x):
		return avoidable_map_obj.new(
			x.screenPos + Vector2(75, 75),
			200
		)
	)
	
	for y in range(1000):
		var bg_size = $Background.texture.get_size() * $Background.scale * 0.8
		var bg_pos = $Background.position
		var pos = Vector2(randf_range(0, bg_size.x), randf_range(0, bg_size.y)) - bg_size / 2 + bg_pos
		pos = pos / $NodeContainer.scale
		
		var decoration = SpawnMapDecoration(pos, DistToClosest(things_to_avoid, pos))
		if decoration:
			var size = decoration.texture.get_size().length() / 2
			things_to_avoid.append(avoidable_map_obj.new(decoration.position, size))

func DistToClosest(things_to_avoid, target: Vector2):
	var closest = INF
	for thing in things_to_avoid:
		var distance_to_pos = target.distance_squared_to(thing.position)
		if distance_to_pos - thing.size ** 2 < closest:
			closest = distance_to_pos - thing.size ** 2
	return sqrt(max(0, closest))

func SpawnMapDecoration(pos, distance):
	var MapDecorationTextures = MapDecorations.map(func(x): return x.image)
	var MapDecorationWeights = MapDecorations.map(func(x): return x.weight)
	var rng = RandomNumberGenerator.new()
	var texture = MapDecorationTextures[rng.rand_weighted(MapDecorationWeights)]
	
	var texSize = texture.get_size().length() / 2
	if distance < texSize * 1.4:
		return
	
	var decoration = Sprite2D.new()
	decoration.texture = texture
	decoration.position = pos
	decoration.rotation_degrees = randf_range(-10, 10)
	decoration.editor_description = "distance: %s\nsize: %s" % [str(distance), str(texSize)]
	$NodeContainer.add_child(decoration)
	return decoration

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
	await SceneTransition.FadeOut()
	match node.type:
		MapNode.NodeType.WHEEL:
			var wheelInstance = WheelEncounterScene.instantiate()
			get_tree().root.add_child(wheelInstance)
			wheelInstance.Setup()
			wheelInstance.tree_exited.connect(OnEncounterClosed)
			self.visible = false
			set_process_input(false)
		MapNode.NodeType.GLOBAL_RULE:
			var draftInstance = GlobalRuleEncounterScene.instantiate()
			get_tree().root.add_child(draftInstance)
			draftInstance.Setup(CardPool.AllCards)
			draftInstance.tree_exited.connect(OnEncounterClosed)
			self.visible = false
			set_process_input(false)
		MapNode.NodeType.COMBAT:
			pass
		MapNode.NodeType.BOSS:
			pass
	await SceneTransition.FadeIn()

func OnEncounterClosed() -> void:
	await SceneTransition.FadeOut()
	self.visible = true
	set_process_input(true)
	$MapCamera.make_current()
	await SceneTransition.FadeIn()

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
