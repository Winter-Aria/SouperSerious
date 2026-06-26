extends CanvasLayer

@onready var overlay: ColorRect = $Overlay
@onready var animPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	overlay.color = Color(0, 0, 0, 0)

func TransitionTo(scene: PackedScene) -> void:
	animPlayer.play("fade_out")
	await animPlayer.animation_finished
	get_tree().change_scene_to_packed(scene)
	animPlayer.play("fade_in")

func FadeOut() -> void:
	animPlayer.play("fade_out")
	await animPlayer.animation_finished

func FadeIn() -> void:
	animPlayer.play("fade_in")
	await animPlayer.animation_finished
