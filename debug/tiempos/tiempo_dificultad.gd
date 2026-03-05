extends Label

@export var game: GAME

func _process(_delta: float) -> void:
	text = "tiempo actual: " + str(game.tiempo_actual)
