extends Node

enum SfxId {

	CARD_SIGN,
	
	MAP_TRAVERSE,
	LEVER_PULL,
	RESULT_DING,

	UI_CLICK,
	UI_HOVER,
	UI_BACK,
}



enum LoopId {
	WHEEL_SPIN,
}


@export_category("State Decree / Card")
@export var cardSign: AudioStream

@export_category("World Map")
@export var mapTraverse: AudioStream
@export var leverPull: AudioStream
@export var resultDing: AudioStream
@export var wheelSpin: AudioStream  

@export_category("UI")
@export var uiClick: AudioStream
@export var uiHover: AudioStream
@export var uiBack: AudioStream



@export_category("Mixing")
@export var sfxBusName: String = "SFX"
@export var loopBusName: String = "Ambience"



var _sfxMap: Dictionary = {}
var _loopMap: Dictionary = {}
var _warnedMissing: Dictionary = {}  
const SFX_PLAYER_POOL_SIZE := 8
var _sfxPlayerPool: Array[AudioStreamPlayer] = []
var _nextPoolIndex: int = 0

var _loopPlayers: Dictionary = {}


func _ready() -> void:
	_BuildMaps()
	_BuildSfxPool()


func _BuildMaps() -> void:
	_sfxMap = {
		SfxId.CARD_SIGN: cardSign,

		SfxId.MAP_TRAVERSE: mapTraverse,
		SfxId.LEVER_PULL: leverPull,
		SfxId.RESULT_DING: resultDing,

		SfxId.UI_CLICK: uiClick,
		SfxId.UI_HOVER: uiHover,
		SfxId.UI_BACK: uiBack,
	}

	_loopMap = {
		LoopId.WHEEL_SPIN: wheelSpin,
	}


func _BuildSfxPool() -> void:
	var busName := _ResolveBus(sfxBusName)
	for i in range(SFX_PLAYER_POOL_SIZE):
		var player := AudioStreamPlayer.new()
		player.bus = busName
		add_child(player)
		_sfxPlayerPool.append(player)


func _ResolveBus(busName: String) -> String:
	if AudioServer.get_bus_index(busName) == -1:
		return "Master"
	return busName



func Play(id: SfxId, volumeDb: float = 0.0, pitchScale: float = 1.0) -> void:
	var stream: AudioStream = _sfxMap.get(id, null)
	if stream == null:
		_WarnMissingSfx(id)
		return

	var player := _GetPooledPlayer()
	player.stream = stream
	player.volume_db = volumeDb
	player.pitch_scale = pitchScale
	player.play()


func _GetPooledPlayer() -> AudioStreamPlayer:

	var player := _sfxPlayerPool[_nextPoolIndex]
	_nextPoolIndex = (_nextPoolIndex + 1) % _sfxPlayerPool.size()
	return player


func _WarnMissingSfx(id: SfxId) -> void:
	if _warnedMissing.has(id):
		return
	_warnedMissing[id] = true
	push_warning("SoundManager: no AudioStream assigned for SfxId '%s' — skipping." % SfxId.keys()[id])



func HasSound(id: SfxId) -> bool:
	return _sfxMap.get(id, null) != null



func PlayLoop(id: LoopId, volumeDb: float = 0.0, fadeInSec: float = 0.0) -> void:
	var stream: AudioStream = _loopMap.get(id, null)
	if stream == null:
		_WarnMissingLoop(id)
		return

	var player: AudioStreamPlayer = _loopPlayers.get(id, null)
	if player == null:
		player = AudioStreamPlayer.new()
		player.bus = _ResolveBus(loopBusName)
		add_child(player)
		_loopPlayers[id] = player

	if player.playing and player.stream == stream:
		return  # already running, don't restart

	player.stream = stream


	if fadeInSec > 0.0:
		player.volume_db = -40.0
		player.play()
		var tween := create_tween()
		tween.tween_property(player, "volume_db", volumeDb, fadeInSec)
	else:
		player.volume_db = volumeDb
		player.play()



func StopLoop(id: LoopId, fadeOutSec: float = 0.0) -> void:
	var player: AudioStreamPlayer = _loopPlayers.get(id, null)
	if player == null or not player.playing:
		return

	if fadeOutSec > 0.0:
		var tween := create_tween()
		tween.tween_property(player, "volume_db", -40.0, fadeOutSec)
		tween.tween_callback(player.stop)
	else:
		player.stop()


func _WarnMissingLoop(id: LoopId) -> void:
	var key := "loop_%d" % id
	if _warnedMissing.has(key):
		return
	_warnedMissing[key] = true
	push_warning("SoundManager: no AudioStream assigned for LoopId '%s' — skipping." % LoopId.keys()[id])


func HasLoop(id: LoopId) -> bool:
	return _loopMap.get(id, null) != null

func StopAllLoops(fadeOutSec: float = 0.0) -> void:
	for id in _loopPlayers.keys():
		StopLoop(id, fadeOutSec)



func PullLeverAndSpin() -> void:
	Play(SfxId.LEVER_PULL)
	PlayLoop(LoopId.WHEEL_SPIN)


func StopWheelSpinWithResult(fadeOutSec: float = 0.15) -> void:
	StopLoop(LoopId.WHEEL_SPIN, fadeOutSec)
	Play(SfxId.RESULT_DING)
