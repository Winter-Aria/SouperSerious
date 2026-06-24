extends Object
class_name Battle_Load_Manager

static var _World_State_To_Load : World_State = null
static var _Stored_Player_State : Player = null

static func Queue_World_State(_world_state : World_State) -> void:
	assert(_World_State_To_Load == null)
	_World_State_To_Load = _world_state

static func Store_Player_State(_player_state : Player) -> void:
	assert(_Stored_Player_State == null)
	_Stored_Player_State = _player_state

static func Pop_World_State() -> World_State:
	assert(_World_State_To_Load != null)
	var _state = _World_State_To_Load
	_World_State_To_Load = null
	return _state

static func Pop_Player_State() -> Player:
	assert(_Stored_Player_State != null)
	var _state = _Stored_Player_State
	_Stored_Player_State = null
	return _state
