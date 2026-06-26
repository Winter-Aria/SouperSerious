extends CanvasLayer

@export var text_1_time: float = 4
@export var text_2_time: float = 7
@export var text_3_time: float = 5
@export var time_between: float = 1
@export var rect_fade_in_time: float = 5

@onready var text_1 = $Text1
@onready var text_2 = $Text2
@onready var text_3 = $Text3
@onready var timer = $Timer
@onready var rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await fade_in_rect()
	await do_text_fading_stuff()

func do_text_fading_stuff() -> void:
	await fade_text(text_1, false)
	timer.start(text_1_time)
	await timer.timeout
	await fade_text(text_1, true)
	timer.start(time_between)
	await timer.timeout
	
	await fade_text(text_2, false)
	timer.start(text_2_time)
	await timer.timeout
	await fade_text(text_2, true)
	timer.start(time_between)
	await timer.timeout
	
	await fade_text(text_3, false)
	timer.start(text_3_time)
	await timer.timeout
	await fade_text(text_3, true)
	timer.start(time_between)
	await timer.timeout

func fade_text(text_object: RichTextLabel, fade_out: bool) -> bool:
	var fade_time = 2
	timer.start(fade_time)
	while timer.time_left > 0:
		if fade_out:
			text_object.modulate.a = timer.time_left / fade_time
		else:
			text_object.modulate.a = 1 - (timer.time_left / fade_time)
		await get_tree().process_frame
	return true

func fade_in_rect() -> bool:
	var fade_time = rect_fade_in_time
	timer.start(fade_time)
	while timer.time_left > 0:
		rect.color.a = 1 - (timer.time_left / rect_fade_in_time)
		await get_tree().process_frame
	return true
