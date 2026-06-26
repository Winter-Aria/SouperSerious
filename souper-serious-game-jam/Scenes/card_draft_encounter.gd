extends Node2D

signal draftComplete(pickedCards: Array[Card])

const CARD_VISUAL = preload("uid://bkyrueo3rb3e0")

@export var camera: Camera2D
@export var cardContainer: HBoxContainer

var cardPool: Array[Card] = []
var pickedCards: Array[Card] = []
var currentOffers: Array[Card] = []
var currentVisuals: Array[Card_Visual] = []
var currentConnections: Array[Callable] = []
var currentRound: int = 0

const TOTAL_ROUNDS: int = 2
const CARDS_PER_OFFER: int = 3

func Setup(pool: Array[Card]) -> void:
	camera.make_current()
	cardPool = pool.duplicate()
	cardPool.shuffle()
	StartRound()

func StartRound() -> void:
	currentRound += 1
	currentOffers = DrawOffers()
	print("Round %d: cardPool=%d, pickedCards=%d, currentOffers=%d" % [currentRound, cardPool.size(), pickedCards.size(), currentOffers.size()])
	SpawnCardVisuals()

func DrawOffers() -> Array[Card]:
	var pool: Array[Card] = cardPool.duplicate()
	pool.shuffle()
	var offers: Array[Card] = []
	for i in range(min(CARDS_PER_OFFER, pool.size())):
		offers.append(pool[i])
	return offers

const CARD_SPACING: float = 250

func SpawnCardVisuals() -> void:
	
	for visual in currentVisuals:
		if is_instance_valid(visual):
			cardContainer.remove_child(visual)
			visual.queue_free()
	currentVisuals.clear()
	currentConnections.clear()

	var start_x: float = -CARD_SPACING * (currentOffers.size() - 1) / 2.0

	for i in range(currentOffers.size()):
		var card: Card = currentOffers[i]
		var visual: Card_Visual = CARD_VISUAL.instantiate()
		cardContainer.add_child(visual)
		visual.position = Vector2(start_x + i * CARD_SPACING, 0) 
		visual.Set_Visual_Based_Off_Card(card)

		var bound_call: Callable = OnCardSelected.bind(i)
		visual.Card_Let_Go.connect(bound_call)

		currentVisuals.append(visual)
		currentConnections.append(bound_call)
	print("SpawnCardVisuals: spawned %d, container now has %d children" % [currentOffers.size(), cardContainer.get_child_count()])

func OnCardSelected(_visual: Card_Visual, i: int) -> void:

	for j in range(currentVisuals.size()):
		var visual = currentVisuals[j]
		if is_instance_valid(visual) and visual.Card_Let_Go.is_connected(currentConnections[j]):
			visual.Card_Let_Go.disconnect(currentConnections[j])

	pickedCards.append(currentOffers[i])
	SoundManager.Play(SoundManager.SfxId.CARD_SIGN)

	await get_tree().create_timer(0.4).timeout

	if currentRound < TOTAL_ROUNDS:
		StartRound()
	else:
		OnDraftComplete()

func OnDraftComplete() -> void:
	var player: Player = Battle_System.Current_World_State.Get_Player()
	if player != null:
		for card in pickedCards:
			player.Held_Deck.cards.append(card)
	draftComplete.emit(pickedCards)
	queue_free()
