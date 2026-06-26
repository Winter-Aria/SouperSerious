extends Node2D

const PLAYER = preload("uid://bt4pythk2hnh1")
const TEST_SCENARIO = preload("uid://d0cfbbm0wrjus")

const BATTLE_SCENE = preload("uid://cwmombfsjw7i6")

func _ready() -> void:
	Battle_Load_Manager.Queue_World_State(TEST_SCENARIO)
	Battle_Load_Manager.Store_Player_State(PLAYER)
	
	await get_tree().create_timer(0.02).timeout
	
	get_tree().change_scene_to_packed(BATTLE_SCENE)
