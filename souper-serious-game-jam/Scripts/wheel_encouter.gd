extends Node2D

@export var resultLabel: Label
@export var continueButton: Button
@export var minSpinDuration: float = 1.5
@export var maxSpinDuration: float = 3.0

var chosenRule: WheelRule
var allRules: Array[WheelRule]

func Setup() -> void:
	$Camera2D.make_current()   
	
	allRules = WheelRuleList.GetAllRules()
	continueButton.visible = false
	continueButton.pressed.connect(OnContinuePressed)
	resultLabel.text = ""
	PlayStartupThenSpin()
func PlayStartupThenSpin() -> void:
	$WheelSprite.play("startup")
	await $WheelSprite.animation_finished
	StartSpin()

func StartSpin() -> void:
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
	OnSpinComplete()

func OnSpinComplete() -> void:
	chosenRule.Apply()
	resultLabel.text = chosenRule.displayName + "\n" + chosenRule.description
	continueButton.visible = true

func OnContinuePressed() -> void:
	queue_free()
