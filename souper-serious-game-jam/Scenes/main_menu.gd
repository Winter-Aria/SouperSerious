extends Control

@export var GameScene: PackedScene

func _ready() -> void:
	$PlayButton.pressed.connect(OnPlayPressed)
	$SettingsButton.pressed.connect(OnSettingsPressed)
	$CreditsButton.pressed.connect(OnCreditsPressed)

func OnPlayPressed() -> void:
	get_tree().change_scene_to_packed(GameScene)

func OnSettingsPressed() -> void:
	$SettingsPanel.visible = true

func OnCreditsPressed() -> void:
	$CreditsPanel.visible = true
