extends Control

@export var newItemPromptLabel: Label
@export var option1Button: Button
@export var option2Button: Button
@export var causeOptionsContainer: VBoxContainer
@export var effectOptionsContainer: VBoxContainer
@export var confirmButton: Button
@export var continueButton: Button

var mapScreen: Node2D
var selectedCause: RuleCause
var selectedEffect: RuleEffect

var pendingChoiceIsCause: bool = true
var pendingOption1
var pendingOption2

func Setup(screen: Node2D) -> void:
	$Camera2D.make_current()
	
	mapScreen = screen
	confirmButton.visible = false
	continueButton.visible = false
	option1Button.visible = true
	option2Button.visible = true
	
	confirmButton.pressed.connect(OnConfirmPressed)
	continueButton.pressed.connect(OnContinuePressed)
	
	PresentGrantChoice()

func PresentGrantChoice() -> void:
	if mapScreen.collectedCauses.size() == 0:
		pendingChoiceIsCause = true
	elif mapScreen.collectedEffects.size() == 0:
		pendingChoiceIsCause = false
	else:
		pendingChoiceIsCause = randf() < 0.5
	
	if pendingChoiceIsCause:
		var allCauses = RuleContentList.GetAllCauses()
		allCauses.shuffle()
		pendingOption1 = allCauses[0]
		pendingOption2 = allCauses[1]
		newItemPromptLabel.text = "Choose a new Cause:"
	else:
		var allEffects = RuleContentList.GetAllEffects()
		allEffects.shuffle()
		pendingOption1 = allEffects[0]
		pendingOption2 = allEffects[1]
		newItemPromptLabel.text = "Choose a new Effect:"
	
	option1Button.text = pendingOption1.displayName
	option2Button.text = pendingOption2.displayName
	
	option1Button.pressed.connect(OnOption1Picked)
	option2Button.pressed.connect(OnOption2Picked)

func OnOption1Picked() -> void:
	ConfirmGrant(pendingOption1)

func OnOption2Picked() -> void:
	ConfirmGrant(pendingOption2)

func ConfirmGrant(chosen) -> void:
	option1Button.visible = false
	option2Button.visible = false
	option1Button.pressed.disconnect(OnOption1Picked)
	option2Button.pressed.disconnect(OnOption2Picked)
	
	if pendingChoiceIsCause:
		mapScreen.collectedCauses.append(chosen)
		newItemPromptLabel.text = "Gained Cause: " + chosen.displayName
	else:
		mapScreen.collectedEffects.append(chosen)
		newItemPromptLabel.text = "Gained Effect: " + chosen.displayName
	
	if mapScreen.collectedCauses.size() > 0 and mapScreen.collectedEffects.size() > 0:
		PopulateOptions()
		confirmButton.visible = true
	else:
		continueButton.visible = true

func PopulateOptions() -> void:
	for child in causeOptionsContainer.get_children():
		child.queue_free()
	for child in effectOptionsContainer.get_children():
		child.queue_free()
	
	for cause in mapScreen.collectedCauses:
		var btn = Button.new()
		btn.text = cause.displayName
		btn.pressed.connect(func(): SelectCause(cause))
		causeOptionsContainer.add_child(btn)
	
	for effect in mapScreen.collectedEffects:
		var btn = Button.new()
		btn.text = effect.displayName
		btn.pressed.connect(func(): SelectEffect(effect))
		effectOptionsContainer.add_child(btn)

func SelectCause(cause: RuleCause) -> void:
	selectedCause = cause

func SelectEffect(effect: RuleEffect) -> void:
	selectedEffect = effect

func OnConfirmPressed() -> void:
	if selectedCause and selectedEffect:
		var rule = ActiveRule.new()
		rule.cause = selectedCause
		rule.effect = selectedEffect
		mapScreen.activeRules.append(rule)
		confirmButton.visible = false
		continueButton.visible = true

func OnContinuePressed() -> void:
	queue_free()
