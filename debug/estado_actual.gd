extends Label

@export var game: GAME

func _process(_delta: float) -> void:
	text = "Estado actual: " + str(game.session_game.estado_actual)
