extends Resource
class_name CutsceneData

var beats: Array[CutsceneBeat] = []

func AddBeat(image: Texture2D, text: String) -> void:
	var beat = CutsceneBeat.new()
	beat.image = image
	beat.text = text
	beats.append(beat)
