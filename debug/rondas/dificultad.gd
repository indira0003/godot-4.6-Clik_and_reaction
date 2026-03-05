extends Label

@export var game: GAME

func _process(_delta: float) -> void:
	text = "dificultad actual: " + str(game.convertidor_dificultad_string(game.session_game.dificultad_actual))
