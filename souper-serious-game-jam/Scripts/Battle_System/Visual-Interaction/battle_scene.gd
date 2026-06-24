class_name Battle_Scene
extends Node2D

const CARD_SPACING : float = 125
const CARD_HAND_LERP_SPEED : float = 0.045
const CARD_DRAGGED_LERP_SPEED : float = 0.17

const PLAYER = preload("uid://bt4pythk2hnh1")

const CARD_VISUAL = preload("uid://bkyrueo3rb3e0")

@onready var card_holder: Node2D = $Card_Holder

@onready var Player_Moused: Mouse_Detector = $Player/Area2D
@onready var Enemy_Moused: Mouse_Detector = $Enemy.mouse_detector

var Card_Visuals : Array[Card_Visual] = []
var Hand_Card_To_Visual_Card : Dictionary[Card, Card_Visual] = {}

var Held_Card_Visual : Card_Visual = null

var World := World_State.new()



func _ready() -> void:
	World.World_Player = PLAYER.duplicate_deep()
	
	for _card : Card in World.World_Player.Hand:
		var New_Visual : Card_Visual = CARD_VISUAL.instantiate()
		Card_Visuals.append(New_Visual)
		card_holder.add_child(New_Visual)
		
		New_Visual.Card_Being_Held.connect(On_Card_Visual_Picked_Up)
		New_Visual.Card_Let_Go.connect(On_Card_Visual_Picked_Dropped)
		
		New_Visual.Set_Visual_Based_Off_Card(_card)
		
		Hand_Card_To_Visual_Card[_card] = New_Visual


func _process(_delta: float) -> void:
	var card_count : float = Card_Visuals.size()
	for i in range(0, card_count):
		var _vis : Card_Visual = Card_Visuals[i]
		
		var weight : float = float(i) / (card_count-1.0)
		var width : float = card_count * CARD_SPACING
		
		var desired_pos_in_bar := Vector2(
			lerpf(-width/2.0, width/2.0, weight),
			-sin(weight * PI) * 25.0
		)
		var desired_mouse_pos : Vector2 = (
			get_global_mouse_position() - card_holder.global_position
		)
		var desired_angle_in_bar : float = deg_to_rad(
			(weight - 0.5) * 15.0
		)
		var desired_angle_in_hand : float = (
			0
		)
		
		var desired_pos : Vector2
		var lerp_speed : float
		var desired_angle : float
		if Held_Card_Visual == _vis:
			desired_pos = desired_mouse_pos
			lerp_speed = CARD_DRAGGED_LERP_SPEED
			desired_angle = desired_angle_in_hand
		else:
			desired_pos = desired_pos_in_bar
			lerp_speed = CARD_HAND_LERP_SPEED
			desired_angle = desired_angle_in_bar
		
		_vis.position = _vis.position.lerp(
			desired_pos, lerp_speed
		)
		_vis.rotation = lerpf(_vis.rotation, desired_angle, 0.05)

func On_Card_Visual_Picked_Up(_card : Card_Visual) -> void:
	Held_Card_Visual = _card

func On_Card_Visual_Picked_Dropped(_card : Card_Visual) -> void:
	var _card_hand : Card = Hand_Card_To_Visual_Card.find_key(_card)
	if attempt_apply_card(_card_hand):
		_card_hand.Take_Cards_Action(World)
		
		Remove_Card(_card_hand)
	
	Held_Card_Visual = null

const Player_Flags : int = Card.Applicability.Player
const Enemy_Flags : int = Card.Applicability.Hostile

func attempt_apply_card(_card : Card) -> bool:
	if Player_Moused.Mouse_Within:
		if _card.Applicable_To_Target(Player_Flags):
			return true
	elif Enemy_Moused.Mouse_Within:
		if _card.Applicable_To_Target(Enemy_Flags):
			return true
	
	return false

func Remove_Card(_card : Card) -> void:
	World.World_Player.Remove_Card(_card)
	Card_Visuals.erase(Hand_Card_To_Visual_Card[_card])
	Hand_Card_To_Visual_Card.erase(_card)
