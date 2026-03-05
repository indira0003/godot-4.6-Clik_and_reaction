extends Label
@export var game: GAME

func _process(_delta: float) -> void:
	text = "Ronda jugador: " + str(game.session_game.ronda_jugador_score)
