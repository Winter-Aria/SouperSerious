class_name Battle_System
extends Node2D

@onready var player_positioner: Node2D = $Player_Positioner
@onready var enemies_positioner: Node2D = $Enemies_Positioner

const CARD_VISUAL = preload("uid://bkyrueo3rb3e0")

const ENEMY_VISUAL = preload("uid://xqow3r2rw86p")
const PLAYER_VISUAL = preload("uid://cumvw24tanyyo")

const CARD_SPACING : float = 125
const CARD_HAND_LERP_SPEED : float = 0.045
const CARD_DRAGGED_LERP_SPEED : float = 0.17

const ENEMY_SPACING : float = 150

@export var Card_Positioning_Node : Node2D

var Current_World_State : World_State = null

var Card_Visuals : Array[Card_Visual] = []
var Hand_Card_To_Visual_Card : Dictionary[Card, Card_Visual] = {}

var Held_Card_Visual : Card_Visual = null

var Scene_Actors : Array[Actor_Visual]

var Actor_Visual_To_Actor : Dictionary[Actor_Visual, Base_Actor] = {}

func _ready() -> void:
	Current_World_State = Battle_Load_Manager.Pop_World_State()
	Current_World_State.World_Player = Battle_Load_Manager.Pop_Player_State()
	
	Current_World_State.World_Player.Draw_Cards(5)
	
	create_actor_visuals()
	
	create_card_visuals()

func _process(_delta: float) -> void:
	Position_Card_Visuals()

func create_actor_visuals() -> void:
	var Player_Visual : Actor_Visual = PLAYER_VISUAL.instantiate()
	Scene_Actors.append(Player_Visual)
	Actor_Visual_To_Actor[Player_Visual] = Current_World_State.World_Player
	player_positioner.add_child(Player_Visual)
	
	var enemy_count : float = Current_World_State.Enemies.size()
	for i in range(enemy_count):
		var enemy : Enemy = Current_World_State.Enemies[i]
		var weight : float 
		if enemy_count != 1.0:
			weight = float(i) / (enemy_count-1.0)
		else:
			weight = 0.5
		
		var width : float = enemy_count * ENEMY_SPACING
		var y_offset : float = lerpf(
			-width/2.0, width/2.0, weight
		)
		
		var Enemy_Visual : Actor_Visual = ENEMY_VISUAL.instantiate()
		Scene_Actors.append(Enemy_Visual)
		Actor_Visual_To_Actor[Enemy_Visual] = enemy
		enemies_positioner.add_child(Enemy_Visual)
		Enemy_Visual.position.y = y_offset

func create_card_visuals() -> void:
	for _card : Card in Current_World_State.World_Player.Hand:
		var New_Visual : Card_Visual = CARD_VISUAL.instantiate()
		Card_Visuals.append(New_Visual)
		Card_Positioning_Node.add_child(New_Visual)
		
		New_Visual.Card_Being_Held.connect(On_Card_Visual_Picked_Up)
		New_Visual.Card_Let_Go.connect(On_Card_Visual_Picked_Dropped)
		
		New_Visual.Set_Visual_Based_Off_Card(_card)
		
		Hand_Card_To_Visual_Card[_card] = New_Visual

func Position_Card_Visuals() -> void:
	var card_count : float = Card_Visuals.size()
	for i in range(0, card_count):
		var _vis : Card_Visual = Card_Visuals[i]
		
		var weight : float 
		if card_count != 1.0:
			weight = float(i) / (card_count-1.0)
		else:
			weight = 0.5
		var width : float = card_count * CARD_SPACING
		
		var desired_pos_in_bar := Vector2(
			lerpf(-width/2.0, width/2.0, weight),
			-sin(weight * PI) * 25.0
		)
		var desired_mouse_pos : Vector2 = (
			get_global_mouse_position() - Card_Positioning_Node.global_position
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
	print("A")
	print(_card)
	print(_card_hand)
	print(Hand_Card_To_Visual_Card)
	if attempt_apply_card(_card_hand):
		_card_hand.Take_Cards_Action(Current_World_State)
		
		Remove_Card(_card_hand)
	
	Held_Card_Visual = null

const Player_Flags : int = Card.Casting_Type.Self
const Enemy_Flags : int = Card.Casting_Type.Hostiles

func attempt_apply_card(_card : Card) -> bool:
	for _actor : Actor_Visual in Scene_Actors:
		if _actor.mouse_detector.Mouse_Within:
			var Actor_Equivilent : Base_Actor = Actor_Visual_To_Actor[_actor]
			if Actor_Equivilent is Player:
				return _card.Applicable_To_Target(Player_Flags)
			elif Actor_Equivilent is Enemy:
				return _card.Applicable_To_Target(Enemy_Flags)
			else:
				assert(false, "what")
	
	return false


func Remove_Card(_card : Card) -> void:
	Current_World_State.World_Player.Remove_Card(_card)
	Card_Visuals.erase(Hand_Card_To_Visual_Card[_card])
	Hand_Card_To_Visual_Card.erase(_card)
