extends Node2D

@export var resultLabel: Label
@export var ruleNameLabel: Label
@export var continueButton: Button
@export var clipboardSprite: Sprite2D
@export var rules: Array[StatusEffect] = []
@export var minSpinDuration: float = 1.5
@export var maxSpinDuration: float = 3.0

var chosenRule: StatusEffect
var allRules: Array[StatusEffect]
var isSpinning: bool = false
var hasSpun: bool = false

signal spinComplete(rule: StatusEffect)

func Setup() -> void:
	$Camera2D.make_current()
	allRules = rules
	continueButton.visible = false
	continueButton.pressed.connect(OnContinuePressed)
	clipboardSprite.visible = false
	$Area2D.input_event.connect(OnWheelClicked)

func OnWheelClicked(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and not isSpinning and not hasSpun:
		PlayStartupAnimation()

func PlayStartupAnimation() -> void:
	$Area2D.input_event.disconnect(OnWheelClicked)
	$WheelSprite.play("startup")
	await $WheelSprite.animation_finished
	StartSpin()

func StartSpin() -> void:
	isSpinning = true
	var ruleIndex = randi() % allRules.size()
	chosenRule = allRules[ruleIndex]
	$WheelSprite.play("spin")
	$WheelSprite.speed_scale = 1.0
	var fullSpinDuration = randf_range(minSpinDuration, maxSpinDuration)
	var decelerateDuration = 1.0
	var fastDuration = max(0.0, fullSpinDuration - decelerateDuration)
	await get_tree().create_timer(fastDuration).timeout
	var tween = create_tween()
	tween.tween_property($WheelSprite, "speed_scale", 0.0, decelerateDuration)
	await tween.finished
	$WheelSprite.stop()
	isSpinning = false
	hasSpun = true
	OnSpinComplete()

func OnSpinComplete() -> void:
	spinComplete.emit(chosenRule)
	ShowClipboard()

func ShowClipboard() -> void:
	clipboardSprite.visible = true
	var zoom = $Camera2D.zoom.x
	var viewportSize = get_viewport_rect().size / zoom
	var clipHeight = clipboardSprite.texture.get_size().y
	clipboardSprite.position = Vector2(0, viewportSize.y / 2.0 + clipHeight)
	continueButton.visible = false
	var targetY = 50
	var tween = create_tween()
	tween.tween_property(clipboardSprite, "position:y", targetY, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	ruleNameLabel.text = chosenRule.name
	resultLabel.text = chosenRule.description
	continueButton.visible = true

func OnContinuePressed() -> void:
	queue_free()
