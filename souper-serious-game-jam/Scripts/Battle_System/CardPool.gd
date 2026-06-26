extends Node

var AllCards: Array[Card] = []

func _ready() -> void:
	var dir = DirAccess.open("res://Cards_And_Actions/Cards/")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if not dir.current_is_dir():
				if file.ends_with(".tres") or file.ends_with(".res"):
					var card = load("res://Cards_And_Actions/Cards/" + file)
					if card is Card:
						AllCards.append(card)
					else:
						push_warning("File %s did not load as a Card" % file)
			file = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Could not open res://Cards_And_Actions/Cards/ — check the path exists")

	print("Loaded %d cards" % AllCards.size())
