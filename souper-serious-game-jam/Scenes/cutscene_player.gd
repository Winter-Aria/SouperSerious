extends Control

@export var imageDisplay: TextureRect
@export var textLabel: RichTextLabel
@export var charactersPerSecond: float = 30.0

var cutscene: CutsceneData
var currentBeatIndex: int = 0
var isTyping: bool = false
var typingTween: Tween
var onFinishedCallback: Callable

func Setup(data: CutsceneData, onFinished: Callable) -> void:
	cutscene = data
	onFinishedCallback = onFinished
	currentBeatIndex = 0
	ShowCurrentBeat()

func ShowCurrentBeat() -> void:
	var beat = cutscene.beats[currentBeatIndex]
	imageDisplay.texture = beat.image
	StartTyping(beat.text)

func StartTyping(fullText: String) -> void:
	textLabel.text = fullText
	textLabel.visible_characters = 0
	isTyping = true
	
	var duration = fullText.length() / charactersPerSecond
	
	typingTween = create_tween()
	typingTween.tween_property(textLabel, "visible_characters", fullText.length(), duration)
	typingTween.finished.connect(OnTypingFinished)

func OnTypingFinished() -> void:
	isTyping = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		HandleAdvanceInput()

func HandleAdvanceInput() -> void:
	if isTyping:
		
		typingTween.kill()
		textLabel.visible_characters = -1   
		isTyping = false
	else:
		AdvanceToNextBeat()

func AdvanceToNextBeat() -> void:
	currentBeatIndex += 1
	if currentBeatIndex >= cutscene.beats.size():
		FinishCutscene()
	else:
		ShowCurrentBeat()

func FinishCutscene() -> void:
	if onFinishedCallback.is_valid():
		onFinishedCallback.call()
	queue_free()
